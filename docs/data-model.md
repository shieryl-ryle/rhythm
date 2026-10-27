# Data Model — Rhythm

> **Status:** Draft v0.1 · **Date:** 2026-10-23 · **Owner:** Shieryl
> **Traces back to:** [PRD](prd.md), [System Design](system-design.md), [Methods](methods.md)
> Owns: entities, tables/collections, columns, enums, relationships. Code that defines the schema
> must match this doc; when they disagree, fix one in the same change.

## 0. How to read this doc
Everything is stored **on the device** in a drift (SQLite) database ([ADR-002](adr/ADR-002-flutter-android-web-on-device.md)).
The schema lives in `app/lib/data/db/tables.dart`. Migrations use drift's `schemaVersion` and
`MigrationStrategy` in `app/lib/data/db/database.dart`. The action library is a bundled JSON asset
(`app/assets/library/actions.json`, DS-001), loaded into `action` on first run and on library
version change. **Personal fields** are marked 🔒: they never leave the device except through a
user-initiated export (BR-015, BR-016).

## 1. Conventions
- Primary keys: text IDs with a prefix: `act_` (library, stable), and generated UUID v4 with a
  prefix for user records (`off_`, `ref_`, `pau_`, `obs_`, `ret_`, `pref_`).
- Timestamps: UTC ISO-8601 (`DateTime` stored as UTC). **Day** fields store the user's *local*
  calendar date as `YYYY-MM-DD` text, because the grid, lapses, and caps work on local days.
- Money: not used.
- Enums: defined once in `app/lib/data/db/enums.dart`; stored as text; never rename or remove a
  live value.
- Deletion: **hard delete** everywhere. Delete-all (BR-017) drops every row in every user table
  (not `action`) and cancels scheduled notifications. Cascades: deleting an `option_offer` deletes
  its `reflection`.

## 2. Entity-relationship overview
```
profile 1──* preference
profile 1──* option_offer *──1 action
option_offer 1──0..1 reflection
profile 1──* pause
profile 1──* observation
profile 1──* saved_action *──1 action
profile 1──* return_event
profile 1──1 notification_setting
consent (append-only log)
```
There is a single `profile` row per device (no accounts in P0).

## 3. Enums
| Enum | Values | Used by |
|---|---|---|
| `stage` | considering, starting, maintaining, demanding_period, lapsed, returning, repeating | profile.stage |
| `pref_kind` | constraint, preference, excluded_category | preference.kind |
| `category` | movement, rest_sleep, eating, stress_relief, connection, mindfulness, custom | action.category, preference.value (when excluded_category) |
| `intensity` | very_low, low, moderate | action.intensity (no high intensity in the library; BR-002) |
| `energy` | low, medium, high | action.energy_needed, option_offer.energy_input |
| `offer_status` | offered, accepted, edited, replaced, declined | option_offer.status |
| `reflection_status` | completed, partly, skipped, unknown | reflection.status |
| `effort` | easy, ok, hard | reflection.effort |
| `barrier` | time, energy, stress, forgot, environment, money, other_priority, other, prefer_not_to_say | reflection.barrier |
| `pause_kind` | pause, lighter, reschedule | pause.kind |
| `obs_source` | rule, ai_draft, user | observation.source |
| `obs_status` | proposed, confirmed, deleted | observation.status |
| `what_changed` | schedule, environment, responsibilities, energy, other, prefer_not_to_say | return_event.what_changed (comma set) |
| `return_approach` | previous, different, starter | return_event.approach |

## 4. Tables / entities

### `profile`
The user's starting point (F-001) and settings. Serves BR-011, BR-014, BR-016.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `"me"` | PK; single row |
| `behaviour_name` | text 🔒 | no | — | User-defined, e.g. "Evening walks" |
| `behaviour_category` | category | no | — | |
| `reason` | text 🔒 | yes | null | Free text; red-flag checked (EQ-008); never sent to AI |
| `stage` | stage | no | — | |
| `daily_goal` | int | no | 1 | Actions per day that count as "goal met" (EQ-002) [assumption] |
| `ai_opt_in` | bool | no | false | BR-016. Dormant in P0 (ADR-006): no screen sets it, so it stays false |
| `created_at` | datetime | no | now | |

### `consent`
Append-only consent log (BR-014).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | int | no | autoinc | PK |
| `consent_version` | text | no | — | e.g. `2026-10-23.1` |
| `accepted_at` | datetime | no | — | |

### `preference`
Constraints, preferences, and excluded categories (F-001, BR-011).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `pref_…` | PK |
| `kind` | pref_kind | no | — | |
| `value` | text 🔒 | no | — | A tag code (e.g. `with_company`, `indoors`, `under_10_min`) or a category |

**Constraints / indexes:** unique (`kind`, `value`).

