# ASD-STE100 Issue 9 rules, condensed

Condensed from the official spec (January 2025). Full text with examples: `asd-ste100-issue-9.pdf` in this directory. Rule numbers match the spec.

## Section 1: Words

- 1.1 Use only words that are approved in the dictionary, technical nouns, or technical verbs.
- 1.2 Use approved words only as the specified part of speech.
- 1.3 Use approved words only with their approved meanings.
- 1.4 Use only the approved forms of verbs and adjectives.
- 1.5 You can use words that fit a technical noun category.
- 1.6 Use an unapproved word only when it is a technical noun or part of one.
- 1.7 Do not use technical nouns as verbs.
- 1.8 Use technical nouns that your company, industry, or subject field approves.
- 1.9 When you select a technical noun, use one that is short and easy to understand.
- 1.10 Do not use regional, slang, or jargon words as technical nouns.
- 1.11 Do not use different technical nouns for the same item.
- 1.12 You can use verbs that fit a technical verb category.
- 1.13 Do not use technical verbs as nouns.
- 1.14 Use American English spelling unless other official directives tell you differently.

## Section 2: Multi-word nouns

- 2.1 Write multi-word nouns of no more than three words.
- 2.2 When a technical noun has more than three words, write it in full first. Then give a shorter form, or hyphenate the words that make one unit.

## Section 3: Verbs

- 3.1 Use only the verb forms that the dictionary gives.
- 3.2 Use only: infinitive, imperative, simple present, simple past, simple future, and the past participle as an adjective.
- 3.3 Use the past participle form as an adjective.
- 3.4 Do not use auxiliary verbs to make complex verb constructions.
- 3.5 Use the "-ing" form of a verb only as a technical noun or as a modifier in one.
- 3.6 Use the active voice. In descriptive writing, you can use the passive voice only when the agent is unknown.
- 3.7 Use an approved verb to describe an action, not a noun.

## Section 4: Sentences

- 4.1 Write short and clear sentences.
- 4.2 Do not omit words or use contractions to make sentences shorter.
- 4.3 Use a vertical list for complex texts.
- 4.4 Use connecting words and phrases to connect sentences with related topics.
- 4.5 Use an article (the, a, an) or a demonstrative adjective (this, these) before a noun.

## Section 5: Procedural writing

- 5.1 Use a maximum of 20 words in each sentence.
- 5.2 Write one instruction per sentence, unless two or more actions occur at the same time.
- 5.3 Write instructions in the imperative (command) form.
- 5.4 When the reader must know a condition first, put the condition before the command. Divide them with a comma.
- 5.5 Write notes only to give information, not instructions.

## Section 6: Descriptive writing

- 6.1 Give information gradually.
- 6.2 Use key words and key phrases to give the text a logical structure.
- 6.3 Use a maximum of 25 words in each sentence.
- 6.4 Use paragraphs to show related information.
- 6.5 Give each paragraph only one topic.
- 6.6 Give no paragraph more than six sentences.

## Section 7: Safety instructions

- 7.1 Use an applicable word ("warning", "caution") to identify the level of risk.
- 7.2 Start a safety instruction with a clear and accurate command or condition.
- 7.3 Give an explanation to show the risk or the possible result.

## Section 8: Punctuation and word count

- 8.1 You can use all standard English punctuation marks, but not the semicolon.
- 8.2 Use hyphens to connect words that are directly related.
- 8.3 You can use parentheses for references, item identifiers, work steps, abbreviations, singular and plural forms, explanations, and alternatives.
- 8.4 In a vertical list, a colon counts as a period and shows the end of a sentence.
- 8.5 Text in parentheses counts as one word.
- 8.6 Each of these counts as one word: numbers, numbers with units, abbreviations, alphanumeric identifiers, quoted text, titles and headings, and proper nouns.
- 8.7 Hyphenated words count as one word.

## Section 9: Writing practices

- 9.1 When a word-for-word replacement is not sufficient, use a different sentence construction.
- 9.2 Use each approved word correctly.
- 9.3 Do not make phrasal verbs.
- 9.4 Use a consistent style for terminology and wording.

## General recommendations

- GR-1 The conjunction "that": include it after verbs such as "make sure".
- GR-2 The preposition "with": make its meaning unambiguous.
- GR-3 Use pronouns carefully.
- GR-4 The pronoun "this": prefer "this" plus a noun.
- GR-5 Watch for false friends.
- GR-6 Avoid Latin abbreviations (e.g., i.e., etc.).
- GR-7 Use inclusive language.
- GR-8 Limit the possessive form.

## Machine check

The word list from Part 2 is in `ste-words.json` (847 approved words, 1144 words listed as not approved, with their approved alternatives).

- Default lint (the hook uses this): `python3 ste-lint.py <file>`
- Strict lint with the dictionary check: `python3 ste-lint.py --strict <file>`

The strict check is blind to part of speech. A hit like `bolt [v] -> ATTACH (v)` means the verb is unapproved. The noun can still be a valid technical noun (rule 1.6).
