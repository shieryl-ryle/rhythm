# QA Test Plan — Rhythm

> Commands run from `app/`. Mobile-only checks live in [Mobile QA](mobile-qa.md).
> Test paths are planned; they are created by the tasks that build each feature.

## 1. Gates (run by `test-runner`)
| Gate | Command | Must pass before |
|---|---|---|
| Typecheck / lint | `flutter analyze` | every PR |
| Unit + widget | `flutter test` | every PR |
| Integration (E2E) | `flutter test integration_test` (Android emulator) | merge to main |
| Web build | `flutter build web --release --no-web-resources-cdn` | every deploy |
| Deployed check | TC-040 (Playwright MCP or manual) | every deploy and the submission |

Tests never call the paid Gemini tier. The AI adapter is faked in unit, widget, and integration
tests; TC-042 runs manually against the free tier with synthetic data only.

## 2. Test cases
### P0 features
| ID | Covers | Steps / assertion | Automated? |
|---|---|---|---|
| TC-001 | F-001 | Complete setup with behaviour, reason, stage, goal, one exclusion → profile saved; Today shows options; finish in ≤ 2 min (manual timing) | yes: `integration_test/first_run_test.dart` + manual timing |
| TC-002 | F-002 | Today shows 1–3 options with reasons; accept, edit, replace, and pause each update `option_offer.status` correctly | yes: `test/features/today/today_test.dart` |
| TC-003 | F-003 | Mark completed / partly / skipped with optional details in ≤ 3 taps; saved row matches | yes: `test/features/reflection/reflection_test.dart` |
| TC-004 | F-004 | Observations list; confirm, edit, delete work; saved actions reappear as options | yes: `test/features/what_works/what_works_test.dart` |
| TC-005 | F-005 | With seeded lapse → app opens My Way Back with "Welcome back"; previous approach and a different one offered; choosing one gives a smaller first action | yes: `integration_test/return_test.dart` |
| TC-006 | F-006 | Grid renders one tile per day with levels per EQ-002; paused day drawn as level 0 with semantics label "paused" (ADR-012); totals shown | yes: `test/features/progress/grid_test.dart` (golden) |
| TC-007 | F-007 | Consent before data; export file contains all tables; delete-all leaves zero user rows | yes: `test/data/my_data_test.dart` |
| TC-008 | F-008 | Off by default; enabling schedules within caps; disabling cancels all | yes: `test/notifications/scheduler_test.dart` + manual on device |

### Business rules
| ID | Covers | Steps / assertion | Automated? |
|---|---|---|---|
| TC-009 | BR-001 | Scan all library text, templates, notification copy, and the observation templates for DS-003 terms → zero matches | yes: `test/content/claims_scan_test.dart` |
| TC-010 | BR-002 | Fake AI returns text with a new duration, a kcal target, or a supplement mention → displayed text equals library text | yes: `test/ai/safety_check_test.dart` |
| TC-011 | BR-003 | Enter a DS-002 phrase in reason, barrier "other", or what-changed → S-090 shown, no suggestion, text not stored, no AI call | yes: `test/domain/red_flag_test.dart` + widget test |
| TC-012 | BR-004 | Every rendered option has non-empty reason text | yes: widget test in TC-002 file |
| TC-013 | BR-005 | Offered-but-untouched options are never counted in EQ-002, EQ-010 accepted, or reflections | yes: `test/domain/counting_test.dart` |
| TC-014 | BR-006 | Pause reachable in ≤ 2 taps from Today; a paused day is stored as pause, never counted as a lapse, and its tile's semantics label says "paused" | yes: widget test |
| TC-015 | BR-007 | Seed a 10-day lapse → active days and returns unchanged or higher; no string from the guilt-word list on Today, Progress, Way Back, or notification copy | yes: `test/content/guilt_words_test.dart` + `counting_test.dart` |
| TC-016 | BR-008 | What-changed question includes "prefer not to say" and can be skipped; no copy states a cause | yes: widget test |
| TC-017 | BR-009 | Accepted option with no reflection → status `unknown`; ranking score unchanged vs. no offer | yes: `test/domain/ranking_test.dart` |
| TC-018 | BR-010 | Proposed observation does not change ranking; after confirm it does; after delete it stops | yes: `ranking_test.dart` |
| TC-019 | BR-011 | Exclude a category → 100 ranking runs never return it | yes: `ranking_test.dart` |
| TC-020 | BR-012 | Fresh install → zero scheduled notifications until opt-in and time chosen | yes: `scheduler_test.dart` |
| TC-021 | BR-013 | Caps enforced; none in quiet hours or pause; lapse → only the weekly check-in, off when disabled | yes: `scheduler_test.dart` |
| TC-022 | BR-014 | Fresh install → no rows written before consent accepted | yes: `my_data_test.dart` |
| TC-023 | BR-015 | No network calls with AI off (HTTP override fails the test on any request); no analytics packages in `pubspec.yaml` | yes: `test/privacy/no_network_test.dart` + reviewer |
| TC-024 | BR-016 | Captured AI prompt contains only allowed fields (no reason, reflections, behaviour name); AI off → zero AI calls | yes: `test/ai/prompt_builder_test.dart` |
| TC-025 | BR-017 | Export contains every user table; delete-all → every user table empty, notifications cancelled, route `/welcome` | yes: `my_data_test.dart` |
| TC-026 | BR-018 | (P1 circles) Reviewer check: shared fields limited to the two daily flags (active, paused), shared only after the one-time opt-in; no activity names or durations; no ranking UI | reviewer (rules-reviewer) |
| TC-027 | BR-019 | (Dormant, ADR-006) AI-worded option shows the label; tap reveals library text | yes: widget test |
| TC-028 | BR-020 | (Dormant, ADR-006) Fake AI delays 5 s → library text shown within timeout + 0.5 s, no error; no prompt/response in logs or DB | yes: `test/ai/fallback_test.dart` |