### `action`
Curated library (DS-001). Read-only for users.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | — | PK, e.g. `act_walk_10` |
| `category` | category | no | — | |
| `title` | text | no | — | Library text (fallback for AI, BR-020) |
| `description` | text | no | — | |
| `duration_min` | int | no | — | |
| `intensity` | intensity | no | — | |
| `energy_needed` | energy | no | — | |
| `tags` | text | no | `""` | Comma-separated tag codes (`with_company`, `indoors`, `free`) |
| `is_starter` | bool | no | false | Offered when there is no history (EV-005) |
| `library_version` | text | no | — | |

### `option_offer`
One option shown on a day (F-002). Serves BR-004, BR-005, BR-019.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `off_…` | PK |
| `day` | text | no | — | Local `YYYY-MM-DD` |
| `action_id` | text | no | — | FK → action |
| `display_text` | text | no | — | Library or AI-worded text actually shown |
| `ai_worded` | bool | no | false | Drives the "AI-worded" label (BR-019) |
| `reason_code` | text | no | — | EQ-004 code |
| `reason_text` | text | no | — | Shown to the user (BR-004) |
| `status` | offer_status | no | offered | |
| `edited_duration_min` | int | yes | null | Set when edited (EQ-010 light edit) |
| `time_input_min` | int | yes | null | Optional quick input |
| `energy_input` | energy | yes | null | Optional quick input |
| `created_at` | datetime | no | now | |

**Constraints / indexes:** index (`day`); FK `action_id` restrict.

### `reflection`
Quick Reflection (F-003). Serves BR-008, BR-009.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `ref_…` | PK |
| `offer_id` | text | no | — | FK → option_offer, cascade delete; unique |
| `status` | reflection_status | no | unknown | Created as `unknown` when an offer is accepted |
| `enjoyment` | int | yes | null | 1–3 🔒 |
| `effort` | effort | yes | null | 🔒 |
| `barrier` | barrier | yes | null | 🔒 |
| `updated_at` | datetime | no | now | |

### `pause`
Intentional pauses and lighter or rescheduled periods (UJ-004, BR-006).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `pau_…` | PK |
| `kind` | pause_kind | no | — | |
| `start_day` | text | no | — | Local date |
| `end_day` | text | yes | null | Null = until resumed |

### `observation`
What Works for Me (F-004). Serves BR-010, BR-019.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `obs_…` | PK |
| `text` | text 🔒 | no | — | Shown to the user |
| `source` | obs_source | no | — | |
| `status` | obs_status | no | proposed | Only `confirmed` affects ranking (BR-010) |
| `pattern_key` | text | no | — | Machine-readable pattern, e.g. `tag:with_company:enjoyed` (EQ-009) |
| `ai_worded` | bool | no | false | BR-019 |
| `created_at` | datetime | no | now | |
| `confirmed_at` | datetime | yes | null | |

### `saved_action`
| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `action_id` | text | no | — | PK, FK → action |
| `saved_at` | datetime | no | now | |

### `return_event`
A return after a lapse (F-005, EQ-011).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `ret_…` | PK |
| `lapse_start_day` | text | no | — | First day of the lapse |
| `return_day` | text | no | — | Day of the first reflected action after the lapse |
| `what_changed` | text 🔒 | yes | null | Comma set of `what_changed` |
| `approach` | return_approach | yes | null | |

### `notification_setting`
F-008. Serves BR-012, BR-013.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `"me"` | PK; single row |
| `enabled` | bool | no | false | BR-012 |
| `times` | text | no | `""` | Comma list of `HH:mm`; capped by EQ-005 |
| `quiet_start` | text | no | `"21:00"` | [assumption] |
| `quiet_end` | text | no | `"08:00"` | [assumption] |
| `lapse_checkin_enabled` | bool | no | true | Weekly check-in after a lapse; user can turn it off |

## 5. Deliberately not modeled
- **Users and accounts:** none in P0 (BR-015). P1 circles add a server-side model via a new ADR.
- **Streaks:** not stored. Totals (EQ-011) are computed from reflections, so nothing can "reset".
- **Analytics events:** none; metrics are computed from the tables above (EQ-010).
- **AI prompts and responses:** never stored (BR-020); only the displayed text in `display_text`
  or `observation.text`.
- **Rewards (F-009, F-011):** P1.

## 6. Known gaps / follow-ups
| Gap | Impact | Follow-up |
|---|---|---|
| Single device, no backup | Data is lost with the device | Export (BR-017); P1 opt-in sync |
| Library authoring and safety review | P0 needs content | PRD Q1; [seed](../seed/README.md) |
| Encryption at rest | SQLite file is not encrypted beyond OS sandboxing | Assess before real-user study (ADR if adopted) |
