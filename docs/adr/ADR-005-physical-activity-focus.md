# ADR-005 — Focus on physical activity, with adapting people can see

- **Date:** 2026-10-24
- **Status:** Accepted
- **Owners:** Shieryl (owner), Dzelle (input)
- **Related:** [PRD](../prd.md) F-001, F-002, F-005, F-013 · [Sitemap](../sitemap.md) S-003, S-004, S-103 · TASK-004, TASK-005

### Context
A teammate (Dzelle) reviewed the concept on 2026-10-24 and found the UI read like any habit
tracker. Setup looked like "add a habit", and the adapting that the ranking does (EQ-003, EQ-009)
was not visible on screen. Her input is that people want to be active, but not every activity fits
everyone: some like running, some the gym, some pickleball. The app should first learn what someone
already likes and why, plus their memberships and free time. Then it should suggest things that fit,
including similar activities they haven't tried, and offer an alternative when a plan falls through.
The v0.2 PRD allowed any healthy behaviour (walking, sleep, water…), which spreads a ~40-action
library thin and makes "you like X, try Y" hard to show.

### Why now
The action library (TASK-004) and setup and Today screens (TASK-005) are about to be built. Their
content and inputs depend on this scope. The wireframes are also being revised now.

### Options considered
1. **Narrow to physical activity, and make adapting visible.** Pros: a richer library within one
   domain; "you like running and company → try pickleball" becomes possible; setup asks about the
   person, not about a habit form. Cons: drops sleep, hydration and similar habits from the
   prototype.
2. **Keep any healthy behaviour (v0.2).** Pros: broader appeal. Cons: a thin library per
   behaviour; adapting stays hard to show; the tracker look remains.

### Decision
1. The P0 prototype covers **physical activity only**. Activities in the library carry attributes
   the ranking can use, such as solo or social, indoor or outdoor, cost, equipment or membership
   needed, duration and intensity.
2. **Setup learns about the person first:** activities they already like and why, memberships or
   access (e.g. a gym subscription), when they are usually free, what gets in the way, what to leave
   out, their reason and their stage. "Daily goal" is not asked during setup.
3. **Today shows one hero suggestion** with its reason. "Something else" swaps through up to 2 more.
   This records the owner decision of 2026-10-23 and replaces "1–3 options" in the PRD.
4. Suggestions may include **activities similar to ones the person likes but hasn't tried**. They
   are labelled as new with a reason (e.g. "You like running with others. Pickleball is social and
   quick to learn").
5. **"My plan fell through"** is an option under "Not today". It offers an alternative that fits the
   same time slot.
6. **Timing:** setup asks when the person is usually free. A suggestion shows a suggested time from
   those slots. "Didn't fit my schedule" is a reflection barrier that shifts future timing. Reading
   the phone's calendar on the device is a stretch goal (F-013), built only if time allows before
   the 2026-11-13 freeze.
7. After each reflection, the app says **what it will change** (e.g. "Got it. Tomorrow's idea will
   be shorter"), so the adapting is visible.

### Why this option
Dzelle's core criticism was that the adapting was invisible. Narrowing the domain is what lets the
same deterministic ranking produce suggestions that visibly change and expand.

### Overrides
- **Prior ADRs:** none superseded. Records the 2026-10-23 one-hero decision, which until now lived
  only in the Sitemap.
- **Docs to reconcile:** PRD (done in v0.3), BRD (done in v0.3), Sitemap S-003/S-004/S-103, User
  Flow UF-001/UF-002/UF-005, Data Model (activity attributes, free-time slots), Methods (EQ-003 terms
  for liked-activity similarity and time fit; EQ-004 templates), DESIGN.md Layout ("max 3 option
  cards"), QA test plan, seed data → TASK-009.
- **Out of scope:** social features (ADR-007, P1); health-platform data (P1).

### Consequences
- **Easier:** a clear story for judges ("finds ways to be active that fit you"); the library is
  authored for one domain.
- **Harder / owed:** the library needs activity attributes and a similarity notion; setup must stay
  under 2 minutes despite asking more.
- **Follow-up:** TASK-004 (library scope), TASK-009 (doc reconciliation).
