# Rhythm (working name) — Agent Guide

> Keep this file under ~150 lines. It routes; it does not explain. Details live in the owning doc.

## Project overview
Rhythm is a Flutter mobile app (Android APK + web demo) for the Future Health Challenge, Wellbeing
track (submission due 2026-11-20). It helps people whose routines were disrupted find a manageable
way to start, continue, or return to a healthy behaviour: choose an action → try it → share what
happened → better-fitting options next time. It must **never** give medical advice or make guilt-
inducing streak/loss messages, and personal data never leaves the device except through opt-in,
de-identified AI rewording (PRD BR-001, BR-007, BR-015, BR-016).

## Docs navigation (cheap — do this every task)
1. **[`docs/index.md`](./docs/index.md) §0** — find the *one* doc that owns the concern you are changing.
2. **Open only that owner.** Stop.
3. **"Why did we choose X?"** → read [`docs/adr/`](./docs/adr/) newest-first.

| Need | Open |
|------|------|
| Business case | [BRD](./docs/brd.md) |
| What we build (features `F-###`, rules `BR-###`) | [PRD](./docs/prd.md) |
| Screens / flows | [Sitemap](./docs/sitemap.md) / [User Flow](./docs/user-flow.md) |
| How it's built | [System Design](./docs/system-design.md) |
| Tables / entities | [Data Model](./docs/data-model.md) |
| Numbers / thresholds | [Methods](./docs/methods.md) |
| Visual design | [DESIGN.md](./docs/DESIGN.md) |
| Tests (`TC-###`) | [QA Test Plan](./docs/qa-test-plan.md) |
| Deploy / secret names | [Ops](./docs/ops.md) |
| Mobile: release · store listing · store rules · device QA | [Release](./docs/release.md) · [Store listing](./docs/store-listing.md) · [Store compliance](./docs/store-compliance.md) · [Mobile QA](./docs/mobile-qa.md) |
| What to work on now (`TASK-###`) | [Implementation Plan](./docs/implementation-plan.md) |
| **Why / pivots / audit** | **[`docs/adr/`](./docs/adr/) only** |

Skip pitch / demo docs unless the task is literally those surfaces.

## Decisions (ADRs)
Use the `write-adr` skill. Rules: one decision per file, never reuse a number, never edit an
Accepted ADR — supersede it. Newest Accepted ADR wins until the owning doc is reconciled.

## Architecture
One Flutter codebase in `app/` (Riverpod, go_router), built as an Android APK and a web app on
Firebase Hosting. No backend in P0: all data is in an on-device drift (SQLite) database. The only
network call is optional AI rewording via Firebase AI Logic → Gemini (`gemini-3.5-flash-lite`),
always with a library-text fallback. Local notifications only. Ranking and all thresholds are
deterministic Dart in `app/lib/domain/` (see [Methods](./docs/methods.md)).
Details: [System Design](./docs/system-design.md) · ADR-002/003/004.

## Build & run
```
cd app && flutter pub get
flutter run                                  # Android device/emulator
flutter run -d chrome                        # web
flutter run --dart-define=DEMO=true          # demo build (synthetic seed loader)
flutter build apk --release                  # APK for judges/testers
flutter build web --release && firebase deploy --only hosting   # deploy web demo (see Ops)
```

## Test
```
cd app && flutter analyze
flutter test
flutter test integration_test                # E2E, needs an Android emulator
```
All changes must pass tests before they are considered done.

## Working a task
Use the `start-task` skill: claim one `ready` `TASK-###`, branch `task/TASK-###-slug`, stay inside
its write scope.

## The project grows with the requirements
- New capability (login, payments, location, notifications, AI, uploads, store release…) not in
  [`docs/capabilities.md`](./docs/capabilities.md) §1 → run `adapt-project` **before** building it.
- Platform or stack change → run `choose-stack` (new ADR; installs a pack from `packs/` if one fits).
- `packs/` is inactive until installed — don't read it otherwise.