### Equations (Methods)
| ID | Covers | Steps / assertion | Automated? |
|---|---|---|---|
| TC-029 | EQ-001 | Table test: 2 empty days → no lapse; 3 empty days → lapse; 3 paused days → no lapse; no history → no lapse | yes: `test/domain/lapse_test.dart` |
| TC-030 | EQ-002 | Table test of levels for goal 1 and 2 with completed/partly/skipped/unknown/pause combinations | yes: `test/domain/grid_level_test.dart` |
| TC-031 | EQ-003 | Fixture history → expected top-3 order (fixtures in `test/fixtures/expected/ranking_*.json`); filters for time, energy, exclusions; lighter mode | yes: `ranking_test.dart` |
| TC-032 | EQ-004 | Each dominant term yields its template | yes: `test/domain/reason_test.dart` |
| TC-033 | EQ-005 | Simulated 14 days: ≤ 1/day, ≤ 5/7 days, quiet hours honoured | yes: `scheduler_test.dart` |
| TC-034 | EQ-006 | 31st call in a day uses library text without calling AI | yes: `fallback_test.dart` |
| TC-035 | EQ-007 | Table of AI outputs → accept/reject per rule (a)–(e) | yes: `safety_check_test.dart` |
| TC-036 | EQ-008 | Phrase list hits incl. uppercase and accented variants; near-miss words not flagged | yes: `red_flag_test.dart` |
| TC-037 | EQ-009 | 2 matching reflections → no proposal; 3 with ≥ 2/3 agreement → proposal; max 1/day | yes: `test/domain/observation_test.dart` |
| TC-038 | EQ-010 | Fixture offers → expected weekly acceptance and light-edit counts | yes: `test/domain/metrics_test.dart` |
| TC-039 | EQ-011 | After lapse → return recorded once; totals never decrease across a 60-day simulated history | yes: `metrics_test.dart` |

### Capabilities & platform
| ID | Covers | Steps / assertion | Automated? |
|---|---|---|---|
| TC-040 | Public deployment | Open the deployed URL in a clean browser → consent → setup → Today shows options → reflect → Progress shows a lit tile | Playwright MCP via `test-runner`, else manual |
| TC-041 | Notifications | OS permission denied → app explains and works; tapping a reminder opens `/today`; check-in opens `/way-back` | manual on Android ([Mobile QA](mobile-qa.md)) |
| TC-042 | AI adversarial input | Synthetic preference tags with injection-like strings ("ignore rules…") → output still passes EQ-007 or falls back; never shows a new action | manual against the free tier with synthetic data |
| TC-044 | Large text (DESIGN.md) | At 200% system text size: side-by-side buttons stack full width; label/value pairs stack; no text clipped or overlapping on Today, sheets, Settings, Together; matches wireframe 9.15 | yes: golden tests at `textScaler: 2.0` + manual on Android |
| TC-045 | Tap targets (DESIGN.md) | Every tappable widget (chips, links, icon buttons, calendar days) has a hit area of at least 48×48 dp (calendar 44 dp) | yes: Flutter `androidTapTargetGuideline` / `meetsGuideline` widget tests |
| TC-046 | Under way state (ADR-014, BR-007, BR-009, EQ-002) | Accept an option → "I'm starting" shows "Under way" and the marked time; "Not started yet" returns to "Planned"; "I'm finished" opens the reflection with "Done" preselected; dismissing leaves the result unknown; leaving it for 3 hours clears "Under way"; at day end nothing shows "overdue" or "missed"; the grid does not change until a reflection is saved | yes: widget test + manual |
| TC-047 | Share card (F-015, BR-023, ADR-016) | Open 3.13 from 3.12 and from 6.2: the segmented control offers only fitting templates; the preview is the 4:5 area; there is no grid toggle, the grid appears only on Rhythm as an all-time count, and Explorer does not offer Activity; the generated image is 1080 × 1920 with content inside the 4:5 safe area; no times, places, notes, reflections or friend names appear; nothing is sent until Share… is tapped | yes: golden image test + manual |
| TC-043 | Offline | Airplane mode → all P0 flows work; AI-on falls back to library text | manual on Android + `no_network_test.dart` |

## 3. Exit criteria
- All gates green.
- Every P0 feature (F-001..F-008) has at least one passing TC.
- Every BR-### has a TC or a reviewer check (BR-018 is reviewer-only while P1).
- Every EQ-### has a passing TC.
- TC-040 passed on the deployed URL within 24 hours of submission.
