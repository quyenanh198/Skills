---
name: commit-message
description: Drafts a conventional commit message from the currently staged git changes. Use when the user asks for a commit message, wants to commit their changes, or asks what a good commit summary would be.
license: MIT
---

Run `git diff --staged` (or `git diff` if nothing is staged) using your available tools and read the output.

From that diff, write a commit message in the Conventional Commits format:

```
<type>(<optional scope>): <short summary>

<optional body explaining why, not what>
```

Rules:
- Pick `type` from: feat, fix, refactor, docs, test, chore, perf, style, build, ci.
- Keep the summary line under 72 characters, imperative mood ("add", not "added").
- Only add a body when the "why" isn't obvious from the summary and diff alone.
- If there are no staged or unstaged changes, say so instead of inventing a message.
