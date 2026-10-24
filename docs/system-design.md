# System Design — Rhythm

**Status:** Draft v0.1 · **Date:** 2026-10-23 · **Decisions:** [ADR-002](adr/ADR-002-flutter-android-web-on-device.md) (stack), [ADR-003](adr/ADR-003-gemini-via-firebase-ai-logic.md) (AI), [ADR-004](adr/ADR-004-wellness-positioning-and-privacy-baseline.md) (wellness and privacy)

## 1. Architecture
One Flutter codebase, built as an **Android APK** and a **web app** (Firebase Hosting). There is
no app backend for P0. All personal data lives in an on-device SQLite database (drift). The only
network call is the optional, opt-in AI rewording through Firebase AI Logic, whose proxy holds the
Gemini key.

```
┌──────────────────────── Flutter app (Android / web) ────────────────────────┐
│ UI (screens S-###, go_router)  ←→  Riverpod providers                          │
│        │                                   │                                   │
│  Domain (pure Dart, unit-tested)      Data (drift, on-device)                  │
│   - ranking (EQ-003)                   - profile, offers, reflections,         │
│   - lapse / grid / totals (EQ-001/2/11)  pauses, observations, returns         │
│   - safety check (EQ-007/008)          - action library (bundled asset)        │
│        │                                                                       │
│  AI adapter (optional, opt-in) ── firebase_ai ──► Firebase AI Logic proxy      │
│        │ fallback: library text           (App Check)   ──► Gemini Developer API│
│  Notifications (flutter_local_notifications, on-device scheduling)            │
└────────────────────────────────────────────────────────────────────────────────┘
Firebase Hosting serves the web build (static files only).
```

## 2. Components
| Component | Responsibility | Location in repo |
|---|---|---|
| App shell and routing | go_router routes (Sitemap §4), first-run redirect, theme from DESIGN.md | `app/lib/app/` |
| Features | One folder per feature: starting_point, today, reflection, what_works, way_back, progress, my_data, notifications | `app/lib/features/<feature>/` |
| Domain logic | Ranking, lapse detection, grid levels, totals, observation proposals, safety and red-flag checks. Pure Dart, no Flutter imports | `app/lib/domain/` |
| Data | drift database, tables per [Data Model](data-model.md), repositories (interface seam for P1 sync), export and delete-all | `app/lib/data/` |
| Action library | Curated actions (DS-001), red-flag terms (DS-002), blocked claims (DS-003) | `app/assets/library/` |
| AI adapter | Builds de-identified prompts, calls `firebase_ai`, enforces timeout, runs the safety check, falls back to library text | `app/lib/ai/` |
| Notifications | Schedules and cancels local notifications under EQ-005 caps | `app/lib/notifications/` |
| Demo seed | Synthetic demo data loader (demo builds only) | `app/assets/seed/`, `app/lib/data/seed/` |
| Tests | Unit (domain), widget (screens), integration (UJ-001..UJ-003) | `app/test/`, `app/integration_test/` |

## 3. Data
All entities live on the device in drift; see [Data Model](data-model.md). The action library is a
read-only bundled asset loaded into drift on first run. There is no server-side store for P0. P1
circles would add Firebase Auth and Firestore behind the repository seam (new ADR required).

## 4. Integrations
| Service | Purpose | Auth method | Secret name (env var) |
|---|---|---|---|
| Firebase AI Logic → Gemini Developer API (`gemini-3.5-flash-lite`) | Reword library actions; draft observations (opt-in) | Firebase project config + **App Check**; the Gemini key stays in the Firebase proxy | none in the app. Gemini key managed in the Firebase console; App Check debug token `FIREBASE_APPCHECK_DEBUG_TOKEN` (local dev only) |
| Firebase Hosting | Serve the web demo | Firebase CLI login (deployer) | none (CLI auth) |
| Firebase App Check | Block unauthorised clients from the AI proxy | Play Integrity (Android), reCAPTCHA (web; provider unverified, see §6) | reCAPTCHA site key `RECAPTCHA_SITE_KEY` (public, via `--dart-define`) |

## 5. Security & privacy
- Secrets only via environment variables or `--dart-define`; never committed. `firebase_options.dart`
  holds public identifiers only.
- Least privilege: deployers get the **Firebase Hosting Admin** role only, never Owner/Editor
  (verify the role name in the console).
- **PII handling:** all personal data stays on the device (BR-015). Prompts contain only library
  action text, duration, intensity, and preference tags, never free text, names, or IDs (BR-016).
  No prompt or response logging (BR-020). No analytics SDKs.
- **Consent:** versioned consent stored locally (BR-014). AI is off until opt-in.
- **Retention:** data lives until the user deletes it. Delete-all hard-deletes every table and
  cancels notifications (BR-017).
- **Safety:** every AI output passes EQ-007 before display; red-flag input is handled without AI
  (BR-003, EQ-008).
- **Tier:** Gemini free tier only with synthetic data; paid tier before real users (ADR-003).

## 6. Stack currency
Pinned versions agents must verify against official docs before emitting APIs. Use Context7 or
the Dart MCP for current APIs.

| Library / service | Pinned version | Docs URL | Verified on |
|---|---|---|---|
| Flutter (stable) | 3.47 (per the docs site; confirm with `flutter --version`) | https://docs.flutter.dev/release/archive | 2026-10-23 |
| flutter_riverpod | ^3.4.3 | https://pub.dev/packages/flutter_riverpod | 2026-10-23 |
| go_router | ^18.1.1 | https://pub.dev/packages/go_router | 2026-10-23 |
| drift | ^2.35.2 (web needs `sqlite3.wasm` and the drift worker, see the drift web guide) | https://pub.dev/packages/drift · https://drift.simonbinder.eu/web | 2026-10-23 |
| flutter_local_notifications | ^22.3.2 (min Flutter 3.38.1; Android compileSdk ≥ 35, core library desugaring, Java 17, AGP ≥ 8.11.1; POST_NOTIFICATIONS on Android 13+) | https://pub.dev/packages/flutter_local_notifications | 2026-10-23 |
| firebase_ai | ^5.1.0 (Android, iOS, macOS, web) | https://pub.dev/packages/firebase_ai | 2026-10-23 |
| Gemini model | `gemini-3.5-flash-lite` (stable; retires no earlier than 2027-07-21) | https://firebase.google.com/docs/ai-logic/models | 2026-10-23 |
| firebase_core, firebase_app_check, drift_flutter, drift_dev, build_runner | **unverified**: check pub.dev before adding | https://pub.dev | — |
| App Check web provider (reCAPTCHA v3 vs Enterprise) | **unverified** | https://firebase.google.com/docs/app-check | — |
| Android target SDK | API 36 (Play requirement from 2026-08-31, per store-compliance; applies once a Play release happens) | https://developer.android.com/google/play/requirements/target-sdk | from pack, not re-verified |
