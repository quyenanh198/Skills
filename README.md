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

Two skills weren't ported over — `docx`, `pdf`, `pptx`, and `xlsx` are Anthropic's official skills but are licensed "Proprietary — © Anthropic, PBC," and that license explicitly forbids extracting, copying, or redistributing them outside Anthropic's own services. Committing them into this repo would violate that license, so they're intentionally excluded. Everything else here (`canvas-design`, `learn`, `skill-creator`) carries a permissive Apache-2.0 license, and the rest have no license restriction at all.

A couple of the included skills lean on Claude-specific integrations — `notebooklm` drives the Claude-in-Chrome browser extension, and `morning`/`skill-creator` reference Claude Code's scheduled-task and subagent features. The `SKILL.md` instructions will still load fine in Gemini CLI or Antigravity, but those particular capabilities may not have an equivalent there.

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