## Code style & conventions
- Language / runtime: Dart + Flutter stable (version pinned in System Design §6)
- Layout: `app/lib/features/<feature>/`, pure logic in `app/lib/domain/` (no Flutter imports, unit-tested)
- Colors/fonts only via DESIGN.md token names; user-facing copy must pass the DESIGN.md wording list
- Naming: soft IDs (`F-###`, `BR-###`, `TC-###`, `TASK-###`) stay stable once assigned
- Avoid: letting AI pick or invent actions (it only rewords, BR-002); sending free text or
  names to AI (BR-016); logging prompts (BR-020); analytics SDKs (BR-015); streak resets or guilt
  copy (BR-007); hard-coded model IDs or thresholds outside the config/Methods constants; red for
  missed days

## Stack currency (verify before coding — overrides training memory)
Confirm pinned versions in System Design before emitting framework APIs. **Use Context7** to fetch
current docs for the pinned version (see [Toolbox](./docs/toolbox.md)). If unverified, say so.

| ❌ Stale / from memory | ✅ Current (this project) | Why |
|------------------------|---------------------------|-----|
| `firebase_vertexai` package / `google_generative_ai` with an API key in the app | `firebase_ai` (Firebase AI Logic, Gemini Developer API provider, App Check) — no key in the app | [ADR-003](./docs/adr/ADR-003-gemini-via-firebase-ai-logic.md) |
| `gemini-1.5-*` / `gemini-2.0-*` / `gemini-2.5-*` model IDs | `gemini-3.5-flash-lite` from one config constant | [ADR-003](./docs/adr/ADR-003-gemini-via-firebase-ai-logic.md), [Methods](./docs/methods.md) |
| Riverpod 2.x patterns (`StateNotifierProvider`, `StateProvider`) | Riverpod 3.x (`Notifier`/`AsyncNotifier`); verify with Context7 | [System Design §6](./docs/system-design.md) |
| sqflite / Hive for app data | drift (typed SQL, works on web with wasm) | [ADR-002](./docs/adr/ADR-002-flutter-android-web-on-device.md) |
| Push notifications via FCM | `flutter_local_notifications` on-device scheduling (Android 13+ runtime permission) | [ADR-002](./docs/adr/ADR-002-flutter-android-web-on-device.md) |

## Working habits (Superpowers, if installed — see [Toolbox](./docs/toolbox.md))
- Never report a task done without running the check that proves it (`verification-before-completion`).
- Debug by reproducing and isolating, not by guessing (`systematic-debugging`).
- Planning skills work **inside** a TASK only; the PRD and implementation plan stay the source of truth.

## Ask before changing
- Business rules in `docs/prd.md` (`BR-###`)
- Thresholds, model IDs, pricing/quota assumptions — need an ADR
- Secrets / `.env*` — never commit

## Definition of done
- Build and tests pass.
- Code ties to an `F-###` where applicable; the **owning** doc is updated if intended behaviour changed.
- Real decision or pivot → new ADR.
- No secrets committed.

## Build agents
Roster: [docs/sad.md](./docs/sad.md) → `.claude/agents/`: `rules-reviewer` (read-only, checks
BR-### rules), `test-runner` (runs gates, never fixes), `flutter-ui-builder` (one screen per
call), `store-reviewer` (read-only, store releases only), `design-reviewer` (read-only, reviews
Figma rounds against goals, rules and flows), `ui-reviewer` (read-only, senior UI/UX and
accessibility critique, screen by screen), `senior-project-manager` (read-only, scope, schedule and
business-case decision memos, hackathon and store-release tracks). Add more with the `add-subagent` skill only when a task
recurs.

## References
[Docs index](./docs/index.md) · [ADRs](./docs/adr/) · [PRD](./docs/prd.md) ·
[System Design](./docs/system-design.md) · [QA](./docs/qa-test-plan.md)
