---
name: review-and-test
description: Review code for bugs and correctness gaps, then write failing TDD-style tests for each confirmed gap before any fix is applied. Use when the user says "review this", "check this diff", "find bugs in", or asks for a PR/file review.
---

# Review and Test

## Overview

Two phases, always in order: **review first, test second, fix never (unless asked).**

1. **Review** the reachable code path touched by the change for real correctness problems — not just the literal diff lines.
2. For each problem you're confident is real, **write a failing test** that reproduces it — before proposing or applying any fix.

The point is to leave a reproducible, verifiable trail: a test that fails today and would pass once someone fixes the bug. Don't skip straight to a fix; an unverified fix and an unverified bug report are both just guesses.

## Phase 1: Review

### What to review

- **Scope**: the full reachable code path touched by the change, not just the +/- lines. A
  pre-existing bug in logic the diff calls into or depends on is in scope if the change makes
  it reachable, more likely to trigger, or more consequential.
- **Where to look harder**: don't spread attention evenly. Real bugs cluster in high-risk
  surface area — prioritize auth/permission checks, money or billing logic, parsing of
  external/untrusted input, concurrency (shared state, locks, async ordering), and destructive
  operations (delete, overwrite, irreversible writes) over the rest of the diff.
- **Large changes**: full-depth review on the high-risk areas above first; the rest can get a
  shallower pass. If you had to limit scope this way, say so explicitly in the output rather
  than letting the report imply full coverage.
- **Categories**: correctness bugs (wrong logic, off-by-one, edge cases, race conditions,
  null/undefined mishandling), security issues (injection, unsafe deserialization, missing
  auth checks, secrets in code), silent failure modes (swallowed exceptions, error paths that
  don't surface errors).

### Confirming a finding

- **Don't flag**: style preferences with no functional impact, or anything without a concrete
  failure scenario. The scenario doesn't have to be a clean single input → wrong output pair —
  race conditions, TOCTOU bugs, deadlocks, and leaks are legitimate findings even though they
  trigger from a sequence/repetition rather than one input. The bar is "can you describe how
  this actually goes wrong," not "does it reduce to one input/output pair."
- **Verify, don't pattern-match**: trace the actual code path rather than flagging something
  because it resembles a bug you've seen before. If you can't construct a concrete scenario,
  it's not confirmed — drop it or move it to a lower-confidence note.
- **"Missing check" findings need extra verification**: before confirming a missing
  auth/validation/null check, confirm it's actually absent — not enforced elsewhere (base
  class, decorator, middleware, a wrapper the diff calls into). A false "missing auth check"
  finding undermines trust in the whole report; if you can't confirm the check truly doesn't
  exist anywhere reachable, list it under "couldn't confirm" instead.
- **Repeated occurrences of the same root cause**: don't silently skip later occurrences as
  "already found." Each call site can differ in input/context/consequence — check each one and
  give it its own test if the scenario actually differs; only collapse into one finding when
  the sites are truly identical and one test covers all of them.

## Phase 2: Test

For each confirmed finding:
1. Write a test that exercises the buggy path with the concrete failure scenario from the review.
2. Run it and confirm it **fails** for the reason you expect (not for an unrelated reason like a missing import).
3. Name the test after the behavior it verifies, not the bug number — it should stay meaningful after the fix lands.

Match the project's existing test framework and conventions; don't introduce a new one. If the project has no test setup at all, say so and ask before scaffolding one.

**If you can't execute the test** (no runner available, read-only review context, environment
you can't run): write it anyway, but say explicitly that it hasn't been executed and its
pass/fail behavior isn't verified — never state or imply a test failed for the expected reason
without having actually run it. An unrun test presented as verified is the same problem as an
unverified fix, which this skill exists to avoid.

## Boundaries

- Don't fix the bug as part of this skill unless the user explicitly asks — the deliverable is the review + the failing tests.
- Don't write tests for findings you're not confident about; a flaky or wrong test is worse than no test.
- If a finding can't be reproduced in a test (e.g. requires specific infra/timing you can't simulate), say so explicitly rather than writing a test that doesn't actually exercise the bug.

## Output

Severity rubric — use this to rank, don't eyeball it:
- **Critical**: data loss/corruption, auth/permission bypass, secret exposure, unhandled crash on a production path
- **High**: wrong result on a normal/expected input path that reaches users, with no easy recovery
- **Medium**: wrong result only on a rare/edge-case input, or a silent failure that degrades behavior without being immediately visible
- **Low**: correctness issue with minimal real-world consequence (e.g. cosmetic miscalculation, unreachable-in-practice edge case)

Structure the response as:
1. Findings, ranked by severity per the rubric above, each with a concrete failure scenario (input → wrong output/crash,
   or for concurrency/leak-style bugs, the triggering sequence and observable consequence)
2. For each finding: the test file/location and the failing test itself
3. Anything you looked at but couldn't confirm — listed separately, not mixed into confirmed findings
4. Behavior that looks off but where intended behavior isn't established by any spec/comment/
   test — don't force these into confirmed findings (that's guessing at intent) or drop them
   (that loses real signal). Name what's suspicious and why, but don't write a test for it —
   there's no known-correct behavior yet to assert against.

If nothing clears the bar for a confirmed finding, say so plainly — "no confirmed bugs found" —
rather than leaving the section empty or padding it with style nitpicks or low-confidence guesses
to have something to show. A clean review is a valid, useful result on its own.
