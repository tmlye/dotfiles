import re, sys, json, glob, os

def load_ste_words():
    """Word list extracted from ASD-STE100 Issue 9 Part 2. Used by --strict."""
    p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ste-words.json")
    try:
        with open(p) as fh:
            d = json.load(fh)
        return set(d["approved"]), d["unapproved"]
    except (OSError, ValueError, KeyError):
        return None

def base_forms(token):
    t = token.lower()
    out = {t}
    if t.endswith("ies"): out.add(t[:-3] + "y")
    if t.endswith("ied"): out.add(t[:-3] + "y")
    if t.endswith("es"):  out.add(t[:-2])
    if t.endswith("s"):   out.add(t[:-1])
    if t.endswith("ed"):  out.update((t[:-2], t[:-1]))
    if t.endswith("ing"): out.update((t[:-3], t[:-3] + "e"))
    return out

def describe(word, rec):
    pos = ",".join(rec["pos"])
    alts = "/".join(rec["alts"][:3]) or "see dictionary"
    return f"{word} [{pos}] -> {alts}"

def strict_violations(text, words):
    approved, unapproved = words
    hits = []
    for token in re.findall(r"[A-Za-z][A-Za-z'\-]+", text):
        forms = base_forms(token)
        if forms & approved:
            continue
        flagged = next((f for f in forms if f in unapproved), None)
        if flagged:
            hits.append(describe(token.lower(), unapproved[flagged]))
    low = text.lower()
    for phrase, rec in unapproved.items():
        if " " not in phrase:
            continue
        n = len(re.findall(r"(?<![a-z])" + re.escape(phrase) + r"(?![a-z])", low))
        if n:
            hits.extend([describe(phrase, rec)] * n)
    return hits

MARKETING = ["seamless","seamlessly","robust","powerful","cutting-edge","effortless","effortlessly",
    "world-class","next-generation","revolutionary","blazing","lightning-fast","elegant","delightful",
    "turnkey","best-in-class","state-of-the-art","game-changing","first-class","battle-tested",
    "enterprise-grade","supercharge","unlock","unleash","empower","empowers"]
BANNED = ["begin","begins","commence","commences","initiate","initiates","originate",
    "utilize","utilizes","utilizing","leverage","leverages","leveraging","facilitate","facilitates",
    "ensure","ensures","ensuring","prior to","subsequent to","obtain","obtains","acquire","acquires",
    "demonstrate","demonstrates","additionally","furthermore","moreover","comprehensive","comprehensively",
    "utilization","aforementioned","henceforth","therein","whilst","amongst","numerous","myriad","plethora",
    "in order to","a variety of","in the event that","due to the fact that","it is important to note"]
PHRASAL = ["spin up","spin down","reach out","dive into","dives into","diving into","kick off","kicks off",
    "roll out","rolls out","tear down","ramp up","circle back","drill down","spun up","reaching out"]
MODAL_HEDGE = ["it is important to note","it should be noted","it is worth noting","please note that",
    "as mentioned","as noted above"]
BE = r"(?:am|is|are|was|were|be|been|being)"
PP_IRREG = r"(?:done|made|sent|read|built|kept|held|set|put|run|written|shown|given|taken|found|got|gotten|seen|known|thrown|drawn)"

def strip_code(t):
    t = re.sub(r"```.*?```", " ", t, flags=re.S)
    t = re.sub(r"`[^`]*`", " ", t)
    return t

def sentences(text):
    out = []
    for line in text.split("\n"):
        s = line.strip()
        if not s: continue
        s = re.sub(r"^\s*#{1,6}\s*", "", s)
        s = re.sub(r"^\s*(?:[-*+]|\d+[.)])\s+", "", s)
        if not s: continue
        parts = re.split(r"(?<=[.!?:])\s+(?=[A-Z0-9\"'\-])", s)
        for p in parts:
            p = p.strip()
            if p: out.append(p)
    return out

def wc(s):
    return len([w for w in re.findall(r"[A-Za-z0-9][A-Za-z0-9'\-/]*", s)])

def count_ci(text, phrases):
    n = 0; hits = []
    low = text.lower()
    for ph in phrases:
        for m in re.finditer(r"(?<![a-z])" + re.escape(ph) + r"(?![a-z])", low):
            n += 1; hits.append(ph)
    return n, hits

def lint(text, strict=False):
    raw = text
    text = strip_code(text)
    sents = sentences(text)
    words = sum(wc(s) for s in sents) or 1
    v = {}
    longs = [(wc(s), s) for s in sents if wc(s) > 20]
    v["long_sentence(>20w)"] = len(longs)
    v["semicolon"] = text.count(";")
    v["contraction"] = len(re.findall(r"\b\w+['’](?:t|re|ve|ll|d|s|m)\b", text))
    v["passive_voice"] = len(re.findall(rf"\b{BE}\s+(?:\w+ed|{PP_IRREG})\b", text, re.I))
    v["ing_main_verb"] = len(re.findall(rf"\b{BE}\s+\w+ing\b", text, re.I))
    v["nominalization"] = len(re.findall(r"\b(?:perform(?:s|ed)?|conduct(?:s|ed)?|provide(?:s|d)?|carry out|carries out|make use of|makes use of)\b", text, re.I)) + len(re.findall(r"\b\w{4,}(?:tion|ment|ance|ence)\s+of\b", text, re.I))
    v["phrasal_verb"], _ = count_ci(text, PHRASAL)
    v["banned_word"], bh = count_ci(text, BANNED)
    v["marketing_adjective"], mh = count_ci(text, MARKETING)
    v["modal_hedge"], _ = count_ci(text, MODAL_HEDGE)
    paras = [p for p in re.split(r"\n\s*\n", raw) if p.strip()]
    v["long_paragraph(>6s)"] = sum(1 for p in paras if len(sentences(strip_code(p))) > 6)
    em = raw.count("—") + raw.count("–")
    strict_hits = []
    if strict:
        words_db = load_ste_words()
        if words_db:
            strict_hits = strict_violations(text, words_db)
            v["unapproved_word(strict)"] = len(strict_hits)
    total = sum(v.values())
    per100 = {k: round(x*100.0/words, 2) for k, x in v.items()}
    return {
        "words": words, "sentences": len(sents),
        "violations": v, "total": total,
        "total_per100w": round(total*100.0/words, 2),
        "em_dash(slop-marker)": em,
        "longest_sentence_words": (max(longs)[0] if longs else max((wc(s) for s in sents), default=0)),
        "sample_marketing": list(dict.fromkeys(mh))[:6],
        "sample_banned": list(dict.fromkeys(bh))[:6],
        "sample_unapproved": list(dict.fromkeys(strict_hits))[:10],
    }

if __name__ == "__main__":
    args = sys.argv[1:]
    strict = "--strict" in args
    files = [a for a in args if a != "--strict"]
    if not files:
        print(json.dumps(lint(sys.stdin.read(), strict=strict), indent=2)); sys.exit(0)
    exp = []
    for f in files: exp += sorted(glob.glob(f)) if any(c in f for c in "*?[") else [f]
    for f in exp:
        with open(f) as fh: r = lint(fh.read(), strict=strict)
        print(f"{os.path.basename(f):32} words={r['words']:4d} total={r['total']:3d} per100w={r['total_per100w']:6.2f} em_dash={r['em_dash(slop-marker)']:2d}")
        if strict and r["sample_unapproved"]:
            for h in r["sample_unapproved"]:
                print(f"    {h}")
