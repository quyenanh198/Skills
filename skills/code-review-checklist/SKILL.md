---
name: code-review-checklist
description: A general checklist for reviewing code changes for correctness, security, and maintainability. Use when the user asks for a code review, asks you to review a diff or pull request, or asks whether a change looks safe to merge.
license: MIT
---

When reviewing code, check each of the following and report only what's actually relevant to the diff at hand — don't pad the review with items that don't apply:

**Correctness**
- Does the change do what it claims to do? Trace through the logic with at least one concrete example.
- Are edge cases handled (empty input, null/None, zero, negative numbers, concurrent access)?
- Do existing tests still cover the changed behavior? Are new tests needed?

**Security**
- Is user input validated at trust boundaries? Any injection risk (SQL, command, XSS)?
- Are secrets, tokens, or credentials hardcoded or logged?
- Are new dependencies necessary and from a trustworthy source?

**Maintainability**
- Is the change scoped to what was asked, without unrelated refactors mixed in?
- Are names, error messages, and comments clear? Comments should explain *why*, not *what*.
- Is there duplicated logic that should reuse an existing helper?

**Output format**
List findings ordered by severity (bugs and security issues first, style last). For each finding, name the file/line, describe the concrete failure scenario, and suggest a fix. If nothing significant is wrong, say so plainly instead of inventing nitpicks.
