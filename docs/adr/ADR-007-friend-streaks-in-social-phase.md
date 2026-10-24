# ADR-007 — Allow friend streaks in the P1 social features

- **Date:** 2026-10-24
- **Status:** Accepted (the guardrails in Decision 3 are proposed; to confirm when P1 is designed, PRD Q8)
- **Owners:** Shieryl (owner), Dzelle (input)
- **Related:** [PRD](../prd.md) F-010, F-012, BR-007, BR-018, BR-021

### Context
Dzelle's input (2026-10-24) cites Strava: people are social, and effort that others see and
celebrate keeps them going. She proposed sharing progress, adding friends, group challenges, events,
and streaks with friends. BR-007 bans streak resets and loss wording, because the primary persona is
someone returning after a break, and a broken streak is a common reason people quit.

### Why now
Social features are P1 (owner decision, 2026-10-24), but the PRD and the pitch must state the
intended direction now. BR-007 as written would forbid the owner's chosen design.

### Options considered
1. **No streaks; group goals and kudos instead.** Pros: keeps the no-guilt principle intact. Cons:
   the owner wants the motivation of a shared streak.
2. **Allow friend streaks in P1, with guardrails.** Pros: uses the social pull Dzelle described.
   Cons: a streak can end, which risks the guilt BR-007 exists to prevent.

### Decision
1. Friend streaks are allowed **only in P1 social features** (F-010, F-012), only between people who
   opt in, and never in the personal P0 experience.
2. BR-007 is scoped to personal progress. A new rule, BR-021, governs friend streaks.
3. Proposed guardrails (BR-021, to confirm):
   1. When a friend streak ends, no personal total, grid tile or history changes.
   2. The app never shows who "broke" a streak.
   3. A member's pause doesn't end the streak.
   4. Ending copy is neutral ("Start a new one together"). Nothing from the DESIGN.md "never use"
      list is used.

### Why this option
It is the owner's decision. The guardrails keep the streak's social pull while protecting the
returning user the product is built for.

### Overrides
- **Prior ADRs:** none.
- **Docs to reconcile:** PRD BR-007 and BR-021 (done in v0.3); DESIGN.md wording list when P1 is
  designed.
- **Out of scope:** how streaks are counted (daily or weekly, minimum activity). It is decided when
  P1 is designed.

### Consequences
- **Easier:** the social pitch can show a familiar, motivating mechanic.
- **Harder / owed:** P1 design must test streak copy with people who have just lapsed.
- **Follow-up:** PRD Q8.
