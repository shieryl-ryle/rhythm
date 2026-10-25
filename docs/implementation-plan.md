# Implementation Plan — Rhythm

> Living execution ledger. Intent lives in the PRD, architecture in System Design, decisions in ADRs.

**Plan owner:** Shieryl
**Last checkpoint:** 2026-10-24 · PRD/BRD v0.3 (physical activity, no LLM in P0, social in P1;
ADR-005..007); wireframes v1 reviewed; no code yet. Milestones: skeleton
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
| TASK-004 | Activity library v1: physical activity only (ADR-005), ~40 activities with attributes (social/solo, indoor/outdoor, cost, access/membership, duration, intensity, similar-to links), starters + red-flag list + blocked-claims list; content scan tests | ADR-005; DS-001..DS-003; BR-001, BR-002, BR-007; TC-009, TC-015 · blocked by PRD Q1 (sources), Q7 (categories) | Shieryl | ready | `app/assets/library/`, `app/test/content/` | |
| TASK-005 | Core loop screens: My Starting Point S-003, Today S-004 (+ S-102, S-103), Reflection S-101 wired to data + domain | F-001, F-002, F-003; UJ-001, UJ-002; BR-004..BR-006, BR-008; TC-001..TC-003, TC-012..TC-014, TC-016 | unassigned | ready (after 002, 003) | `app/lib/features/{starting_point,today,reflection}/`, matching tests | |
| TASK-006 | My Way Back S-005 + Progress commit grid S-006 | F-005, F-006; UJ-003; BR-006, BR-007; TC-005, TC-006 | unassigned | ready (after 002, 003) | `app/lib/features/{way_back,progress}/`, matching tests, `app/integration_test/return_test.dart` | |
| TASK-007 | AI adapter: Firebase AI Logic (`firebase_ai`) + App Check, prompt builder, EQ-007 safety check, timeout/budget fallback, "AI-worded" label | ADR-003; BR-002, BR-016, BR-019, BR-020; EQ-006, EQ-007; TC-010, TC-024, TC-027, TC-028, TC-034, TC-035, TC-042 | unassigned | cut | `app/lib/ai/`, `app/test/ai/` | Cut 2026-10-24: no LLM in P0 (ADR-006) |
| TASK-008 | Switch Gemini to the paid tier (Blaze) and set the budget alert **before the first real-user session**; confirm the challenge rules page (PRD Q5) | ADR-003 decision 5; Ops alerts; BRD RK-005 | Shieryl | cut | Firebase console; `docs/ops.md` | Cut 2026-10-24 (ADR-006); the rules check moved to TASK-010 |
| TASK-009 | Reconcile docs with ADR-005..007: Sitemap (cut S-002; S-003, S-004, S-103, S-008, S-107, S-108), User Flow, Data Model (activity attributes, free-time slots), Methods (EQ-003/EQ-004 for similarity and time fit; EQ-006/EQ-007 dormant), System Design §4, Ops, DESIGN.md (one hero, AI tag), capabilities.md, QA test plan, rules-reviewer and design-reviewer checks, `AGENTS.md` architecture and stack rows | ADR-005, ADR-006, ADR-007 | Claude (for Shieryl) | ready | `docs/`, `.claude/agents/`, `AGENTS.md` | |
| TASK-010 | Confirm the challenge rules page (PRD Q5) | PRD Q5; BRD RK-007 | Shieryl | ready | — | |
| TASK-011 | Wireframes v2: apply the design-review fixes; cut S-002; new setup (activity profile, free times); visible adapting (what changes after reflection, "how Rhythm adjusted", suggested time, "my plan fell through"); P1 social concept screens for the pitch | ADR-005..007; F-001..F-004, F-010, F-012 | Claude (for Shieryl) | in-review | Figma "Rhythm — Wireframes v1" (drafts), page "Wireframes v2" | 2026-10-24: 49 frames in 8 sections built and screenshot-checked; superseded by TASK-012 for the v0.4 changes |
| TASK-012 | Wireframes v3 (PRD v0.4): 4-path setup with follow-ups per path; following several activities; grid at the top of Today; share-card sheet; Android widget; calendar-sync opt-in; P1 Challenges tab with invite by link, QR code and join code; P1 Apple Watch glance | ADR-008; F-001, F-002, F-006, F-012, F-013, F-015..F-017 · Q10, Q11 open | Claude (for Shieryl) | in-review | Figma "Rhythm — Wireframes v1" (drafts), page "Wireframes v3" | 2026-10-25: 10 sections; First run (11), Today (8), achievements/share/widget/calendar (6), P1 Challenges + Watch (6) built new; Settings updated; all screenshot-checked |
| TASK-017 | Wireframes v5: apply the senior UI/UX review (kit sizes and 48 dp targets, accessible search and fields, sheets with the dimmed parent screen and ×, snackbars and dialogs, one primary on Today, 44 dp calendar, Discover loading, edit free times); calendar and widget moved to P1 | ADR-009; DESIGN.md interaction rules | Claude (for Shieryl) | in-review | Figma page "Wireframes v5" | 2026-10-25: about 100 frames, 491 links, 8 flows; no dead ends |
| TASK-013 | Run `adapt-project` for the new P0 capabilities: accounts (Firebase Auth), backend (Firestore and security rules), approximate location, user-generated content and moderation, share sheet. It adds rules, tests and store-compliance checks. Calendar and widget are now P1 | ADR-008, ADR-009; BR-023, BR-025..BR-029 | Claude (for Shieryl) | ready | `docs/`, `.claude/` | |
| TASK-014 | Community backend: Firebase Auth (email link and Google), Firestore collections (profiles, clubs, events, rsvps, reports, blocks), security rules with emulator tests, account deletion that removes server data (BR-017), budget alert | ADR-009; F-018; BR-017, BR-025..BR-029 | unassigned | ready (after TASK-001, TASK-013) | `app/lib/community/data/`, `firestore.rules`, `test/rules/` | |
| TASK-015 | Together screens: tab, sign-in and area, events and clubs list with filters, event detail with RSVP to Today's plan, club page, host an event, report and block | F-018; UJ-005 | unassigned | ready (after TASK-014) | `app/lib/features/together/`, tests | |
| TASK-016 | Seed community data (DS-006: labelled sample clubs and events) and reach out to 2–3 real local clubs | ADR-009; BRD RK-010 | Shieryl + Dzelle | ready | `app/tool/seed_community.dart`, outreach notes | |

**Next up (not yet ledgered):** What works section of My rhythm S-006/S-105 + Discover S-009 (F-004), gentle notifications
S-106 (F-008), Settings & My Data S-008, demo seed loader (`seed/README.md`), user sessions
(BRD §11), technical documentation for the submission, deck + backup video.
