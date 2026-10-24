# ADR-002 — Flutter app for Android + web demo, on-device data

- **Date:** 2026-10-23
- **Status:** Accepted
- **Owners:** Shieryl (team)
- **Related:** [PRD](../prd.md) §2, F-001..F-008, BR-015, BR-017 · [System Design](../system-design.md) §6 · [ADR-003](ADR-003-gemini-via-firebase-ai-logic.md)

### Context
The PRD requires a mobile app (action cards, quick selections, progress views; no chatbot) with
P0 data stored on the device only (BR-015) and export and delete-all (BR-017). The deadline is
2026-11-20 (about 4 weeks), the team is 2–4 people who have shipped with **Flutter**, and the
development machine is Windows (no Mac). Judges must be able to try the prototype easily. The
budget is $0 (free tiers).

### Why now
System Design, the data model, and the walking-skeleton task all depend on the stack.

### Options considered
| Driver | Flutter | Expo (React Native) | Native Kotlin (Android) |
|---|---|---|---|
| Team experience | ✅ shipped before | ⚠️ not mentioned | ⚠️ not mentioned |
| Android + click-to-try web demo from one codebase | ✅ Android + web builds | ✅ Android + web | ❌ Android only |
| iOS later without a rewrite | ✅ (needs a Mac or cloud build) | ✅ (EAS cloud builds) | ❌ |
| Typed on-device SQL + export/delete-all | ✅ drift (works on web too) | ✅ expo-sqlite | ✅ Room |
| Local notifications (F-008) | ✅ flutter_local_notifications | ✅ expo-notifications | ✅ |
| Commit-grid custom UI | ✅ CustomPaint / widgets | ✅ | ✅ |
| Fits a 4-week deadline | ✅ | ⚠️ learning curve | ⚠️ learning curve, no web |

### Decision
1. The app is **Flutter** (stable channel; version pinned in System Design §6).
2. Submission targets: an **Android APK** (primary device experience) and a **Flutter web build**
   hosted on **Firebase Hosting** for judges to try. iOS is out of scope for the submission.
3. State: **Riverpod** (`flutter_riverpod`). Routing: **go_router**. Local storage: **drift**
   (SQLite; the web build uses drift's web support). Notifications:
   **flutter_local_notifications** (on-device scheduling, no push server).
4. P0 runs with **no account and no app backend**. All personal data lives in the local drift
   database. The only network call is the optional, opt-in AI rewording ([ADR-003](ADR-003-gemini-via-firebase-ai-logic.md)).
5. English only; all strings are externalised so other languages can be added later.
6. The data layer sits behind a repository interface so P1 circles (F-010) can add optional
   Firebase Auth and Firestore sync without rewriting P0 features.

### Why this option
Team experience decides it: Flutter is the stack the team has shipped with, and it also produces
the Android APK and a web demo from one codebase without a Mac.

### Overrides
- **Prior ADRs:** none
- **Docs to reconcile:** System Design (architecture, stack currency), Capabilities §1, AGENTS.md
  commands, Ops (hosting)
- **Out of scope:** the AI provider ([ADR-003](ADR-003-gemini-via-firebase-ai-logic.md)); the P1 circles backend design

### Consequences
- **Easier:** one codebase for both targets; typed queries make export and delete-all simple; no
  server to secure for P0.
- **Harder / owed:** drift on web needs `sqlite3.wasm` and the drift worker in `web/`; web
  notifications are best effort, so F-008 is verified on Android. Data lives on one device, so
  there is no backup. iOS later needs a Mac or a cloud build service and an Apple Developer
  account.
- **What would change this:** a requirement for iOS store release before the deadline, or the
  team turning out not to know Flutter.
- **Follow-up:** walking-skeleton task in the [Implementation Plan](../implementation-plan.md)
