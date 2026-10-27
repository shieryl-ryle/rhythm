# Data Model — Lilt

> **Status:** Draft v0.2 · **Date:** 2026-10-27 · **Owner:** Shieryl
> **Traces back to:** [PRD](prd.md), [System Design](system-design.md), [Methods](methods.md),
> [Sitemap](sitemap.md), the Figma page `Lilt · Screens` (frame names below), [ADR-005](adr/ADR-005-physical-activity-focus.md),
> [ADR-006](adr/ADR-006-no-ai-in-p0.md), [ADR-012](adr/ADR-012-pause-days-look-like-empty-days.md), [ADR-014](adr/ADR-014-lilt-does-not-record-activities.md)
> Owns: entities, tables/collections, columns, enums, relationships. Code that defines the schema
> must match this doc; when they disagree, fix one in the same change.
> **v0.2 (2026-10-27):** reconciled with the Figma frames (UI reviewer's whole-flow review). The setup now
> follows several activities, free times, access, motivations and leave-outs; plans have their own table
> (suggestions, one-offs, Together RSVPs, the optional "Under way" start); the old wellbeing categories are gone
> (ADR-005); the enums match the option lists on the screens (§7).

## 0. How to read this doc
Everything is stored **on the device** in a drift (SQLite) database ([ADR-002](adr/ADR-002-flutter-android-web-on-device.md)).
The schema lives in `app/lib/data/` (the skeleton keeps `database.dart`; tables may be split into
`app/lib/data/tables/` as they grow). Migrations use drift's `schemaVersion` and `MigrationStrategy`. The action
library is a bundled JSON asset (`app/assets/library/actions.json`, DS-001), loaded into `action` on first run and
on library version change. **Personal fields** are marked 🔒: they never leave the device except through a
user-initiated export (BR-015, BR-016). Together (F-018) keeps its own server-side data (profile, events, clubs,
RSVPs; BR-025); health data is never part of it.

## 1. Conventions
- Primary keys: text IDs with a prefix: `act_` (library, stable), and generated UUID v4 with a prefix for user
  records (`fol_`, `pref_`, `off_`, `plan_`, `ref_`, `pau_`, `obs_`, `ret_`).
- Timestamps: UTC ISO-8601 (`DateTime` stored as UTC). **Day** fields store the user's *local* calendar date as
  `YYYY-MM-DD` text, and **time-of-day** fields as local `HH:mm`, because the grid, lapses and caps work on local
  days.
- Money: not used.
- Enums: defined once in `app/lib/data/` (one `enums.dart`); stored as text; never rename or remove a live value
  (add new values; a retired value stays readable).
- Deletion: **hard delete** everywhere. Delete-all (BR-017) drops every row in every user table (not `action`),
  cancels scheduled notifications and, if a Together account exists, deletes it and its server data. Cascades:
  deleting a `plan_item` deletes its `reflection`.

## 2. Entity-relationship overview
```
profile (1 row)
profile 1──* followed_activity
profile 1──* preference
action 1──* option_offer 1──* offer_reason
option_offer 1──0..1 plan_item 1──1 reflection
plan_item *──0..1 action            (custom one-offs and Together RSVPs have no action)
profile 1──* pause
profile 1──* observation
profile 1──* saved_action *──1 action
profile 1──* return_event
profile 1──* achievement_earned
profile 1──1 notification_setting
consent (append-only log)
```
There is a single `profile` row per device. Signing in to Together adds no health data to the model.

## 3. Enums
| Enum | Values | Used by |
|---|---|---|
| `activity_kind` | walking, running, gym, cycling, swimming, basketball, racket_sports, team_sports, pickleball, yoga, dance, hiking, bouldering, pilates, other, not_sure | action.activity, followed_activity.activity, plan_item.activity, preference.value (kind `excluded`, activity form) |
| `path` | keep_going, pick_up_again, add_new, start_fresh | followed_activity.path |
| `progress` | going_well, up_and_down, getting_harder | followed_activity.progress |
| `hard_because` | finding_time, energy, getting_bored, cost, motivation | followed_activity.hard_because (comma set) |
| `stopped_ago` | weeks, months, year_plus | followed_activity.stopped_ago |
| `familiarity` | already_play, used_to_play, new_to_me | followed_activity.familiarity |
| `what_changed` | busier, health_energy, family_caring, moved, group_or_gym_changed, just_drifted, prefer_not_to_say | followed_activity.got_in_the_way (comma set), return_event.what_changed (comma set) |
| `what_would_help` | shorter_sessions, someone_to_go_with, different_time, something_similar, not_sure | followed_activity.would_help (comma set) |
| `pref_kind` | free_time, access, usual_barrier, motivation, excluded, constraint, preference | preference.kind |
| `intensity` | very_low, low, moderate | action.intensity (no high intensity in the library; BR-002) |
| `energy` | low, medium, high | action.energy_needed, option_offer.energy_input |
| `offer_status` | offered, accepted, edited, replaced, declined | option_offer.status |
| `plan_source` | offer, custom, together_event | plan_item.source |
| `with_whom` | solo, friends, event | plan_item.with_whom |
| `reflection_status` | completed, partly, skipped, unknown | reflection.status |
| `barrier` | time, low_energy, schedule, weather, other, prefer_not_to_say | reflection.barrier |
| `pause_kind` | pause, lighter, reschedule | pause.kind |
| `obs_source` | rule, ai_draft, user | observation.source (`ai_draft` dormant, ADR-006) |
| `obs_status` | proposed, confirmed, deleted | observation.status |
| `return_approach` | previous, different, starter | return_event.approach. `different` = the person chose "Try something different" (4.2); `starter` = there was no previous approach, so starters are offered directly (9.4, EV-005) |

The `effort` enum (easy, ok, hard) is **retired**: the reflection frames ask only how it went, enjoyment and the
barrier. The old `stage` and `category` enums are removed (ADR-005: physical activity only; the stages became the
`path`, `progress` and `stopped_ago` answers).

## 4. Tables / entities

### `profile`
The device's settings row (F-001, F-007). Serves BR-011, BR-014, BR-016.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `"me"` | PK; single row |
| `daily_goal` | int | no | 1 | Actions per day that count as "goal met" (EQ-002). A constant 1 in P0: no screen sets it, but EQ-002 reads it [assumption] |
| _(no `ai_opt_in`)_ | | | | Removed with the AI fields (ADR-006). Add it back with the AI adapter and a screen that sets it (BR-016) |
| `setup_done_at` | datetime | yes | null | Set when the person finishes the setup wizard ("Show me today") |
| `created_at` | datetime | no | now | |

### `consent`
Append-only consent log (BR-014).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | int | no | autoinc | PK |
| `consent_version` | text | no | — | `date.revision`, e.g. `2026-10-27.1` |
| `accepted_at` | datetime | no | — | |

### `followed_activity`
One row per activity the person follows (F-001, F-002; frames 1.3 to 1.11, 3.9, 7.2). Each followed activity gets
its own card on Today.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `fol_…` | PK |
| `activity` | activity_kind | no | — | |
| `custom_name` | text 🔒 | yes | null | The typed name when `activity` = `other` ("Can't find it? Type it", red-flag checked, EQ-008) |
| `path` | path | no | — | Shown on 7.2 as "Keeping it going", "Picking up again", "New to try" |
| `progress` | progress | yes | null | `keep_going` only (frame 1.7) |
| `hard_because` | text | yes | null | Comma set of `hard_because`; asked when `progress` is `up_and_down` or `getting_harder` (frame 1.7; optional) |
| `stopped_ago` | stopped_ago | yes | null | `pick_up_again` only (1.9) |
| `got_in_the_way` | text | yes | null | Comma set of `what_changed` (1.10, optional) |
| `would_help` | text | yes | null | Comma set of `what_would_help` (1.11, optional) |
| `familiarity` | familiarity | yes | null | Followed from Discover (3.9) |
| `followed_at` | datetime | no | now | |
| `unfollowed_at` | datetime | yes | null | Null = still followed. Unfollowing keeps past plans and reflections |

**Constraints / indexes:** index (`unfollowed_at`).

### `preference`
Free times, access, usual barriers, motivations and leave-outs (F-001, BR-011; frames 1.12 to 1.14, 7.8).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `pref_…` | PK |
| `kind` | pref_kind | no | — | See §7 for the values per kind |
| `value` | text 🔒 | no | — | A code (see §7). For kind `excluded` it is a library tag (`after_dark`, `team_sport`, `high_impact`) or an `activity_kind` (`swimming`): the ranker must filter on both the action's tags and its `activity` |

**Constraints / indexes:** unique (`kind`, `value`).
`motivation` holds at most 3 rows (frame 1.13: "Pick up to 3"), enforced by a database trigger. `excluded` has no row when the person picks
"Nothing to leave out".

### `action`
Curated library (DS-001). Read-only for users.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | — | PK, e.g. `act_walk_10` |
| `activity` | activity_kind | no | — | The activity it belongs to ("Run-walk around the park" is `running`) |
| `title` | text | no | — | Library text |
| `description` | text | no | — | |
| `duration_min` | int | no | — | |
| `intensity` | intensity | no | — | |
| `energy_needed` | energy | no | — | |
| `tags` | text | no | `""` | Comma-separated tag codes (`with_company`, `indoors`, `outdoors`, `free`, `team_sport`, `high_impact`, `after_dark`) |
| `is_starter` | bool | no | false | Offered when there is no history (EV-005) |
| `library_version` | text | no | — | |

### `option_offer`
One option shown on a day (F-002). Serves BR-004, BR-005.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `off_…` | PK |
| `day` | text | no | — | Local `YYYY-MM-DD` |
| `action_id` | text | no | — | FK → action |
| `followed_activity_id` | text | yes | null | FK → followed_activity; null for "Try something new" suggestions |
| `suggested_day` | text | no | — | Local `YYYY-MM-DD` the suggestion is for. Today's card can say "Suggested Sat 10:00", so this can differ from `day` |
| `suggested_time` | text | yes | null | Local `HH:mm`, from the person's free times (see the clock times in §7) |
| `swap_index` | int | no | 1 | 1 to 3: the position in the day's "Something else" chain ("1 of 3"), so a restart cannot reshuffle the three candidates |
| `status` | offer_status | no | offered | Set by the tap: "I'll try this" → `accepted`; Edit then "Save changes" → `edited`; "Something else" → the shown offer becomes `replaced`; "Not today" → `declined`; untouched stays `offered` |
| `edited_duration_min` | int | yes | null | Set when edited (frame 3.2; options 10, 20, 30 or 45) |
| `edited_day` | text | yes | null | Set when the "When" choice in frame 3.2 changes the day |
| `edited_time` | text | yes | null | Set when the "When" choice in frame 3.2 changes the time |
| `time_input_min` | int | yes | null | The Today time chip when the offer was made (10, 20, 30 or 45) |
| `energy_input` | energy | yes | null | The Today energy chip when the offer was made |
| `created_at` | datetime | no | now | |

**Constraints / indexes:** index (`day`); FK `action_id` restrict; unique (`day`, `followed_activity_id`, `swap_index`).
The reasons live in `offer_reason`. The two Today chips default to 20 min and Medium energy and reset each day (PRD F-002). `ai_worded` and
`display_text` were removed: there is no AI text in P0 (ADR-006). Add them back with the AI adapter.

### `offer_reason`
The reasons shown for one offer: the card shows rank 1, and "Why this suggestion?" (frame 3.1) lists all of them.
Every reason must come from a rule in EQ-004 (BR-004).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `offer_id` | text | no | — | FK → option_offer, cascade delete |
| `rank` | int | no | — | 1 is the strongest term in EQ-003 |
| `reason_code` | text | no | — | EQ-004 code |
| `reason_text` | text | no | — | Shown to the user. Library text in P0 |

**Constraints / indexes:** PK (`offer_id`, `rank`).

### `plan_item`
Something on Today's plan (frames 2.5 to 2.7, 3.7, 11.6): an accepted suggestion, a one-off the person planned, or
a Together RSVP. Serves BR-005 (nothing is planned without accept or edit).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `plan_…` | PK |
| `source` | plan_source | no | — | `offer` (accepted or edited), `custom` ("Plan your own", 3.7), `together_event` (RSVP, 11.6) |
| `offer_id` | text | yes | null | FK → option_offer; set when `source` = `offer` |
| `action_id` | text | yes | null | FK → action; null for most custom items and RSVPs |
| `activity` | activity_kind | no | — | |
| `title` | text | no | — | What the card shows |
| `planned_day` | text | no | — | Local `YYYY-MM-DD` |
| `planned_time` | text | yes | null | Local `HH:mm` |
| `duration_min` | int | yes | null | |
| `with_whom` | with_whom | no | `solo` | "Just me", "With friends" (3.7), or `event` |
| `together_event_id` | text | yes | null | Server event id when `source` = `together_event`. The title and time are copied here so Today works offline |
| `detail_text` | text | yes | null | Display line, e.g. a public venue, for RSVPs only |
| `started_at` | datetime | yes | null | The optional "I'm starting" marker (ADR-014). Cleared about 3 hours after it is set. Nothing is recorded while under way |
| `created_at` | datetime | no | now | |

**Constraints / indexes:** index (`planned_day`). Deleting a plan item deletes its `reflection`.

### `reflection`
Quick Reflection (F-003). Serves BR-008, BR-009.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `ref_…` | PK |
| `plan_item_id` | text | no | — | FK → plan_item, cascade delete; unique |
| `status` | reflection_status | no | unknown | Created as `unknown` when the plan item is created. The grid counts `completed` and `partly` only (EQ-002) |
| `enjoyment` | int | yes | null | 1 Not for me, 2 Okay, 3 Enjoyed it 🔒 (frame 3.11b). Null when not answered: neutral, never positive (EQ-003, EQ-009) |
| `barrier` | barrier | yes | null | Only asked after `partly` or `skipped` (BR-008) 🔒 |
| `updated_at` | datetime | no | now | |

### `pause`
Intentional pauses and lighter or rescheduled periods (UJ-004, BR-006).

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `pau_…` | PK |
| `kind` | pause_kind | no | — | |
| `start_day` | text | no | — | Local date |
| `end_day` | text | yes | null | Null = until resumed. The pause sheet offers 3 days, 1 week or 2 weeks (frame 3.3); 1 week is preselected |

### `observation`
What Works for Me (F-004). Serves BR-010.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `obs_…` | PK |
| `text` | text 🔒 | no | — | Shown to the user |
| `source` | obs_source | no | — | |
| `status` | obs_status | no | proposed | Only `confirmed` affects ranking (BR-010) |
| `pattern_key` | text | no | — | Machine-readable pattern, e.g. `tag:with_company:enjoyed` (EQ-009) |
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
| `what_changed` | text 🔒 | yes | null | Comma set of `what_changed` (frame 4.1; skipping stores null) |
| `approach` | return_approach | yes | null | |

### `achievement_earned`
Milestones the person has earned (F-015, BR-023). They only ever increase. Computed from reflections and
`return_event`; the row records when it was first earned and whether the celebration sheet (3.12) was shown.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `code` | text | no | — | PK: `back_at_it`, `bounced_back`, `something_new`, `explorer`, `active_days_10`, `active_days_30`, `active_days_100`, `found_your_rhythm` |
| `earned_day` | text | no | — | Local date |
| `celebrated` | bool | no | false | Set when the celebration sheet has been shown |

### `notification_setting`
F-008. Serves BR-012, BR-013.

| Column | Type | Null | Default | Notes |
|---|---|---|---|---|
| `id` | text | no | `"me"` | PK; single row |
| `enabled` | bool | no | false | BR-012 |
| `mode` | text | no | `before_free_time` | `before_free_time` (the Settings row's "Before my free time") or `fixed` (frame 7.3's "When": Morning 8:00 or a picked time). One reminder a day at most (EQ-005) |
| `fixed_time` | text | yes | null | Local `HH:mm` when `mode` = `fixed` |
| `lead_min` | int | no | 30 | Minutes before the start of the next free slot when `mode` = `before_free_time` [assumption] |
| `quiet_start` | text | no | `"21:00"` | Matches frame 7.3 [assumption] |
| `quiet_end` | text | no | `"07:00"` | Matches frame 7.3 [assumption] |
| `lapse_checkin_enabled` | bool | no | true | Weekly check-in after a lapse. No P0 screen changes it; the default stays true |

## 5. Deliberately not modeled
- **Users and accounts:** none on the device. Together (F-018) keeps its own server-side data (profile, events,
  clubs, RSVPs, reports; BR-025); health data is never in it. P1 sharing adds two server-side daily flags
  ([ADR-013](adr/ADR-013-p1-sharing-two-flags-and-device-local-count.md)) and a device-local together-days count,
  through a new schema change when it is built.
- **Streaks:** not stored. Totals (EQ-011) are computed from reflections, so nothing can "reset".
- **Analytics events:** none; metrics are computed from the tables above (EQ-010).
- **AI prompts and responses:** never stored (BR-020). No AI text is stored in P0.
- **Activity recordings (distance, pace, heart rate, routes):** never ([ADR-014](adr/ADR-014-lilt-does-not-record-activities.md)).
- **Rewards (F-009, F-011):** P1.

## 6. Known gaps / follow-ups
| Gap | Impact | Follow-up |
|---|---|---|
| Single device, no backup | Data is lost with the device | Export (BR-017); a backup or sync is a later decision |
| Library authoring and safety review | P0 needs content | PRD Q1; TASK-004; [seed](../seed/README.md) |
| Encryption at rest | SQLite file is not encrypted beyond OS sandboxing | Assess before real-user study (ADR if adopted) |
| Skeleton table `consent` already exists | The skeleton (TASK-001) only has `consent` | TASK-002 adds the other tables with migrations (schemaVersion 2) |

## 7. Frame option → stored value
The on-screen label is the source of truth for wording; the stored value is a stable code.

### Setup (frames 1.3 to 1.14)
| Frame | Question | Option label | Stored as |
|---|---|---|---|
| 1.3, 1.4 | What brings you here? (tick all that fit) | Keep going with something I do now | `followed_activity.path` = `keep_going` |
| | | Pick up something I stopped | `pick_up_again` |
| | | Add something new to what I do | `add_new` |
| | | Start being active for the first time | `start_fresh` (can't be combined with the others) |
| 1.5 | What do you do now? (pick one) | Walking, Running, Gym, Cycling, Swimming, Basketball, Racket sports, Yoga, Other | `followed_activity.activity` = the matching `activity_kind` (Other opens search 1.6; a typed name goes to `custom_name`) |
| 1.8 | What would you like to pick up again? (pick one) | Running, Gym, Swimming, Cycling, Basketball, Yoga, Dance, Other | same |
| 9.12 | Add something new, first question | Walking, Running, Gym, Cycling, Swimming, Yoga, Other | same (the activity the person already does; what to add is chosen later in Discover or Add) |
| 9.13 | Start fresh, first question | Dancing, Team sports, Racket sports, Not sure yet | `dance`, `team_sports`, `racket_sports`, `not_sure` (no specific activity; starters are offered, EV-005) |
| 1.6, 9.1 | Search the library; "Not listed? Add it yourself" | A library match, or a typed name | The matching `activity_kind`; a typed name is `other` with `custom_name` (red-flag checked, EQ-008). What an `other` activity is offered: library starters |
| 1.7 | How's the gym going? | Going well / Up and down / Getting harder | `progress` = `going_well` / `up_and_down` / `getting_harder` |
| 1.7 | What's making it harder? (optional) | Finding time / Energy / Getting bored / Cost / Motivation | `hard_because` = `finding_time` / `energy` / `getting_bored` / `cost` / `motivation` |
| 1.9 | When did you stop, roughly? | A few weeks ago / A few months ago / A year or more | `stopped_ago` = `weeks` / `months` / `year_plus` |
| 1.10 | What got in the way? | Busier at work or study / Health or energy / Moved / Lost my group or gym / Just drifted / Prefer not to say | `got_in_the_way` = `busier` / `health_energy` / `moved` / `group_or_gym_changed` / `just_drifted` / `prefer_not_to_say` |
| 1.11 | What would make it easier now? | Shorter sessions / Someone to go with / A different time / Something similar / Not sure | `would_help` = `shorter_sessions` / `someone_to_go_with` / `different_time` / `something_similar` / `not_sure` |
| 1.12, 7.8 | Usually free | Early morning / Lunch / After work / Weekends | `preference` kind `free_time` = `early_morning` / `lunch` / `after_work` / `weekends` |
| 1.12 | What you have access to | Gym membership / Pool / Courts or a park nearby / Equipment at home / None of these | kind `access` = `gym_membership` / `pool` / `courts_or_park` / `home_equipment` / `none` |
| 1.12, 7.8 | What usually gets in the way | Time / Energy / Money / Weather / Motivation | kind `usual_barrier` = `time` / `energy` / `money` / `weather` / `motivation` |
| 1.13 | Why does being active matter to you? (up to 3) | More energy / Less stress / Sleep better / Time with people / Feel stronger / Be there for family / Just for fun / Prefer not to say | kind `motivation` = `more_energy` / `less_stress` / `sleep_better` / `time_with_people` / `feel_stronger` / `be_there_for_family` / `just_for_fun` / `prefer_not_to_say` |
| 1.14 | Anything to leave out? | Outdoors after dark / Team sports / High impact / Swimming / Nothing to leave out | kind `excluded` = `after_dark` / `team_sport` / `high_impact` / `swimming` (an `activity_kind`); none for "Nothing" |

### Today and the plan (frames 2.x, 3.x)
| Frame | Control | Option label | Stored as |
|---|---|---|---|
| 2.3 | Time chip | 10 / 20 / 30 / 45 min (default 20) | `option_offer.time_input_min` |
| 2.3 | Energy chip | Low / Medium / High energy (default Medium) | `option_offer.energy_input` = `low` / `medium` / `high` |
| 3.2 | How long | 10 / 20 / 30 / 45 min | `option_offer.edited_duration_min` |
| 3.2 | When | Today 12:30 / Today after work / Tomorrow 12:30 / Pick a time › | `option_offer.edited_day`, `edited_time` |
| 3.7 | What | Running / Gym / Pickleball / Other | `plan_item.activity` (`other` plus a typed `title`) |
| 3.7 | With | Just me / With friends | `plan_item.with_whom` = `solo` / `friends` |
| 3.7 | When | Tomorrow / a named day / Pick a date › | `plan_item.planned_day` |
| 3.7 | Time | 9:00 / 10:00 / Pick a time › | `plan_item.planned_time` |
| 3.7 | How long | 30 / 60 / 90 min | `plan_item.duration_min` |
| 3.9 | Where are you with it? | I already play / I used to play / New to me, I want to try it | `followed_activity.familiarity` = `already_play` / `used_to_play` / `new_to_me` |
| 3.3 | Pause for a while | 3 days / 1 week / 2 weeks | `pause.end_day` = start + 3 / 7 / 14 days (kind `pause`) |
| 3.3 | Something lighter | — | No row. A one-off swap to a lighter option for today (UJ-004, EQ-003 lighter mode); the shown offer becomes `replaced` |
| 3.3, 3.4 | Move it to later | — | No row. Updates the plan time (`edited_day`, `edited_time` or `plan_item.planned_time`). In P0 only "Pause for a while" writes a `pause` row (kind `pause`); `lighter` and `reschedule` stay readable values for later |
| 3.3 | Not today | — | The shown offer becomes `declined` |
| 3.3 | Something else | — | The shown offer becomes `replaced`; the next candidate has `swap_index` + 1 |
| 2.5, 2.5b | I'm starting / Not started yet | — | `plan_item.started_at` set / cleared |
| 3.11 | How did it go? | Done / Partly / Didn't get to it | `reflection.status` = `completed` / `partly` / `skipped` |
| 3.11 | What got in the way? (after Partly or Didn't get to it) | Time / Low energy / Didn't fit my schedule / Weather / Other / Prefer not to say | `reflection.barrier` = `time` / `low_energy` / `schedule` / `weather` / `other` / `prefer_not_to_say` |
| 3.11b | How was it? | Not for me / Okay / Enjoyed it | `reflection.enjoyment` = 1 / 2 / 3 |

### My Way Back (frames 4.x)
| Frame | Question | Option label | Stored as |
|---|---|---|---|
| 4.1 | What changed? | Busier at work or study / Health or energy / Family or caring / Moved or travelling / My group or gym changed / Just drifted / Prefer not to say | `return_event.what_changed` = `busier` / `health_energy` / `family_caring` / `moved` / `group_or_gym_changed` / `just_drifted` / `prefer_not_to_say` (Skip stores null) |
| 4.2 | What would you like to try? | Go back to what helped / Try something different | `return_event.approach` = `previous` / `different` (`starter` when the library offers starters, EV-005) |

### Settings (frames 7.x)
| Frame | Control | Stored as |
|---|---|---|
| 7.2 | Followed activities and their labels | `followed_activity` (`path` gives "Keeping it going", "Picking up again", "New to try") |
| 7.3, 7.1 | Daily reminder: "Before my free time" (the Settings row) or a fixed time (Morning 8:00 or a picked time); quiet hours | `notification_setting.mode`, `fixed_time`, `quiet_start`, `quiet_end` |
| 7.4, 7.5 | Export my data | A JSON file with every user table; delete-all leaves zero user rows (BR-017) |

### Rules a builder needs (decided 2026-10-27, owner can change)
- **Discover follow (3.9) sets the path:** `already_play` → `keep_going`, `used_to_play` → `pick_up_again`, `new_to_me` → `add_new`.
- **Clock times behind the free-time slots** (for `suggested_time`): `early_morning` 07:00, `lunch` 12:30, `after_work` 18:30, `weekends` Saturday 10:00 [assumption, from frames 2.3 and 3.4].
- **"Prefer not to say" is exclusive** on every multi-choice question: picking it clears the others, and picking another clears it. "Nothing to leave out" (1.14) and "None of these" (1.12 access) are exclusive in the same way.
- **Required or skippable:** 1.3 to 1.9 and 1.12 to 1.14 need an answer (Next stays disabled until one is picked); 1.10 and 1.11 have Skip, 1.7's "What's making it harder?" is optional.
- **Changing a reflection from Partly or Didn't get to it to Done clears `barrier`** (it is asked only after those two answers, BR-008).
- **Order:** followed activities and their Today cards are in `followed_at` order. The ⋮ on a Today card opens Edit (3.2). The ⋮ on 7.2 has no frame; the builder offers Unfollow.
- **Saved (Discover):** the cards are library actions, so Saved is `saved_action`. A Together club card is not saved locally; it links to Together.
- **Comma-set columns** (`hard_because`, `got_in_the_way`, `would_help`, `what_changed`) are acceptable in P0. The export documents them as comma-separated codes.
- **Stored but not used by any rule in P0:** `usual_barrier`, `motivation` and `access` (except where EQ-003 and EQ-004 name them), `got_in_the_way`, `stopped_ago`, `progress`. They are kept for the person's own summary and for later; no reason text may cite them (BR-004).
- **Motivations have no edit screen of their own in P0;** the person changes them by re-running setup from Settings (S-008 "edit starting point").

### What the schema enforces (added with TASK-002)
- **Foreign keys are on** (`PRAGMA foreign_keys = ON`) and deleted rows are overwritten (`PRAGMA secure_delete = ON`), so delete-all really removes the data (BR-017).
- **Delete actions:** `option_offer.followed_activity_id` set null; `plan_item.offer_id` set null; `plan_item.action_id` and `option_offer.action_id` restrict (a used library action cannot be deleted); `saved_action.action_id` cascade; `offer_reason`, `reflection` cascade from their parent.
- **Uniqueness:** one preference per (`kind`, `value`); at most 3 `motivation` rows (trigger); one reflection per plan item; one plan item per offer; one offer per (`day`, `followed_activity_id`, `swap_index`) and, for offers with no followed activity, per (`day`, `swap_index`).
- **Checks:** `reflection.enjoyment` is null or 1 to 3; `profile.id` and `notification_setting.id` can only be `me`.
- **Defaults:** ids and timestamps are filled by the app, not by SQL, so raw SQL inserts must supply them. All timestamps are UTC (`DateTime.now().toUtc()`).
- **Free-text codes in P0:** `hard_because`, `what_changed`, `what_would_help`, the preference value sets, tag codes and `notification_setting.mode` are stored as text codes without a Dart enum or a SQL check. The domain layer parses them. Add enums when a rule needs them.
- **Export:** one JSON file made in a single transaction, with a `format_notes` block that documents enums, comma sets, booleans and dates.

### Rules for the code that uses the schema (owed by later tasks)
- **Totals never decrease (BR-007, BR-023, EQ-011):** a total is computed from `reflection` and `return_event`, which the schema can change. So no repository may lower a `completed` or `partly` reflection or delete one except through delete-all, and `achievement_earned` is written with insert-or-ignore so `earned_day` never changes (its only update is `celebrated` false to true). TASK-005 owns this and tests it.
- **Library reload (TASK-004):** the loader must upsert and never delete rows that `option_offer`, `plan_item` or `saved_action` use (reloading must not erase a person's Saved list or fail on history). It runs after consent. TC-022 counts user tables only; `action` is the library.
- **Rows created after consent (TASK-005):** `profile` and `notification_setting` are inserted when setup starts, not before consent. A `reflection` row (status `unknown`) is created with each plan item by the plan repository.
- **Resuming a pause:** the repository sets `end_day` to the resume day.
- **Delete-all hooks:** the notification cancellation (F-008) and the Together account deletion (F-018, BR-017) must be registered through `deleteAllHooksProvider`. Each must be idempotent. A test must fail if either is missing once those features exist.
