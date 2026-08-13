# personal-skills plugin — design record

**Status:** Implemented. This doc was written after the fact to record the
design and decisions — the plugin was built iteratively in conversation
rather than spec-first.

## Purpose

A personal Claude Code plugin bundling skills across a few domains the user
works in regularly: token-efficient communication, coding workflow
discipline, open-ended ideation, and fiction writing. Not intended for
publication or multi-user distribution — a private toolkit.

## Decisions

- **Target: Claude Code plugin format only.** The user's stated goal was
  eventually to have skills usable across Claude, Gemini, and other models,
  but for v1 the format is Claude Code's native plugin structure
  (`.claude-plugin/plugin.json` + `skills/<name>/SKILL.md`). Cross-tool
  portability (e.g. a shared-source-plus-adapters setup, as used by the
  caveman repo's own `registry.json`/`generated/<target>` system) was
  explicitly deferred — not worth the overhead for a personal, single-tool
  plugin. Revisit only if maintaining duplicate skill copies across tools
  becomes a real pain.
- **No marketplace.json (superseded).** Originally distribution was
  local-only (add the directory directly as a plugin). This turned out to
  block `/plugin marketplace add` / `/plugin install`, which require a
  `.claude-plugin/marketplace.json` to discover installable plugins from a
  repo URL — the plugin manifest alone isn't enough. A self-referencing
  `marketplace.json` (`source: "./"`) was added later so the repo can
  install itself via the standard marketplace flow; see
  [`.claude-plugin/marketplace.json`](../../../.claude-plugin/marketplace.json).
- **Flat skill namespace.** Claude Code requires skill names to be unique
  at the plugin level; skills are not nested under per-domain folders.
  Domain grouping (coding / brainstorming / writing / token-efficiency) is
  informal and documented in the README, not structural.
- **Adopted 11 skills from the [caveman](https://github.com/juliusbrussee/caveman)
  repo** rather than writing equivalents from scratch, after checking their
  `skills/` directory is MIT-licensed (the repo's BSL-1.1 terms apply only
  to its compression engine and Go binaries, not the skill definitions).
  Of caveman's 20 skills, 9 were dropped because they depend on
  infrastructure this plugin doesn't have (Caveman Cloud gateway, its CLI
  login, its own subagents, a session-log-reading hook):
  `cavecrew`, `caveman-discover`, `caveman-evidence-review`, `caveman-help`,
  `caveman-learn`, `caveman-manage`, `caveman-optimize`, `caveman-setup`,
  `caveman-stats`. The remaining 11 are self-contained. When merging, extra
  per-skill files that were platform-specific to other agent tools
  (`agents/openai.yaml`), or non-functional documentation/test scaffolding
  (`README.md`, `SECURITY.md`, `caveman-explore`'s test harness) were
  trimmed, keeping only `SKILL.md` — except `caveman-compress`, whose
  `scripts/` directory is the actual implementation the skill runs, so it
  was kept.
- **`caveman-review` and `review-and-test` both stayed**, despite overlapping
  on "review code," because they solve different problems: `caveman-review`
  produces ultra-compressed one-line PR comments (token-minimal signal),
  while `review-and-test` does a fuller correctness review and then writes
  failing TDD tests for confirmed gaps. Kept as distinct tools rather than
  merged.
- **`caveman` mode auto-activates every session** via a `SessionStart` hook,
  rather than requiring the user to invoke it manually each time. The hook
  emits an instruction (`additionalContext`) telling the assistant to
  invoke the `caveman` skill before its first response, rather than
  duplicating the skill's content into the hook script — keeps
  `skills/caveman/SKILL.md` as the single source of truth.

## Structure

```
.claude-plugin/
  plugin.json               # name: personal-skills, description, version
hooks/
  hooks.json                # registers SessionStart -> session-start-caveman.sh
  session-start-caveman.sh  # emits additionalContext activating `caveman` skill
skills/
  caveman/                  # compressed communication mode (auto-activated)
  caveman-commit/           # compressed commit messages
  caveman-compress/         # compress memory files (+ scripts/)
  caveman-explore/          # read-only repo explorer, compact citations
  caveman-review/           # ultra-compressed PR review comments
  investigate-first/        # diagnose ambiguous failures before editing
  lean-build/                # scoped feature building, anti-overbuild
  migration/                 # reversible compat-safe migrations
  safe-refactor/              # behavior-preserving restructuring
  surgical-patch/             # narrow-scope bug fixes
  verify-and-stop/            # prove acceptance criteria, no scope creep
  review-and-test/            # NEW: bug review, then TDD tests for gaps found
  divergent-thinking/         # NEW: open-ended ideation
  fiction-writing/            # NEW: narrative prose support
README.md
```

14 skills total: 11 adopted from caveman (trimmed), 3 written new for this
plugin.

## The 3 original skills

**`review-and-test`** — Two-phase: review a diff/file for real correctness
bugs (with a concrete failure scenario required for each finding), then
write a failing test reproducing each confirmed gap. Does not apply fixes
unless explicitly asked; the deliverable is the review plus the failing
tests.

**`divergent-thinking`** — Generates a wide spread of distinct options on a
problem: multiple mechanisms, relaxed/tightened constraints, different
stakeholder lenses, reversal, adjacent-domain analogies. Deliberately does
not converge on a recommendation or produce a spec unless asked — that's a
separate, later step.

**`fiction-writing`** — Narrative prose support: scene structure (hook /
movement / landing), distinct character voices, dialogue that avoids
info-dumping, show-don't-tell for emotional beats, checking established
canon before writing.

## Verification performed

- All JSON files (`plugin.json`, `hooks.json`) parse as valid JSON.
- Every `skills/*/SKILL.md` has a YAML frontmatter block with `name` and
  `description`; every `name` matches its containing directory; no
  duplicate names across the 14 skills.
- `hooks/session-start-caveman.sh` runs and emits valid JSON with the
  expected `hookSpecificOutput.additionalContext` shape.
- Not yet verified: actually loading the plugin inside a running Claude
  Code session (no `claude` CLI was available in the shell used to build
  this) to confirm skills trigger correctly and the hook fires end-to-end.

## Explicitly out of scope for v1

- Cross-tool adapters (Gemini, Codex, etc.) generated from a shared source.
- `marketplace.json` for others to install — added on 2026-08-13 for a
  different reason (installability, not multi-plugin publishing); still no
  goal to host third-party plugins in this marketplace.
- Any skill beyond the 14 listed above.
