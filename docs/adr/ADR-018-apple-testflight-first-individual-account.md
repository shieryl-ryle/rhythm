# ADR-018 — Apple TestFlight first with an individual account, Google Play after the hackathon

- **Date:** 2026-11-04 (decided by the owner 2026-10-31)
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [ADR-002](ADR-002-flutter-android-web-on-device.md) · [ADR-017](ADR-017-release-model-two-revenue-hypotheses.md) · [Release runbook](../release.md) · [Store compliance](../store-compliance.md) · [Plan §2](../implementation-plan.md) · [PM logistics memo](../reviews/pm-logistics-spike-2026-10-27.md)

### Context
The plan assumed Google Play first. Google's Requirements page (read 2026-10-31) says apps in its "Health apps"
policy need an organization account, and it does not say whether the "Health and fitness" category is covered.
Personal accounts created after 2023-11-13 also need a closed test of 12 testers for 14 days, and the page is
silent on whether organization accounts are exempt. The owner has no registered business, so no D-U-N-S number
and no organization account. Apple's individual enrollment needs an Apple Account with two-factor sign-in and the
owner's legal name; the Developer Program costs US$99 a year, and Apple does not state a processing time.
ADR-002 put iOS out of scope for the submission. The team's machines are Windows; a teammate (Dzelle) has a Mac
and the owner may use it.

### Why now
The app ID, the 11-06 store-logistics checkpoint and tester recruitment all depend on which store goes first.
The Android application ID was still the scaffold placeholder `com.example.lilt`.

### Options considered
1. **Google Play first (the plan as written).** Pros: Windows is enough; Android is the primary device target.
   Cons: the account-type question is unanswered by Google's pages; a personal account adds a 14-day closed test;
   an organization account is not available to the owner.
2. **Apple TestFlight first, individual account, Google Play after the hackathon.** Pros: no D-U-N-S needed; no
   tester-count wait is documented for TestFlight; the owner can start now. Cons: needs a Mac for builds and
   signing; US$99 a year; Apple guideline 5.1.1(ix) says apps in highly regulated fields (healthcare is named)
   should come from a legal entity, and a wellness planner is not named, so this is a risk; the first external
   build may need Beta App Review, with no duration stated.
3. **Neither before the hackathon ends.** Pros: no paperwork risk to the build. Cons: nothing real to show for
   the release path the finals score ("path to pilot").

### Decision
1. The first store release is **iOS through TestFlight**, under an **individual** Apple Developer Program
   account held by the owner (seller name = the owner's legal name). **Google Play follows after the hackathon.**
2. The app and bundle ID is **`io.github.shierylryle.lilt`** on both platforms. It contains no hyphen or
   underscore so one string is valid for Android and iOS. It is permanent once the app record exists. No
   employer name or domain is used.
3. iOS builds, signing and uploads run on a Mac belonging to Dzelle, used with the owner's permission. No
   certificate, provisioning profile, key or `.p12` file is committed, and the owner's credentials are removed
   from that Mac after each session.
4. The listing and review notes describe Lilt as a wellness and fitness planner with no medical claims, to stay
   clear of guidelines 1.4.1 and 5.1.1(ix). If Apple asks for a legal entity, this decision is revisited.
5. The `app/` project gets an `ios/` platform folder. Every business rule that applies on Android applies on iOS
   (BR-003, BR-007, BR-014, BR-015, BR-017): no network calls with personal data, no analytics, no HealthKit, no
   permission strings the app does not use, a privacy manifest.
6. The Android application ID and namespace change to `io.github.shierylryle.lilt` now, with the Kotlin package
   moved to match (done in the same change as this ADR).
7. The Apple Developer enrollment starts as soon as the owner can, not on 2026-11-21. A first TestFlight build is
   uploaded well before the 2026-11-13 feature freeze, because Beta App Review time is unknown.
8. The statement in the Google section of the docs that organization accounts are exempt from the closed test is
   unverified (it comes from a third party, not Google's page) and is marked so.

### Why this option
It removes the account-type blocker the owner cannot solve (no registered business) and starts the only store
clock that can run during the build, at the cost of a US$99 fee and a dependence on one borrowed Mac.

### Overrides
- **Prior ADRs:** supersedes only the sentence in ADR-002 Decision 2, "iOS is out of scope for the submission"
  (ADR-002 stays Accepted; its Android and web submission targets are unchanged). The submission itself is still
  the web build and the working prototype ([Ops](../ops.md)).
- **Docs to reconcile:** [Implementation plan](../implementation-plan.md) §2 (the 2026-11-06 checkpoint and the
  lead-time items; both edited in this change), [Release runbook](../release.md) §0 (edited), `app/README.md`
  (edited), [Store compliance](../store-compliance.md) (Apple rows still unticked, Google tester-rule row marked
  unverified, edited), the PM memos (written for Google first; not edited, a refreshed timeline is owed).
- **Out of scope:** the Google Play account type and support question (deferred until after the hackathon); the
  store listing copy; the subscription (ADR-017).

### Consequences
- **Easier:** no D-U-N-S wait; one app ID string for both stores.
- **Harder / owed:** an iOS build has not been run yet and may expose layout, font or keyboard differences;
  signing depends on one Mac; the 11-02 recruiting plan assumed a Play closed test and moves to TestFlight (internal
  testers must be App Store Connect users, external testers need the free TestFlight app and possibly Beta App
  Review). Apple's Xcode 26 requirement and privacy manifest still need doing.
- **Follow-up:** the iOS platform task (Mac session, prompt prepared 2026-11-04); the senior-project-manager
  refreshing the timeline for Apple first.
