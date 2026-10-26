# ADR-010 — "Together days" instead of friend streaks

- **Date:** 2026-10-25
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) F-010, F-012, BR-007, BR-021 · supersedes [ADR-007](ADR-007-friend-streaks-in-social-phase.md)

### Context
ADR-007 allowed opt-in friend streaks in P1. The round-2 UI review (2026-10-25) pointed out that
the welcome screen promises "No streaks to lose" while the P1 Friends screens show a friend streak
that "has ended". A streak that can end is a streak you can lose. The primary persona is someone
returning after a break, and the moment a streak ends is when such people tend to quit (BR-007).
What Dzelle's Strava input valued was being seen and celebrated together, not the risk of losing.

### Why now
The P1 screens are part of the pitch, and the contradiction is visible on the first screen of the
app.

### Options considered
1. **Keep friend streaks and change the welcome copy** to "No personal streaks". Pros: a familiar
   mechanic. Cons: weakens the main differentiator, and the guilt risk remains for the main
   persona.
2. **"Together days":** a shared count that only goes up, milestone celebrations, and an optional
   weekly shared goal that resets each Monday without loss. Pros: keeps the social pull, honours
   the promise and BR-007, and is simpler to build. Cons: less pressure, which may motivate some
   people less.

### Decision
1. P1 has **no streaks of any kind**. The welcome promise "No streaks to lose" holds everywhere.
2. **Together days:** the number of days two friends were both active, ever. It never decreases
   or resets.
3. **Milestones** (e.g. 10, 25 or 50 together days) are celebrated with a cheer prompt. Nothing
   ever "ends".
4. **Optional weekly shared goal** (e.g. "3 days together this week"). It starts fresh each Monday,
   with no "missed" or "lost" copy and no carry-over penalty.
5. BR-021 is rewritten to match. BR-007 now applies to everything, with no exception for friend
   features.

### Why this option
It keeps what motivates (seen and celebrated together) and drops what drives people away (loss),
which is the product's core promise.

### Overrides
- **Prior ADRs:** supersedes ADR-007.
- **Docs to reconcile:** PRD F-010, BR-007, BR-021, vocabulary, Q8 (done); BRD next-phase list
  (done); wireframes v5 10.7 and 10.8 (done); App Overview doc (done).
- **Out of scope:** the exact milestone numbers (decide when P1 is designed).

### Consequences
- **Easier:** consistent messaging; no "streak ended" states to design or moderate.
- **Harder / owed:** none significant.
- **Follow-up:** none.
