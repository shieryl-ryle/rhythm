# Mobile QA — Rhythm

> **Owns:** device coverage and mobile-specific checks. General gates and `TC-###` cases stay in
> the [QA Test Plan](qa-test-plan.md); this doc adds what only phones need.

## 1. Device matrix
| Device | OS version | Screen | Real or simulator | Why included |
|---|---|---|---|---|
| Low-end Android phone (team member's) | Oldest Android in the team, ≥ minSdk | small, low RAM | Real | performance, smallest layout |
| Recent Android phone (team member's) | Android 16 / API 36 if available | large | Real | notifications permission (13+), edge-to-edge, predictive back |
| Android emulator (Pixel profile) | API 36 | medium | Emulator | integration tests (TC-001, TC-005) |
| Desktop Chrome, phone-width viewport | current | 412 × 915 | Browser | judges' web demo (TC-040) |
| iPhone / tablet | — | — | — | Not supported for the submission (ADR-002) |

**Minimum supported OS:** Android: Flutter's default `minSdk` unless a package needs higher
(**unverified**, confirm in `app/android/app/build.gradle.kts` when scaffolding; record in an ADR
if raised). iOS: not supported yet.

## 2. Automated
| Layer | Command | Covers |
|---|---|---|
| Static | `flutter analyze` | lints, types |
| Unit / widget | `flutter test` | logic, widgets, golden tests for key screens |
| Integration | `flutter test integration_test` | happy path UJ-001 on a device/emulator |

## 3. Mobile-specific checks (every release)
- [ ] **Permissions:** first-time prompt, denied, "don't ask again", revoked in Settings — app explains and recovers
- [ ] **Offline / poor network:** clear message, no crash, no lost input; retries work
- [ ] **Lifecycle:** background → foreground, phone call interruption, app killed and relaunched mid-task
- [ ] **Safe areas & notches:** nothing under the status bar, home indicator, or camera cutout
- [ ] **Keyboard:** fields not hidden; "next/done" order sensible; dismissible
- [ ] **Back navigation:** Android back button / predictive back and iOS swipe-back behave
- [ ] **Dark mode** and **large text / dynamic type** — no clipped or overlapping text
- [ ] **Accessibility:** screen reader labels (TalkBack / VoiceOver), tap targets ≥ 44–48 pt/dp, contrast
- [ ] **Deep links / notifications** open the right screen, logged in or not
- [ ] **Fresh install and upgrade from previous version** — data migrates, no forced logout
- [ ] **Performance:** cold start time, scroll smoothness on the low-end device

## 4. Pre-release sign-off
| Check | Who | Result |
|---|---|---|
| Matrix devices passed §3 | Team (TBD per release) | ☐ |
| APK installed from the shared link and smoke-tested (Play internal testing: not used yet) | Team (TBD) | ☐ |
| TestFlight: not applicable (no iOS) | — | ☐ |
| Crash reporting: none in P0 (no analytics SDKs, BR-015); manual crash notes | — | ☐ |

## 5. Rhythm-specific checks
- [ ] Notification permission denied on Android 13+ → app explains, works fully (TC-041, EV-006)
- [ ] Reminder tap opens `/today`; post-lapse check-in opens `/way-back` (TC-041)
- [ ] No reminders in quiet hours or during a pause, checked over 3 real days (EQ-005)
- [ ] Airplane mode: all P0 flows work; AI falls back silently (TC-043)
- [ ] Commit grid readable with TalkBack (tile semantics labels) and at 200% text size
- [ ] Delete-all → relaunch → consent screen, no old data (TC-025)
