# General

Create a git worktree from fresh main if you need to make edits. Never create branches without a worktree.
Put all worktrees in .agents/worktrees/

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

# Linear tickets

If the user did not provide a ticket number, ask them whether they want to provide one or whether you should create a ticket. Create tickets in the infra team by default.
Apply the "Writing and Communication" guidelines to Linear tickets.

# Code comments

Before each commit, review all added comments and remove most of them.
Shorten the ones that are left. Aim to keep only 5% of commented lines.

# Pull requests

Before pushing to an existing pull request, always check if it is already merged or not.
When talking about pull requests to the user, always provide the link to a PR instead of just the number.
Make sure to include the Linear ticket number in the title of the PR.
Apply the "Writing and Communication" guidelines to PR descriptions.
