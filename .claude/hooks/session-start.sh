#!/bin/bash
set -euo pipefail

# Only needed in Claude Code on the web / cloud sessions — the declarative
# extraKnownMarketplaces/enabledPlugins in .claude/settings.json don't
# reliably auto-install the plugin there, so force it explicitly here.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

claude plugin marketplace add quyenanh198/Skills
claude plugin install multi-ai-skills@multi-ai-skills
