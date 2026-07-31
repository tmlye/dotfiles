#!/usr/bin/env python3
"""STE anti-slop hook.

Stop: lints Claude's final message. Blocks and demands a rewrite when the
score (violations per 100 words, em dashes included) exceeds THRESHOLD.
PostToolUse (Write|Edit): lints markdown files and reports back as context.

Linter lives in ~/.claude/skills/ste-writing/ste-lint.py.
"""
import importlib.util
import json
import os
import sys

THRESHOLD = 3.0
MIN_WORDS = 60
LINTER_PATH = os.path.expanduser("~/.claude/skills/ste-writing/ste-lint.py")
PROSE_EXTENSIONS = (".md", ".mdx", ".txt", ".rst")


def load_linter():
    spec = importlib.util.spec_from_file_location("ste_lint", LINTER_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def score(report):
    words = report["words"] or 1
    return (report["total"] + report["em_dash(slop-marker)"]) * 100.0 / words


def summarize(report):
    v = {k: n for k, n in report["violations"].items() if n}
    if report["em_dash(slop-marker)"]:
        v["em_dash"] = report["em_dash(slop-marker)"]
    return json.dumps(v)


def last_assistant_text(transcript_path):
    """Text blocks of the trailing assistant entries, i.e. the final message."""
    try:
        with open(transcript_path) as fh:
            lines = fh.readlines()
    except OSError:
        return ""
    chunks = []
    for line in reversed(lines):
        try:
            entry = json.loads(line)
        except ValueError:
            continue
        etype = entry.get("type")
        if etype == "assistant":
            content = (entry.get("message") or {}).get("content")
            if isinstance(content, str):
                chunks.append(content)
            elif isinstance(content, list):
                for block in content:
                    if isinstance(block, dict) and block.get("type") == "text":
                        chunks.append(block.get("text", ""))
        elif etype == "user":
            break
    return "\n\n".join(reversed(chunks))


def handle_stop(data, linter):
    if data.get("stop_hook_active"):
        return
    text = last_assistant_text(data.get("transcript_path", ""))
    if not text.strip():
        return
    report = linter.lint(text)
    if report["words"] < MIN_WORDS:
        return
    s = score(report)
    if s <= THRESHOLD:
        return
    reason = (
        "STE lint failed on your last message: "
        f"{s:.1f} violations per 100 words (limit {THRESHOLD}). "
        f"Counts: {summarize(report)}. "
        "Rewrite the message with the ste-writing skill "
        "(~/.claude/skills/ste-writing/SKILL.md, STE-flavored mode): "
        "short sentences, active voice, plain verbs, no semicolons, "
        "no em dashes, no contractions, no banned words. "
        "Reply with only the rewritten message."
    )
    print(json.dumps({"decision": "block", "reason": reason}))


def handle_post_tool_use(data, linter):
    path = (data.get("tool_input") or {}).get("file_path") or ""
    if not path.endswith(PROSE_EXTENSIONS):
        return
    # the skill's own files quote the banned words as examples
    if os.path.dirname(LINTER_PATH) in os.path.abspath(path):
        return
    try:
        with open(path) as fh:
            text = fh.read()
    except OSError:
        return
    report = linter.lint(text)
    if report["words"] < MIN_WORDS:
        return
    s = score(report)
    if s <= THRESHOLD:
        return
    context = (
        f"STE lint: {os.path.basename(path)} scores {s:.1f} violations "
        f"per 100 words (limit {THRESHOLD}). Counts: {summarize(report)}. "
        "If you wrote this prose, revise it with the ste-writing skill "
        "(~/.claude/skills/ste-writing/SKILL.md) before you finish."
    )
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": context,
        }
    }))


def main():
    try:
        data = json.load(sys.stdin)
    except ValueError:
        return
    linter = load_linter()
    event = data.get("hook_event_name", "")
    if event == "Stop":
        handle_stop(data, linter)
    elif event == "PostToolUse":
        handle_post_tool_use(data, linter)


if __name__ == "__main__":
    main()
