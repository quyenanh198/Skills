# Multi-AI Skills

A set of [Agent Skills](https://agentskills.io) — reusable, portable capabilities written once as `SKILL.md` files — that work unchanged across Claude Code, Gemini CLI, Google Antigravity, and any other tool that supports the open Agent Skills standard (Cursor, Codex CLI, and others).

## How this works

The Agent Skills spec is just a folder with a `SKILL.md` file: YAML frontmatter (`name`, `description`, ...) plus markdown instructions the agent follows. Every skill in this repo lives once, under `skills/<skill-name>/SKILL.md`, and is kept to the portable subset of frontmatter (`name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`) so it behaves identically everywhere.

Each host tool discovers this repo through its own thin manifest at the root:

| File | Host |
|---|---|
| `.claude-plugin/plugin.json` | Claude Code |
| `plugin.json` | Google Antigravity |
| `gemini-extension.json` | Gemini CLI |

All three manifests point at the same `skills/` directory — no content is duplicated per host.

## Skills included

**Synced from claude.ai account**

| Skill | Description |
|---|---|
| [`canvas-design`](skills/canvas-design/SKILL.md) | Creates visual art/posters as .png or .pdf from a design philosophy. |
| [`learn`](skills/learn/SKILL.md) | Teaches concepts for understanding, not task completion — explanations, ELI5, quizzing. |
| [`skill-creator`](skills/skill-creator/SKILL.md) | Creates and iteratively improves other skills, including running evals. |
| [`morning`](skills/morning/SKILL.md) | Renders a personal morning brief as a styled HTML artifact. |
| [`notebooklm`](skills/notebooklm/SKILL.md) | Drives NotebookLM via browser automation (reading, adding sources, Studio outputs). |
| [`spy-entry-analysis`](skills/spy-entry-analysis/SKILL.md) | Multi-timeframe technical analysis for $SPY entry points. |
| [`webnovel-planning`](skills/webnovel-planning/SKILL.md) | Plans webnovel structure, world-building, and characters. |
| [`webnovel-writer`](skills/webnovel-writer/SKILL.md) | Writes full webnovel chapters from planning documents. |
| [`skill-core-webnovel-writing`](skills/skill-core-webnovel-writing/SKILL.md) | Core webnovel prose-writing fundamentals and rules. |
| [`commit-message`](skills/commit-message/SKILL.md) | Drafts a Conventional Commits message from the staged diff. |
| [`code-review-checklist`](skills/code-review-checklist/SKILL.md) | Reviews a diff for correctness, security, and maintainability issues. |

**Token efficiency, from [caveman](https://github.com/juliusbrussee/caveman) (MIT-licensed)**

| Skill | Description |
|---|---|
| [`caveman`](skills/caveman/SKILL.md) | Ultra-compressed communication mode. Auto-activated every Claude Code session — see [Hooks](#hooks). |
| [`caveman-commit`](skills/caveman-commit/SKILL.md) | Compressed, Conventional-Commits-format commit messages. |
| [`caveman-compress`](skills/caveman-compress/SKILL.md) | Compresses natural-language memory files (e.g. `CLAUDE.md`) to save input tokens; keeps a `.original.md` backup. |
| [`caveman-explore`](skills/caveman-explore/SKILL.md) | Read-only repository explorer; returns compact `path:line` citations instead of dumping file contents into context. |
| [`caveman-review`](skills/caveman-review/SKILL.md) | Ultra-compressed PR review comments — one line per issue: location, problem, fix. |

**Coding workflow, from caveman (MIT-licensed)**

| Skill | Description |
|---|---|
| [`investigate-first`](skills/investigate-first/SKILL.md) | Diagnose ambiguous failures with evidence-ranked hypotheses before editing anything. |
| [`lean-build`](skills/lean-build/SKILL.md) | Build new feature work with strict scope and an explicit stop condition — anti-overbuilding. |
| [`migration`](skills/migration/SKILL.md) | Reversible, compatibility-safe schema/API/config/dependency migrations. |
| [`safe-refactor`](skills/safe-refactor/SKILL.md) | Restructure code while preserving behavior; verification brackets the structural edit. |
| [`surgical-patch`](skills/surgical-patch/SKILL.md) | Fix bugs at the narrowest responsible layer, with regression proof. |
| [`verify-and-stop`](skills/verify-and-stop/SKILL.md) | Prove existing work meets acceptance criteria without expanding scope. |

**Original**

| Skill | Description |
|---|---|
| [`review-and-test`](skills/review-and-test/SKILL.md) | Reviews a diff/file for real bugs, then writes a failing TDD-style test for each confirmed gap — no auto-fix. |
| [`divergent-thinking`](skills/divergent-thinking/SKILL.md) | Open-ended ideation: a wide spread of distinct options on a problem, breadth before evaluation. |
| [`fiction-writing`](skills/fiction-writing/SKILL.md) | Narrative prose support — scene structure, character voice, pacing, dialogue that avoids exposition-dumping. |

Two skills weren't ported over — `docx`, `pdf`, `pptx`, and `xlsx` are Anthropic's official skills but are licensed "Proprietary — © Anthropic, PBC," and that license explicitly forbids extracting, copying, or redistributing them outside Anthropic's own services. Committing them into this repo would violate that license, so they're intentionally excluded. Everything else here (`canvas-design`, `learn`, `skill-creator`) carries a permissive Apache-2.0 license, and the rest have no license restriction at all.

The caveman-derived skills above are a subset of the 20 skills in that repo's `skills/` directory (which is MIT-licensed, distinct from the compression engine's BSL-1.1 license). Nine were left out — `cavecrew`, `caveman-discover`, `caveman-evidence-review`, `caveman-help`, `caveman-learn`, `caveman-manage`, `caveman-optimize`, `caveman-setup`, `caveman-stats` — because they depend on the Caveman Cloud gateway, its CLI login, or its own subagents, none of which exist outside that project.

A couple of the included skills lean on Claude-specific integrations — `notebooklm` drives the Claude-in-Chrome browser extension, and `morning`/`skill-creator` reference Claude Code's scheduled-task and subagent features. The `SKILL.md` instructions will still load fine in Gemini CLI or Antigravity, but those particular capabilities may not have an equivalent there.

## Hooks

`hooks/session-start-caveman.sh` is a **Claude Code-only** extra (not part of the portable Agent Skills spec — Gemini CLI and Antigravity don't read `hooks/`). It runs on every `SessionStart` and instructs the assistant to invoke the `caveman` skill before its first response, so compressed-output mode is on by default in Claude Code. Say "stop caveman" or "normal mode" in a session to turn it off for that session. On other hosts, `caveman` still works — it just has to be invoked manually (e.g. "caveman mode").

## Installing

**Claude Code**
```bash
claude plugin install <this-repo-path-or-url>
```
Or clone it into `.claude/skills/` / add it as a marketplace plugin — see the [Claude Code plugins docs](https://code.claude.com/docs/en/plugins).

**Gemini CLI**
```bash
gemini extensions install <this-repo-url>
```
See the [Gemini CLI extensions docs](https://geminicli.com/docs/extensions/).

**Google Antigravity**
Clone or symlink this repo into your Antigravity plugins directory. See the [Antigravity plugins docs](https://antigravity.google/docs/plugins).

## Adding a new skill

1. Create `skills/<your-skill-name>/SKILL.md`.
2. Add YAML frontmatter with at least `name` and `description` — `description` is what the agent uses to decide when to load the skill, so front-load the trigger phrases.
3. Write the instructions in the body. Keep it under ~500 lines; put large reference material in separate files in the same folder and link to them.
4. Stick to the portable frontmatter fields (`name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`) unless a skill is intentionally Claude Code-only — host-specific fields (e.g. `context: fork`, `disable-model-invocation`) are ignored or rejected by other tools.
5. No manifest changes needed — every host auto-discovers everything under `skills/`.
