---
name: ste-writing
description: Rewrite prose (docs, READMEs, PR descriptions, error messages, release notes, comments — never code) into ASD-STE100 Simplified Technical English to remove "AI slop". Use when asked to make writing not sound like AI, make docs clear or plain, enforce a controlled writing style, or write technical documentation that reads human. Two modes — strict (procedures/safety) and STE-flavored (general prose).
---

# ste-writing

Write prose in ASD-STE100 Simplified Technical English. This applies to documentation, READMEs, pull-request text, error messages, release notes, and comments. It does not apply to code, identifiers, or command syntax. It is not for marketing copy, essays, or anything that needs a voice. STE strips voice on purpose.

## Rules

WORDS
- Use one name for one thing. Do not call the same item by two different names.
- Use the short common word: start (not begin/commence/initiate), use (not utilize/leverage), help (not facilitate), make sure (not ensure), before (not prior to), after (not subsequent to), about (not regarding/concerning), get (not obtain/acquire), show (not demonstrate), also (not additionally/furthermore/moreover).
- Give each word one meaning. "fall" means to move down, not to decrease.
- No marketing adjectives: seamless, robust, powerful, cutting-edge, effortless, world-class, next-generation, revolutionary.
- American spelling.
- Multi-word nouns: three words maximum (rule 2.1). Write a longer technical noun in full once, then use a shorter form.

VERBS
- Active voice. "the parser reads the file", not "the file is read by the parser".
- Use a verb for an action. "analyze the log", not "perform an analysis of the log".
- No stacked auxiliaries. Not "it is important to note that this may help to improve". Write "this improves X".
- No "-ing" main verb where a simple tense works.

SENTENCES
- One instruction per sentence. Max 20 words (instruction), max 25 (descriptive).
- No contractions. Use articles: a, an, the, this, these.

PUNCTUATION
- No semicolons. Write two sentences.
- No em dash and no en dash. Use a comma, a period, or parentheses.

STRUCTURE
- One topic per paragraph, max six sentences. For steps, use a numbered vertical list, one action per item, imperative form. Put a condition before its command.

Write only the requested text. No preamble, no summary, no closing remarks.

## Modes

- **strict** — procedures, runbooks, safety text, error messages: apply every rule and both length caps.
- **STE-flavored** — general prose (READMEs, PR descriptions, docs, chat responses): apply the sentence, paragraph, active-voice, and no-phrasal-verb discipline; relax the ~900-word dictionary lockdown so the text keeps enough range to read naturally.

## Self-lint (run before returning text)

1. Any sentence over 20 words? Split it.
2. Any semicolon, em dash, or en dash? Replace with a period or comma.
3. Any contraction? Expand it.
4. Any passive voice with a known actor? Make it active.
5. Any "-ing" main verb, nominalization ("perform an analysis"), or phrasal verb ("spin up")? Replace with a plain verb.
6. Same thing named two ways? Pick one name.

Machine check: `python3 ~/.claude/skills/ste-writing/ste-lint.py <file>` (or pipe text on stdin). The score is violations per 100 words. Lower is cleaner. Target: under 3.0.

For strict mode, add `--strict`. This also checks each word against the Issue 9 dictionary (`ste-words.json`, extracted from the official spec) and gives the approved alternatives. The check is blind to part of speech, so treat noun hits on technical nouns as acceptable (rule 1.6).

The mechanical rules above are lintable and are what removes slop. Full STE also needs human judgment (the right technical noun, whether a sentence "makes good sense"). A checker cannot certify that, and slop is not about that. This skill fixes the FORM of slop. It cannot make a hollow paragraph true.

## Resources in this directory

- `reference-rules.md`: all 53 rules of Issue 9 plus the general recommendations, condensed, with rule numbers.
- `ste-words.json`: the Part 2 word list. 847 approved words, 1144 unapproved words with approved alternatives.
- `asd-ste100-issue-9.pdf`: the full official spec (434 pages). Read it when a rule needs its examples or explanation.
- `ste-lint.py`: the linter. Default mode is the heuristic check. `--strict` adds the dictionary check.

Source: https://github.com/woosal1337/blog/tree/main/videos/ep01-the-cure-for-ai-slop
Official standard (do not republish it; ASD holds the copyright): https://asd-ste100.org
