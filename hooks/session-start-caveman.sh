#!/usr/bin/env bash
# Auto-activates the "caveman" skill at the start of every session.
CONTEXT='Before your first response this session, invoke the Skill tool with skill: caveman, then follow it for the rest of the session (only \"stop caveman\" / \"normal mode\" from the user turns it off).'
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$CONTEXT"
