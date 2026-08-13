---
name: review-and-test
description: Review code for bugs and correctness gaps, then write failing TDD-style tests for each confirmed gap before any fix is applied. Use when the user says "review this", "check this diff", "find bugs in", or asks for a PR/file review.
---

# Review and Test

## Overview

Two phases, always in order: **review first, test second, fix never (unless asked).**

1. **Review** the diff/file for real correctness problems.
2. For each problem you're confident is real, **write a failing test** that reproduces it — before proposing or applying any fix.

The point is to leave a reproducible, verifiable trail: a test that fails today and would pass once someone fixes the bug. Don't skip straight to a fix; an unverified fix and an unverified bug report are both just guesses.

## Phase 1: Review

Look for:
- **Correctness bugs** — wrong logic, off-by-one errors, incorrect edge-case handling, race conditions, null/undefined mishandling
- **Security issues** — injection, unsafe deserialization, missing auth checks, secrets in code
- **Silent failure modes** — swallowed exceptions, error paths that don't actually surface errors

Don't flag:
- Style preferences with no functional impact
- Hypothetical issues with no concrete failure scenario
- Anything you can't state as "given input X, this produces wrong output Y"

For each finding, verify it before reporting: trace the actual code path, don't pattern-match on how the bug "usually looks." If you can't construct a concrete failure scenario, it's not a confirmed finding — drop it or mark it as a lower-confidence note, separate from confirmed bugs.

## Phase 2: Test

For each confirmed finding:
1. Write a test that exercises the buggy path with the concrete failure scenario from the review.
2. Run it and confirm it **fails** for the reason you expect (not for an unrelated reason like a missing import).
3. Name the test after the behavior it verifies, not the bug number — it should stay meaningful after the fix lands.

Match the project's existing test framework and conventions; don't introduce a new one. If the project has no test setup at all, say so and ask before scaffolding one.

## Boundaries

- Don't fix the bug as part of this skill unless the user explicitly asks — the deliverable is the review + the failing tests.
- Don't write tests for findings you're not confident about; a flaky or wrong test is worse than no test.
- If a finding can't be reproduced in a test (e.g. requires specific infra/timing you can't simulate), say so explicitly rather than writing a test that doesn't actually exercise the bug.

## Output

Structure the response as:
1. Findings, ranked by severity, each with a concrete failure scenario (input → wrong output/crash)
2. For each finding: the test file/location and the failing test itself
3. Anything you looked at but couldn't confirm — listed separately, not mixed into confirmed findings
