# ADR-009 — Community (events and clubs) is a real P0 feature

- **Date:** 2026-10-25
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) v0.5: F-018, F-012, F-013, F-016; BR-015, BR-017, BR-025..BR-029 · [ADR-002](ADR-002-flutter-android-web-on-device.md) · [ADR-008](ADR-008-phone-integrations-and-platform-roadmap.md)

### Context
The owner named community discovery a highlight of the product (2026-10-25). The reference is
Reclub-style local clubs and sessions that people browse, RSVP to and host. It continues
Dzelle's Strava insight (being seen and doing it with others motivates) and gives the "try
pickleball" suggestion a concrete next step. Until now, P0 had no accounts and no backend
(ADR-002), and all social features were P1 (ADR-007, ADR-008).

### Why now
The build hasn't started and the feature freeze is 2026-11-13. A backend changes the
architecture, the privacy promise and the consent copy, so it has to be decided before TASK-001.

### Options considered
1. **Demo preview:** seeded sample clubs and events stored on the device, with no server. Pros:
   no backend and the privacy model stays intact. Cons: not real, since nobody can host or see
   who's actually going.
2. **Real feature in P0:** accounts, a backend, location, real hosting and RSVPs. Pros: a
   working highlight for judges and a real growth story. Cons: about a week of work, new
   privacy, safety and moderation duties, and an empty-network problem on day one.
3. **Wireframes only.** Pros: no build cost. Cons: the highlight can't be used.

### Decision
1. **F-018 Community** is P0. A 4th tab, **Together**, lets people:
   - browse **events** and **clubs** near them;
   - filter by activity, level and time;
   - open an event, see who's going (display names only) and RSVP. An RSVP adds the event to
     Today's plan.
   - join a club;
   - host an event at a public place;
   - report or block.
2. **Backend:** Firebase Authentication (email link and Google sign-in) and Cloud Firestore, with
   security rules enforced on the server. It uses the free Spark tier, and the stack stays
   Flutter (ADR-002 otherwise unchanged).
3. **An account is needed only for Together.** Every other feature still works signed out and on
   the device.
4. **Data split.** The server holds the community profile (display name, optional photo,
   approximate area), clubs, events, RSVPs and reports. **Health data never goes to the server**:
   no reflections, barriers, grid, observations or setup answers (BR-025).
5. **Location** is approximate: an area or district, chosen by the user or taken from coarse
   location if they allow it. Precise location is never stored (BR-026).
6. **Safety:**
   - Hosts accept the community guidelines.
   - Events must be at public venues.
   - Every event and profile can be reported or blocked, and reported content is hidden after a
     threshold until reviewed.
   - Users must be 18+ to use Together (BR-027, BR-028).
7. **Supply:** the prototype launches with seeded clubs and events (DS-006) plus outreach to 2–3
   real local clubs. Seeded items are labelled.
8. To make room, **F-013 Calendar sync and F-016 Android widget move to P1.** F-012 (group
   challenges, QR and code invites, friend streaks) stays P1 and will live in Together.

### Why this option
The owner chose option 2 as the highlight. Keeping health data on the device and the account
optional limits the privacy cost to what community needs.

### Overrides
- **Prior ADRs:** amends ADR-002 (P0 now has a backend for Together only; app data stays in
  drift) and ADR-008 decision 1 (F-013 and F-016 leave P0). Neither is superseded as a whole.
- **Docs to reconcile:** PRD (done in v0.5), BRD (done in v0.5), System Design (Firebase Auth,
  Firestore, rules, data split), Data Model (server collections), capabilities.md §1 (accounts,
  backend, location, user-generated content: run `adapt-project`), store-compliance (location,
  UGC moderation, account deletion), QA test plan (security-rule tests, BR-025..029), Sitemap,
  User Flow, Ops (Firebase project, budget alert) → TASK-009, TASK-013, TASK-014..016.
- **Out of scope:** chat or messaging between users (not planned); payments for events; P1
  challenges and friend streaks.

### Consequences
- **Easier:** a working, demo-able highlight; a real growth loop.
- **Harder / owed:**
  - Security rules and their tests.
  - Moderation with a manual review queue for the prototype.
  - Account deletion that also removes server data (BR-017).
  - Seeding and outreach.
  - About a week of build time.
- **Follow-up:** TASK-013 (`adapt-project`), TASK-014 (backend), TASK-015 (Together screens),
  TASK-016 (seed data and club outreach).
