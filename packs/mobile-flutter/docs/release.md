# Release runbook — {{PROJECT_NAME}} (Flutter → App Store + Google Play)

> **Owns:** how a version gets from `main` to users on both stores. Rules the build must satisfy
> live in [Store compliance](store-compliance.md); listing copy in [Store listing](store-listing.md);
> QA in [Mobile QA](mobile-qa.md). Secret **names** only — never values.
> Official guides: [Flutter → iOS](https://docs.flutter.dev/deployment/ios) ·
> [Flutter → Android](https://docs.flutter.dev/deployment/android). Verify steps against them per
> major Flutter release (last checked {{YYYY-MM-DD}}, Flutter {{version}}).

## 0. Identifiers (fill once)
| Item | iOS | Android |
|---|---|---|
| App ID | Bundle ID `{{com.example.app}}` | Application ID `{{com.example.app}}` |
| Store record | App Store Connect app `{{name}}` | Play Console app `{{name}}` |
| Developer account | {{Apple team name}} (personal / organization) | {{Play developer account}} (personal / organization) |
| Signing | Xcode automatic signing, team `{{TEAM_ID}}` | Upload key in `{{keystore path, outside repo}}`; Play App Signing enabled |

**Account type matters:** new *personal* Google Play accounts must run a closed test before
production access is granted (see Store compliance §Google Play). Organization accounts are exempt.

## 1. Versioning
`pubspec.yaml`: `version: X.Y.Z+N`
- `X.Y.Z` = user-visible version (iOS CFBundleShortVersionString / Android versionName).
- `N` = build number (iOS CFBundleVersion / Android versionCode). **Must increase on every upload**
  to either store.
- Bump rules: `Z` fixes · `Y` features · `X` breaking/redesign.

## 2. Secrets & signing (names only)
| Name | Where it lives | Used for |
|---|---|---|
| `{{key.properties}}` | local only, git-ignored | Android upload keystore path + passwords |
| `{{upload-keystore.jks}}` | password manager / secure storage, **backed up** | Android upload key — losing it requires a Play support reset |
| App Store Connect API key | {{secure storage}} | CLI / CI uploads |
| `{{.env}} / --dart-define` values | {{…}} | API endpoints, keys — never hard-coded |

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
- Watch crash reporting ({{tool}}) and store reviews for 48 hours.
- Tag the commit `vX.Y.Z+N`; record the release below.
- Hotfix path: fix → bump build number → repeat §3 (or code push, if adopted — see toolbox).

## 5. Release notes template
```
What's new in X.Y.Z
- {{user-facing change}}
- Bug fixes and improvements
```

## 6. Release log
| Version | Date | Stores | Rollout | Notes |
|---|---|---|---|---|
| {{1.0.0+1}} | {{…}} | iOS / Android | {{100%}} | {{…}} |
