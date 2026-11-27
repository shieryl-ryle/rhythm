# ADR-019 — Together (F-018) is deferred out of the first release

- **Date:** 2026-11-27
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md): F-018, BR-017, BR-025..BR-029 · [ADR-009](ADR-009-community-in-p0.md) · [ADR-002](ADR-002-flutter-android-web-on-device.md) · [ADR-018](ADR-018-apple-testflight-first-individual-account.md) · TASK-013..TASK-016

### Context
ADR-009 (2026-10-25) made community a P0 highlight: a Together tab, accounts, a Firebase backend, events, clubs,
hosting and moderation. The challenge prototype was submitted on 2026-11-21 without it. On 2026-11-27 the repo has no
Together code: no accounts, no backend, no screens, no seed data. TASK-013 to TASK-016 were never started. The
Figma file, PRD, build scope, sitemap and data model still show Together as P0.

The next goal is the first store release, Apple first (ADR-018). That release is postponed until the owner has a
Mac, and no target user has tried the app yet. Together is the only feature that needs an account, and Lilt's
privacy promise (no account, everything on the phone) is its clearest claim. Together would also bring user-generated
content rules (App Store guideline 1.2), a larger privacy label, account deletion that removes server data (BR-017)
and a moderation duty.

### Why now
The plan and the PRD disagree with the code. Leaving Together as P0 hides that the first release will not have it,
and any new work could be built against the wrong scope.

### Options considered
1. **Build Together before the first release.** Pros: the community highlight from ADR-009 exists. Cons: the largest
   remaining piece of work; adds a backend, security rules and tests, moderation, seeding and club outreach; changes
   the privacy label and the "no account" claim; and the network is empty on day one.
2. **Defer Together to a later release.** Pros: a smaller first release with a simpler privacy story and review;
   nothing built is thrown away because nothing was built. Cons: the community highlight leaves the first release,
   and the Figma and docs must be updated to say so.
3. **Do nothing.** Pros: no edits. Cons: the docs keep describing a feature that does not exist.

### Decision
1. **F-018 Together is deferred.** It is not part of the first store release. It is not cut for good; it returns
   only through a new ADR that restates the privacy, moderation and store-compliance cost.
2. **Lilt stays account-free.** No sign-in, no backend and no server-held data are added for the first release.
3. **ADR-009 decisions 1 to 7 (Together tab, backend, account, data split, location, safety, supply) are on hold.**
   ADR-009 decision 8 stands: F-013 calendar sync and F-016 widget stay P1.
4. **TASK-013 to TASK-016 are `cut`** in the implementation plan, with this ADR as the reason.
5. **The Together frames in Figma stay as design reference** and are marked as deferred, not deleted.
6. **BR-017, BR-025..BR-029 stay in the PRD** for when Together returns. They have no effect on the first release,
   because no account or server data exists.

### Why this option
The first release should keep Lilt's strongest claim (no account, nothing leaves the phone) and be small enough to
test with real people and review on the App Store. Together is the biggest risk to both, and it has no code to throw
away.

### Overrides
- **Prior ADRs:** amends [ADR-009](ADR-009-community-in-p0.md) (decisions 1 to 7 on hold; decision 8 stands). ADR-009
  is not superseded as a whole, so its file is left unchanged, as ADR-009 did for ADR-002.
- **Docs to reconcile:**
  - Done in this change: PRD (F-018 priority, data note, out-of-scope line), BRD (highlight note), build scope
    (Together frames marked deferred), implementation plan (TASK-013..016 cut, TASK-018 added).
  - Owed under TASK-018: Sitemap (Together tab and S-010, S-019..S-025), User Flow (UJ-005), Data Model (server
    collections), DESIGN.md (four-tab bar), QA test plan, and the Figma tab bar and Together frames.
- **Out of scope:** whether and when Together returns; any change to the P1 social features (challenges, friends,
  sharing), which stay P1 and depend on a backend.

### Consequences
- **Easier:** a simpler privacy label and store review; no moderation, no backend cost, no account deletion flow.
- **Harder / owed:** the docs and Figma must show the tab bar without Together. The submission pack in PR #27
  already says Together is not built and labels it "Together · Coming soon", so it stays accurate; its next-steps
  line ("then Together") should read as later, not next. The pack's video notes say it avoids "no account" only
  because Figma Settings shows a Together account row. Once TASK-018 removes that row, "no account" can be said.
- **Follow-up:** TASK-018 (reconcile the remaining docs and Figma).
