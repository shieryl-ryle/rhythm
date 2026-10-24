# Mobile QA — {{PROJECT_NAME}}

> **Owns:** device coverage and mobile-specific checks. General gates and `TC-###` cases stay in
> the [QA Test Plan](qa-test-plan.md); this doc adds what only phones need.

## 1. Device matrix
| Device | OS version | Screen | Real or simulator | Why included |
|---|---|---|---|---|
| {{small iPhone}} | {{oldest supported iOS}} | small | Real | smallest layout |
| {{recent iPhone}} | {{latest iOS}} | notch / Dynamic Island | Real | safe areas |
| {{low-end Android}} | {{oldest supported Android}} | small, low RAM | Real | performance |
| {{recent Android}} | {{latest Android}} | large | Emulator OK | gestures, edge-to-edge |
| {{tablet}} | {{…}} | tablet | Only if supported | layout |

**Minimum supported OS:** iOS {{x}} · Android {{API level}} (set in `ios/Podfile` /
`android/app/build.gradle`; record the reason in an ADR).

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
| Matrix devices passed §3 | {{…}} | ☐ |
| Internal testing build (Play) installed and smoke-tested | {{…}} | ☐ |
| TestFlight build installed and smoke-tested | {{…}} | ☐ |
| Crash reporting receiving events from test builds | {{…}} | ☐ |
