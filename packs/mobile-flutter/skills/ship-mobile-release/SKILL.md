---
name: ship-mobile-release
description: Use when preparing, building, or submitting a Flutter app release to the Apple App Store or Google Play — e.g. "ship a release", "submit to the stores", "prepare version X", "TestFlight build", "upload to Play Console", or after a store rejection. Walks docs/release.md step by step with verification at each gate.
---

# Ship a mobile release

Source of truth: `docs/release.md` (steps), `docs/store-compliance.md` (rules),
`docs/store-listing.md` (listing), `docs/mobile-qa.md` (QA). Follow them; don't improvise steps.

## 1. Scope the release
- Ask: version number, which stores, what changed (link TASK-### / F-###), and whether this is a
  first-ever submission (first submissions need the full listing, compliance forms, and — for new
  personal Play accounts — the closed-testing period, which takes **at least two weeks**; warn
  early).

## 2. Freshness check (do not skip)
- Re-verify every row of `store-compliance.md` against its source link (use web search / Context7
  for current Flutter and store docs). Update "Verified" dates. If a rule changed, update the row
  and tell the user before continuing.
- Confirm the installed Flutter / Xcode / Android SDK versions meet the current requirements.

## 3. Gates — stop at the first failure and report it
1. `flutter analyze` and `flutter test` pass (show output).
2. Integration tests pass on a device or emulator.
3. Mobile QA §3 checklist — list which items were verified and how; mark unverified ones honestly.
4. Version bumped in `pubspec.yaml`; build number higher than the last uploaded build on both stores.
5. Run the `store-reviewer` agent; resolve every blocking finding.
6. Store listing up to date (`store-listing.md`); screenshots match the current UI.

## 4. Build and upload
- Follow `docs/release.md` §3 exactly for each store. Never print or commit signing secrets;
  refer to them by the names in release.md §2.
- iOS steps need macOS + Xcode. If not on a Mac, stop and say so.
- **Ask before** any irreversible or outward-facing step: uploading a build, submitting for
  review, promoting to production, or changing rollout percentage.

## 5. Record
- Add the release-log row (release.md §6), tag `vX.Y.Z+N` (ask before pushing tags).
- If rejected: quote the reason in the rejection log (store-compliance.md), add or fix the rule
  row, then restart from step 3.

## Report
Version, stores, gates passed (with evidence), what's waiting on store review, next manual step.
