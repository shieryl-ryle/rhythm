# Release runbook — Rhythm (Flutter → App Store + Google Play)

> **Status (2026-10-23):** inactive until the first store release. The challenge submission is an APK + web build ([Ops](ops.md)). Run `/ship-mobile-release` when a store release is planned.

> **Owns:** how a version gets from `main` to users on both stores. Rules the build must satisfy
> live in [Store compliance](store-compliance.md); listing copy in [Store listing](store-listing.md);
> QA in [Mobile QA](mobile-qa.md). Secret **names** only — never values.
> Official guides: [Flutter → iOS](https://docs.flutter.dev/deployment/ios) ·
> [Flutter → Android](https://docs.flutter.dev/deployment/android). Verify steps against them per
> major Flutter release (last checked: not yet; no store release before 2026-11-20. Flutter 3.47 per System Design).

## 0. Identifiers (fill once)
| Item | iOS | Android |
|---|---|---|
| App ID | Bundle ID `io.github.shierylryle.lilt` (ADR-018) | Application ID `io.github.shierylryle.lilt` (set in `app/android/app/build.gradle.kts`) |
| Store record | App Store Connect app `TBD: created by the owner` | Play Console app `TBD: after the hackathon` |
| Developer account | Apple, individual, held by the owner (US$99 a year) | TBD after the hackathon: Play developer account (personal / organization undecided) |
| Signing | Xcode automatic signing, team `TBD: TEAM_ID` | Upload key in `upload-keystore.jks` (path in key.properties, outside repo); Play App Signing enabled |

**Account type matters:** new *personal* Google Play accounts must run a closed test before
production access is granted (see Store compliance §Google Play). Whether organization accounts are exempt is
unverified: Google's page is silent and the claim comes from third parties.

**Order (ADR-018):** iOS through TestFlight first, from a Mac, under an individual Apple account; Google Play after
the hackathon.

## 1. Versioning
`pubspec.yaml`: `version: X.Y.Z+N`
- `X.Y.Z` = user-visible version (iOS CFBundleShortVersionString / Android versionName).
- `N` = build number (iOS CFBundleVersion / Android versionCode). **Must increase on every upload**
  to either store.
- Bump rules: `Z` fixes · `Y` features · `X` breaking/redesign.

## 2. Secrets & signing (names only)
| Name | Where it lives | Used for |
|---|---|---|
| `app/android/key.properties` | local only, git-ignored | Android upload keystore path + passwords |
| `upload-keystore.jks` | password manager / secure storage, **backed up** | Android upload key — losing it requires a Play support reset |
| App Store Connect API key | TBD: secure storage | CLI / CI uploads |
| `--dart-define` values (`RECAPTCHA_SITE_KEY`, `DEMO`) | build command line | API endpoints, keys — never hard-coded |

## 3. Release steps

### Pre-flight (every release)
1. `main` is green: `flutter analyze` · `flutter test` · integration tests.
2. [Mobile QA](mobile-qa.md) pre-release checklist passed on real devices.
3. [Store compliance](store-compliance.md) checklist re-verified; run the `store-reviewer` agent.
4. Version bumped (§1); release notes drafted (§5).

### Android → Google Play
1. `flutter build appbundle --release` (add `--obfuscate --split-debug-info=build/symbols` if
   used; keep symbols for crash reports).
2. Upload the `.aab` in Play Console → **Internal testing** first.
3. Install from the Play testing link on a real device; smoke test.
4. Promote: internal → closed (and open, if used) → **production**, with a **staged rollout**
   (e.g. 10% → 50% → 100%) while watching crashes.

### iOS → App Store (requires Mac + Xcode)
1. `flutter build ipa` (same obfuscation flags if used).
2. Upload: Xcode (Validate → Distribute), Apple's Transporter app, or `xcrun altool`.
3. Wait for processing → **TestFlight** internal testers → smoke test on a real iPhone.
4. Submit for review in App Store Connect with review notes and a demo account (Store listing §6).
5. On approval: release manually or with **phased release**.

## 4. After release
- Watch crash reporting (TBD: tool) and store reviews for 48 hours.
- Tag the commit `vX.Y.Z+N`; record the release below.
- Hotfix path: fix → bump build number → repeat §3 (or code push, if adopted — see toolbox).

## 5. Release notes template
```
What's new in X.Y.Z
- TBD: user-facing change
- Bug fixes and improvements
```

## 6. Release log
| Version | Date | Stores | Rollout | Notes |
|---|---|---|---|---|
| TBD: 1.0.0+1 | TBD: … | iOS / Android | TBD: 100% | TBD: … |
