# ADR-013 — P1 sharing: two daily flags, and a together-days count kept on each phone

- **Date:** 2026-10-26
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) F-010, F-012, BR-017, BR-018, BR-021, BR-025, BR-029 · [ADR-009](ADR-009-community-in-p0.md) · [ADR-010](ADR-010-together-days-instead-of-friend-streaks.md) · [User flow](../user-flow.md) UF-011, UF-012 · [Review record](../reviews/challenges-in-together-2026-10-26.md)

### Context
ADR-009 decision 4 says no grid or activity data goes to the server (BR-025). ADR-010 says "together
days" only go up (BR-021). Challenges and friends (P1) need the server to know which days each person
was active. That created two conflicts, found in review on 2026-10-26:
- BR-025 forbids what the Friends and Challenges screens show.
- BR-018 says stopping sharing removes a person's shared data, while BR-021 says the count never
  decreases. A count computed on the server from the shared flags would fall when someone stops.

### Why now
The P1 screens (11.9 P1, 10.1, 10.1a, 10.7, 7.1 P1, 7.6b) were being drawn. The captions on them
promised a choice and a removal that the rules did not allow.

### Options considered
1. **Recompute the count on the server from the flags.** Pros: simple. Cons: the number falls when a
   friend stops sharing or leaves, which breaks BR-021 and reads as a loss.
2. **Store a pair count on the server that never decreases.** Pros: survives a new phone. Cons: a number
   about two named people stays on the server after one of them stops sharing, which sits badly with
   BR-018 and BR-017.
3. **Keep the count on each person's phone as a high-water mark.** Pros: the number never goes down,
   and nothing about the person who left stays on the server. Cons: two phones can show different
   numbers, and a new phone restarts the count from the days friends still share.
4. **Hide the count when either side stops sharing.** Pros: never shows a smaller number. Cons: the
   friend loses something they felt they earned.

### Decision
1. With a one-time opt-in, only two daily flags leave the device in P1: "active" (a day with at least one
   completed or partly action) and "paused". Nothing else about activity (names, durations, grid levels,
   reflections, barriers) is shared.
2. The flags are visible only to members of a challenge or friends the user has chosen. They are stored
   on the user's Lilt account.
3. Nothing is sent until the person taps "Share my active days" in the one-time sheet. Stopping sharing
   (Settings › Sharing, with a confirmation) removes the flags from the server.
4. The "together days" count, and a challenge's group total, are kept on each phone as a high-water mark.
   While both share, each phone updates it from the shared flags. When one person stops, each phone keeps
   its last count, frozen. No pair count or group total is stored on the server.
5. Two phones may show slightly different numbers. Nothing compares or reconciles them. On a new phone the
   count restarts from the days friends still share, and the Sharing screen says so.
6. A friend who stops sharing is shown as "Not sharing right now". No notification is sent, and the
   words "stopped", "left" and "lost" are not used on screen.
7. Delete-all (BR-017) removes the shared flags, clubs joined and challenge membership from the server.
8. Signed-out people see attendee counts only; names and avatars are for signed-in people (BR-029).

### Why this option
It is the only option that satisfies BR-018 (nothing about the leaver stays on the server) and BR-021 (the
number never decreases) at once. It was recommended by the UI reviewer and accepted by the owner over
Claude's first proposal (option 2). The new-phone cost is small for a prototype, because the P0 model
already keeps all progress on the device.

### Overrides
- **Prior ADRs:** none superseded. This narrows ADR-009 decision 4 for P1 only and refines ADR-010
  decision 2 (how the count is kept). Both stay Accepted and unedited; read them together with this one.
- **Docs to reconcile (done):** PRD BR-017, BR-018, BR-021, BR-025, BR-028 · user-flow UF-011, UF-012 ·
  sitemap S-008, S-010 · QA TC-026 · DESIGN.md (danger token, 200% dialogs).
- **Out of scope:** how long the server keeps a day's flag (PRD Q12, open); a paid cloud backup (decided
  when the app is about to ship, BRD next phase).

### Consequences
- **Easier:** the P1 captions and screens say only what the app does; no loss wording to design.
- **Harder / owed:**
  - Security rules and tests for the two flags (TASK-014).
  - The retention window (PRD Q12).
  - Frames for dark mode and 200% are done for the opt-in sheet and the dialog only.
- **Follow-up:** TASK-015 (Together screens) builds the opt-in sheet and the Sharing row.
