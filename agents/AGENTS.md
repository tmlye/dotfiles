# General

- Create a git worktree from fresh main if you need to make edits. Never create branches without a worktree. Put worktrees in .agents/worktrees/ unless a project AGENTS.md names another location.
- When making technical decisions, do not give any weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability and long term maintainability.
- Prefer integration tests over unit tests

# Writing and Communication

Communicate clearly and concisely, in a laconic style.
Don't write overly verbose slop. Keep it simple. Write like Ernest Hemingway.

Write like a senior engineer writing for colleagues, not like a technical writer polishing marketing copy.
The goal is plain, direct English that a non-native speaker can read quickly.

Rules:
- Short sentences. One idea per sentence. It's fine if this reads as slightly clunky.
- Prefer concrete verbs: "the service calls X", "this breaks when Y". Avoid abstractions like "leverages", "facilitates", "enables", "robust", "seamless".
- No rhetorical contrast structures: never "not X, but Y", "it's less about X and more about Y", "this isn't just X".
- No em-dashes. Use a comma, a period, or parentheses.
- Semicolons only when joining two closely related full sentences, at most a couple per document.
- Metaphors are banned unless they're standard engineering terms. Nothing is "load-bearing", a "north star", or "table stakes".
- Bullet points only for actual lists (options, steps, requirements). Never bullets with a bolded label followed by a sentence. If you're explaining or arguing, write paragraphs.
- Headings are plain and descriptive ("Migration plan"), not clever.
- It's fine to hedge honestly ("we're not sure this holds under load") instead of confident filler.
- Don't summarize what you just said. End sections when the content ends.

# Code comments

Before each commit, review all added comments and remove most of them.
Shorten the ones that are left. Aim to keep only 5% of commented lines.

# Pull requests

Before pushing to an existing pull request, always check if it is already merged or not.
When talking about pull requests to the user, always provide the link to a PR instead of just the number.
Apply the "Writing and Communication" guidelines to PR descriptions.
