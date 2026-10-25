# ADR-008 — Phone integrations in P0, iPhone and Apple Watch in P1

- **Date:** 2026-10-25
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) v0.4: F-001, F-002, F-006, F-012, F-013, F-015, F-016, F-017; BR-015, BR-022, BR-023, BR-024 · [ADR-002](ADR-002-flutter-android-web-on-device.md)

### Context
On 2026-10-25 the owner asked for:
- Calendar sync with Google or Apple Calendar that adds Rhythm activities to the calendar.
- Phone widgets and an Apple Watch app.
- Sharing achievements and open challenges to Instagram, TikTok, Facebook and X, plus invites
  (link, QR code, join code) that bring new users in.

The challenge build is Android plus web with no backend (ADR-002), no app code exists yet, and the
feature freeze is 2026-11-13. Apple Watch and Apple Calendar need an iPhone app. A watchOS app can't
be built in Flutter.

### Why now
These change platform scope and the privacy promise ("nothing leaves your phone"), and the PRD and
wireframes must reflect them before building starts.

### Options considered
1. **Put everything in P0.** Pros: the fullest demo. Cons: iOS needs a Mac, an Apple developer
   account and TestFlight. A watch app needs native Swift. Invites need a backend. It almost
   certainly misses the freeze.
2. **Put on-device integrations in P0 and the rest in P1.** Pros: share cards, an Android widget
   and device-calendar writes need no server or sign-in, so the privacy model holds. Cons: no
   iPhone or Watch demo for the judges.
3. **Put all of it in P1.** Pros: the smallest P0. Cons: loses visible, demo-friendly features
   the owner wants.

### Decision
1. P0 (Android) includes:
   - **F-015**, sharing achievement cards through the system share sheet.
   - **F-016**, a home-screen widget.
   - **F-013**, calendar sync as a stretch. It writes Rhythm events to a calendar on the device,
     which the user's Google account syncs; there is no Google sign-in in the app.
2. iPhone, Apple Watch, iOS widgets and Apple Calendar are **P1 (F-017)**.
3. The Challenges tab with in-app and external invites (link, QR code, join code) is **P1
   (F-012)**. It needs accounts and a backend; growth through invites is part of the business case
   (BRD).
4. The privacy promise becomes: **Rhythm itself sends nothing; data leaves only through actions
   the user takes** (export, calendar sync, sharing). BR-015, BR-022, BR-023 and BR-024 govern
   this.
5. F-001 setup starts with 4 paths (continue, add a new one, pick up again, start fresh), with
   follow-ups for each. F-002 allows following several activities. F-006's grid shows at the top
   of Today.

### Why this option
It keeps everything that works without a server in the challenge build, so the "your data stays
yours" story holds. Work that needs Apple tooling or a backend moves to the next phase.

### Overrides
- **Prior ADRs:** none superseded. Extends ADR-002 (the platform stays Android plus web for P0)
  and ADR-005 (the setup flow).
- **Docs to reconcile:** PRD (done in v0.4), BRD (done in v0.4), Sitemap (S-003 paths, S-004
  grid, share card sheet, widget, P1 Challenges tab), User Flow UF-001, Data Model (followed
  activities, setup path, stop reason, achievements, calendar event IDs), capabilities.md §1
  (calendar permission, widget, share; run `adapt-project`), store-compliance (calendar
  permission), System Design, QA test plan → TASK-009, TASK-012, TASK-013.
- **Out of scope:** which achievements exist (PRD Q11); one suggestion vs. one per activity
  (PRD Q10).

### Consequences
- **Easier:** demo-friendly features with no backend; a clear story for growth in P1.
- **Harder / owed:** P0 grows to 10 features plus a stretch. The build order and cut list are in
  PRD §12. The calendar permission needs a store-compliance check.
- **Follow-up:** TASK-012 (wireframes v3), TASK-013 (`adapt-project` for the new capabilities).
