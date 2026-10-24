# Implementation Plan — Rhythm

> Living execution ledger. Intent lives in the PRD, architecture in System Design, decisions in ADRs.

**Plan owner:** Shieryl
**Last checkpoint:** 2026-10-23 · Bootstrap done; docs filled; no code yet. Milestones: skeleton
deployed by 2026-10-30 · feature freeze 2026-11-13 · submission 2026-11-20 ([BRD](brd.md) §7).

## 0. Rules
- One owner per task. Edit only your task's write scope.
- Avoid cross-task dependencies: code against agreed contracts and use fixtures until the real
  piece lands.
- Same file needed by two tasks → the plan owner splits it or schedules pairing.
- TASK-002, TASK-003, TASK-004 can run in parallel once TASK-001 has created `app/`.

## 1. Task ledger
Statuses: `ready` · `in-progress` · `in-review` · `done` · `cut`

| ID | Title | Traces to | Owner | Status | Write scope | Evidence (PR / result) |
|---|---|---|---|---|---|---|
| TASK-001 | **Deployed walking skeleton:** Flutter app (Riverpod, go_router, drift incl. web wasm assets), consent screen S-001 → Today S-004 showing 3 hard-coded library actions; `flutter analyze` + 1 widget test green; web build live on Firebase Hosting; release APK builds | ADR-002, F-007 (partial), F-002 (stub), TC-040 | unassigned | ready | `app/` (scaffold only), `firebase.json`, `.firebaserc`, `.gitignore` | |
| TASK-002 | Data layer: drift schema per Data Model, migrations, consent gate, export JSON, delete-all | F-007, BR-014, BR-015, BR-017; TC-007, TC-022, TC-023, TC-025 | unassigned | ready (after TASK-001) | `app/lib/data/`, `app/test/data/`, `app/test/privacy/` | |
| TASK-003 | Domain logic in pure Dart: lapse, grid levels, ranking + reasons, notification caps, red-flag check, observation proposals, metrics/totals | EQ-001..EQ-005, EQ-008..EQ-011; BR-003, BR-007, BR-009..BR-011; TC-017..TC-019, TC-029..TC-033, TC-036..TC-039 | unassigned | ready (after TASK-001) | `app/lib/domain/`, `app/test/domain/`, `app/test/fixtures/` | |
| TASK-004 | Action library v1 (3–4 categories, ~40 actions, starters) + red-flag list + blocked-claims list; content scan tests | DS-001..DS-003; BR-001, BR-002, BR-007; TC-009, TC-015 · blocked by PRD Q1 (sources) | Shieryl | ready | `app/assets/library/`, `app/test/content/` | |
| TASK-005 | Core loop screens: My Starting Point S-003, Today S-004 (+ S-102, S-103), Reflection S-101 wired to data + domain | F-001, F-002, F-003; UJ-001, UJ-002; BR-004..BR-006, BR-008; TC-001..TC-003, TC-012..TC-014, TC-016 | unassigned | ready (after 002, 003) | `app/lib/features/{starting_point,today,reflection}/`, matching tests | |
| TASK-006 | My Way Back S-005 + Progress commit grid S-006 | F-005, F-006; UJ-003; BR-006, BR-007; TC-005, TC-006 | unassigned | ready (after 002, 003) | `app/lib/features/{way_back,progress}/`, matching tests, `app/integration_test/return_test.dart` | |
| TASK-007 | AI adapter: Firebase AI Logic (`firebase_ai`) + App Check, prompt builder, EQ-007 safety check, timeout/budget fallback, "AI-worded" label | ADR-003; BR-002, BR-016, BR-019, BR-020; EQ-006, EQ-007; TC-010, TC-024, TC-027, TC-028, TC-034, TC-035, TC-042 | unassigned | ready (after TASK-005) | `app/lib/ai/`, `app/test/ai/` | |
| TASK-008 | Switch Gemini to the paid tier (Blaze) and set the budget alert **before the first real-user session**; confirm the challenge rules page (PRD Q5) | ADR-003 decision 5; Ops alerts; BRD RK-005 | Shieryl | ready | Firebase console; `docs/ops.md` | |

**Next up (not yet ledgered):** What works section of My rhythm S-006/S-105 + Discover S-009 (F-004), gentle notifications
S-106 (F-008), Settings & My Data S-008, demo seed loader (`seed/README.md`), user sessions
(BRD §11), technical documentation for the submission, deck + backup video.
