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
| [`commit-message`](skills/commit-message/SKILL.md) | Drafts a Conventional Commits message from the staged diff. |
| [`code-review-checklist`](skills/code-review-checklist/SKILL.md) | Reviews a diff for correctness, security, and maintainability issues. |

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
