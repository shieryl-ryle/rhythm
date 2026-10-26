# ADR-014 — Lilt does not record activities; an optional "Under way" state fills the gap

- **Date:** 2026-10-26
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) G3, F-002, F-003, F-014, BR-006, BR-007, BR-009, BR-025 · [ADR-005](ADR-005-physical-activity-focus.md) · [ADR-008](ADR-008-phone-integrations-and-platform-roadmap.md) · [Sitemap](../sitemap.md) S-004

### Context
In the Figma screens, "I'll try this" leads to Today's plan, where the accepted card shows "Accepted" and a
"How did it go?" button. There is no start, timer or in-progress state. The owner compared the flow with
Strava and Apple Fitness and noticed that the "doing" has no screen. The docs never said whether that was
a decision or a gap: the PRD positions Lilt against tracking apps and makes data import P1 (F-014), but
nothing records "no in-activity experience".

### Why now
The core loop is the demo story. A person who has just said yes has nothing to tap when they are about to
start, and a judge may read the empty middle as an unfinished app.

### Options considered
1. **Do nothing and say so.** Pros: no cost; fits the planner positioning. Cons: the loop still has an
   empty middle.
2. **A minimal optional "Under way" state on the plan card.** Pros: one extra state; gives a visible middle; no
   sensors, no location. Cons: one more frame and one more thing to explain.
3. **Notification and reminder only.** Pros: small. Cons: still no screen for the doing.
4. **Record activities (GPS, pace, heart rate), like Strava or Apple Fitness.** Pros: familiar. Cons: a
   different product; needs location and sensor permissions; conflicts with BR-025 and G3 ("worthwhile,
   not just tracked"); weeks of work before the 2026-11-20 submission.

### Decision
1. Lilt does not record activities. No GPS, pace, heart rate, route or live tracking in P0 or P1. Phone and
   watch data may be imported later as an input (F-014, P1); it never replaces the reflection.
2. The loop is: suggest, accept, do it, say how it went. Between accept and reflect the plan card has an
   optional "Under way" state. The card shows "Planned" with "I'm starting"; tapping it marks the time the
   person chose ("Started 12:31 · about 20 min"), and "I'm finished" opens the reflection with "Done"
   preselected. "Not started yet" undoes a mis-tap. There is no ticking timer, and nothing counts toward the
   grid until it is reflected (EQ-002, BR-009).
3. Not starting, or never tapping "I'm finished", never creates an "overdue" or "missed" state or loss wording
   (BR-007): the card stays "Planned", then offers "How did it go?"; "Under way" clears itself after about
   3 hours. The states, copy and taps come from the UI reviewer's spec (2026-10-26) and are in DESIGN.md (Plan
   card), the sitemap (S-004) and UF-002 and UF-003. Together events offer "I'm starting" from 1 hour before;
   no location or check-in is sent to the host (BR-029).

### Why this option
It keeps Lilt a planner and coach, which is the positioning judges are asked to assess, while removing the
empty middle with the smallest change. Recording is a separate product with privacy and permission costs.

### Overrides
- **Prior ADRs:** none. Consistent with ADR-005 (not a tracker) and ADR-008 (integrations are P1).
- **Docs to reconcile (done):** PRD (non-goal line and F-003 criterion), user-flow UF-002 and UF-003,
  sitemap S-004 states, DESIGN.md (Plan card), QA test plan (TC-046).
- **Out of scope:** activity import (F-014) and widget behaviour (F-016). The widget's "Check in" and the
  notification actions are unchanged; neither needs to know about "I'm starting".

### Consequences
- **Easier:** one clear answer to "why isn't this Strava?"; the demo loop has a visible middle.
- **Harder / owed:** one new state to design, test and describe; the 200% and dark checks for it.
- **Follow-up:** frame 2.5b done; not yet drawn: the Together-event variant (an event card offers "I'm starting" from 1 hour before) and the "How did it go?" state after the planned window passes.
