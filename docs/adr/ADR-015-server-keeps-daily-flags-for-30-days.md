# ADR-015 — The server keeps a day's active or paused flag for 30 days

- **Date:** 2026-10-26
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) BR-018, BR-021, BR-025, Q12 · [ADR-013](ADR-013-p1-sharing-two-flags-and-device-local-count.md) · [Review record](../reviews/challenges-in-together-2026-10-26.md)

### Context
ADR-013 keeps two daily flags ("active" and "paused") on the server so friends' and challenge members'
phones can update their own device-local together-days counts. It left open how long a day's flag stays
there (PRD Q12). A phone that is offline or opened late needs the flags to catch up.

### Why now
The Sharing screen promises that stopping removes the flags, and the opt-in sheet says where they are
stored. The screens need a retention sentence, and the Together backend (TASK-014) needs a number for its
rules and clean-up.

### Options considered
1. **7 days.** Pros: least data kept. Cons: a phone left offline over a holiday permanently misses days.
2. **30 days.** Pros: covers a month-long challenge goal and a long offline spell; still short. Cons: a new
   phone can rebuild only the last 30 days.
3. **90 days.** Pros: more catch-up. Cons: keeps far more of someone's daily pattern than catching up needs.
4. **Until the person stops sharing.** Pros: simplest to explain. Cons: an open-ended record of daily
   activity, against data minimisation.

### Decision
1. The server deletes a day's active or paused flag 30 days after that day.
2. Stopping sharing deletes all of a person's flags immediately (BR-018).
3. Each phone keeps its own count as a high-water mark (ADR-013), so a monthly goal such as "60 active days
   in November" still works at 30 days.
4. A new phone rebuilds the count only from the last 30 days of flags still shared; older days start again.
   The Sharing screen says so.
5. The Sharing screen carries: "Your daily active or resting marks are kept for 30 days so friends' phones
   can catch up, then deleted. Stopping removes them now."

### Why this option
It is the shortest window that still covers a month-long goal and a long offline spell (UI reviewer's
ruling, accepted by the owner).

### Overrides
- **Prior ADRs:** none. Fills the open point in ADR-013 (the retention window); ADR-013 is unedited.
- **Docs to reconcile (done):** PRD BR-018 and Q12.
- **Out of scope:** a restore or import of counts on a new phone (none exists; Export includes the counts but
  does not promise a restore).

### Consequences
- **Easier:** the Sharing screen and the backend rules have one number.
- **Harder / owed:** a scheduled clean-up of flags older than 30 days, with a test (TASK-014).
- **Follow-up:** TASK-014.
