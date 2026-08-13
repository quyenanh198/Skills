---
name: divergent-thinking
description: Open-ended ideation — generate a wide spread of distinct options or angles on a problem, breadth before evaluation. Use when the user says "brainstorm", "give me options for", "what are some ways to", or wants a range of possibilities rather than one recommendation.
---

# Divergent Thinking

## Overview

Generate breadth, not a decision. This skill produces a spread of genuinely different options — not a recommendation with caveats, and not a spec. If the user wants one of these options developed into a real design afterward, that's a separate, later step (a different kind of skill), not part of this one.

**Core principle:** Quantity and variety first. Evaluation, narrowing, and recommendations come only if asked, and only after the spread exists.

## Process

1. **Restate the problem in one line** — confirms you're diverging on the right question.
2. **Generate options from multiple angles**, not just variations on the first idea that comes to mind:
   - Different mechanisms (how it could work structurally)
   - Different constraints relaxed (what if budget/time/scale weren't a limit? what if they were much tighter?)
   - Different stakeholder lenses (what would this look like solved from the user's view vs. the maintainer's view vs. a competitor's view?)
   - Opposites/reversal (what's the inverse of the obvious approach?)
   - Adjacent domains (how do other fields solve a structurally similar problem?)
3. **Push past the obvious three.** The first few options are usually the ones anyone would think of; keep going until you hit ones that are actually distinct from each other, not rephrasings of the same idea.
4. **State each option in 1-3 sentences** — enough to evaluate later, not a full writeup. One clear trade-off or cost per option, since a trade-off-free option is usually underspecified.

## What NOT to do

- Don't converge on a favorite unless explicitly asked — no "but I'd recommend option 2" unless the user requests it.
- Don't pad the list with near-duplicates to hit a target count; five genuinely distinct options beat twelve variations on two ideas.
- Don't fact-check or feasibility-gate too early — an option that seems impractical at first glance can still be worth stating; let the user filter.
- Don't turn this into a spec or a plan — no architecture diagrams, no step-by-step implementation. That's a different job.

## Output

A flat list of options, each with:
- A short name/label
- 1-3 sentences describing the angle
- The main trade-off or cost

Close by asking whether the user wants to narrow, combine, or develop any of these further — don't do that step unprompted.
