# Methods & Traceability — Glass-Box Ledger — Rhythm

> **Status:** Draft v0.1 · **Date:** 2026-10-23 · **Owner:** Shieryl
> **Traces back to:** [PRD](prd.md), [System Design](system-design.md) · **Forward to:** [QA](qa-test-plan.md)
> Owns: **every number the product computes or shows, and every threshold it uses.** If a value
> appears on screen, gates behaviour, or is quoted in the pitch, it has an `EQ-###` here.

## Why this doc exists
Judges score "Responsible AI, safety, and data governance", and users must trust why Rhythm
suggests what it does. Every option, grid tile, count, and notification follows a rule written
here. Nothing is a black box: the AI only rewords text, never decides. All values marked
**[assumption]** are design guesses that user sessions should tune (§5). None is a clinical
threshold.

## 1. Confidence rubric
| Level | Meaning | How it renders |
|---|---|---|
| **High** | Deterministic rule over stored data (counts, sums, time windows, set membership) | Shown as a value |
| **Medium** | Model output checked by a deterministic rule before use (EQ-007), or confirmed by the user (BR-010) | Shown with the "AI-worded" label (BR-019) |
| **Low** | Model output not checked by code | **Never displayed**; never decides behaviour |

**Rule:** an output's confidence is the lowest confidence among its load-bearing inputs.

## 2. Equation registry
Notation: "reflected day" = a local day with at least one reflection whose status is `completed`
or `partly`. "Paused day" = a day inside a `pause` of kind `pause`.

| `EQ-###` | Output | Formula / method | Inputs | Confidence | Reference |
|---|---|---|---|---|---|
| EQ-001 | Lapse detected | A **reflected day** is a local day (`plan_item.planned_day`) with at least one reflection `completed` or `partly`; `skipped` and `unknown` do not make one. `lapsed` iff the user has ≥ 1 reflected day ever **and** the last **3** consecutive local days [assumption] before today are neither reflected days nor paused days. The lapse starts on the first such day. Today is not counted (it is not over), a paused day breaks the run, and the lapse closes on the first reflected day after it (the return, EQ-011); a pause during an open lapse does not close it. | reflection, pause | High | BR-007, F-005 |
| EQ-002 | Grid level for a day (0–3, plus pause) | `s` = (count of `completed`) + 0.5 × (count of `partly`) that day; `r = s / daily_goal`. Level **0** if r = 0, **1** if 0 < r < 0.5, **2** if 0.5 ≤ r < 1, **3** if r ≥ 1 [assumption]. Paused day with r = 0 → **pause** state (drawn like level 0 per ADR-012; labelled "paused"). `unknown` and `skipped` add 0 but never darken a day below its level. With `daily_goal` = 1 (the P0 constant) a day is level 0, **2** (partly) or 3 (done); level 1 appears only if the goal is raised. | reflection, profile.daily_goal, pause | High | F-006, BR-006, BR-009 |
| EQ-003 | Option ranking | **Filter:** drop actions whose activity or tags are in the person's `excluded` preferences (BR-011); for options suggested **for today**, if a time input exists drop `duration_min` > time, and if energy = low drop `energy_needed` = high (a card suggested for another day, such as "Suggested Sat 10:00", is not filtered by today's chips). **Score** per action *a* using only reflections with status ≠ `unknown` (BR-009): `fit = (done + 1) / (n + 2)` where done = completed + 0.5 × partly and n = known reflections of *a* (Laplace smoothing); `enjoy = (sum of enjoyment − n_e) / (2 × n_e + 1)`, or 0 if n_e = 0 (scale 0–1); `enjoy` uses only answered enjoyment and is 0 when none (an unanswered enjoyment is neutral); `help = 0.1` when a stated `would_help` matches *a* (`shorter_sessions` and `duration_min` ≤ 20; `someone_to_go_with` and tag `with_company`); `bonus = 0.2 if saved + 0.2 per confirmed observation whose tag or activity pattern matches *a*` (only `confirmed`, BR-010). **score = 0.5 × fit + 0.3 × enjoy + help + bonus** [assumption: weights; the former `− 0.2 × hard` term is dropped because the effort question was retired]. **Also filter (implemented in `app/lib/domain/ranking.dart`):** leaving out "Team sports" (stored as the tag `team_sport`) also removes the `team_sports` and `basketball` activities, tagged or not (BR-011); an action with several `needs_*` tags needs all of them; offer only actions of the current `library_version` (data-model, retired actions); drop actions whose `needs_*` tag the person did not select under access (frame 1.12; `none` drops all of them); when `after_dark` is excluded, also do not schedule any `outdoors` action in dark hours (the tag alone does not stop an outdoor run at 18:30 in winter); candidates come from the whole library, not only the activities they follow, so an exclusion of something they follow (for example swimming) leaves the others. With no history and no starter that passes the filters, any action that passes is used. The result can still be shorter than 3 or empty (for example everything is left out); the screen shows its "nothing fits today" state (frame 9.3 draws it; the written spec is in sitemap.md §2 "S-004 when few or no options fit"). Take the top 3 with at most one per activity ("tag group" means the action's `activity` [assumption]; ties go to an activity the person follows, then to the action id, so the order never changes by chance); if the user has no history, take starters (`is_starter`). Lighter mode (UJ-004): restrict to `duration_min` ≤ 10 and `energy_needed` = low. | action, reflection, saved_action, observation, preference (`excluded`, `would_help`) | High | F-002, F-005 |
| EQ-004 | Reason shown with an option | The term with the largest positive contribution to EQ-003 picks a template: `fit` → "You managed this before"; `enjoy` → "You said this felt good"; `bonus` (observation) → the observation text; `bonus` (saved) → "You saved this"; `help` → "You said shorter sessions would help" or "You said company would help"; a `with_company` tag with `motivation` = `time_with_people` → "You like company"; starter → "A small way to begin"; lighter mode → "Short and gentle for today". When no term applies, a neutral library line is used ("Social and easy to learn", "A gentle way to get moving") that claims nothing about the person. A term counts only when it rests on something the person did or said: "You managed this before" needs at least one completed or partly reflection of that action, and "You said this felt good" needs an answered enjoyment above "Not for me". A new action that is similar to one they completed and enjoyed ("Enjoyed it") always says "Similar to [that action], which you enjoyed", before any term (BR-004, F-002). With no term, the order is: lighter mode, company, starter, neutral line ("Something different to try" for a high-energy action, never "gentle"). A reason may only cite an answer a rule above actually uses (BR-004). | EQ-003 terms | High | BR-004 |
| EQ-012 | What changes next (reflection sentence) | After a reflection is saved, one sentence under the answered card (a block headed "What changes next", with a left rule; not a snackbar) says what will change, and only what EQ-003 really does. It is worked out from the stored answer, so it is still there after a restart. Completed with no rating or "Enjoyed it" → "We’ll suggest this one a little more often." (fit always rises); completed rated "Not for me" or "Okay" → "Thanks for telling us." (the enjoyment term is 0 for those ratings, so no change is promised; see the open question in the TASK-003 review); partly with "Enjoyed it" → "Partly counts, and you enjoyed it."; partly otherwise → "Partly counts."; didn’t get to it → "We’ll suggest this one a little less often." (fit always falls). The card itself says "Any amount counts." (or "Rest counts too." for didn’t get to it). A barrier adds no promise: observations are not shown yet (F-004) and EQ-009 counts a barrier only on options not done. No sentence is a verdict on the person (BR-007). | reflection | High | F-003, BR-007, BR-008 |
| EQ-005 | Notification caps | Max **1** scheduled reminder per day and **5** per rolling 7 days [assumption]. None during quiet hours (default 21:00–07:00 [assumption], as in frame 7.3) or on paused days. While lapsed (EQ-001): only the weekly check-in, max **1** per 7 days, and only if `lapse_checkin_enabled`. Every kind of reminder counts toward the 1/day and 5/7 caps, and a booked reminder cannot push any rolling 7-day window that contains it over 5; two check-ins are never within 6 days of each other, before or after. Reminders are off until `enabled` is set (BR-012). | notification_setting, pause, EQ-001 | High | BR-012, BR-013 |
| EQ-006 | AI call limits | Timeout **4 s** per call [assumption] → fall back to library text (BR-020). Budget: max **30** AI calls per device per day [assumption]; beyond it, library text. Batch: one call rewords up to 3 options. | clock, local counter | High | BR-020, ADR-003 |
| EQ-007 | AI output safety check | Accept AI text only if **all** pass: (a) no term from the blocked-claims list DS-003 (case-insensitive, word boundaries); (b) no regex match for numeric body or diet targets `\b\d+\s*(kg|lbs?|kcal|calories|bpm|mg)\b`; (c) every number in the output appears in the library text (duration unchanged); (d) length ≤ 1.5 × library text length + 20 chars; (e) no guilt words from the DESIGN.md wording list. Otherwise use library text. | AI output, DS-003, action | Medium | BR-001, BR-002, BR-007 |
| EQ-008 | Red-flag detection on free text | Flag iff the normalised text contains any phrase from the red-flag list DS-002 (word boundaries). **Normalisation:** lowercase, accents stripped, straight and curly apostrophes removed ("don't" becomes "dont"), all other punctuation including hyphens replaced by a space, runs of spaces collapsed (so "self-harming" and "kill myself--please" still match). TASK-003 must ship a test corpus that includes true positives with apostrophes, curly apostrophes and plurals, and the everyday sentences that must not flag ("swimming strokes", "I hurt my knee running", "cutting myself some slack", "short of breath after the hill"). On flag: show S-090, do not store the text, no AI call. | free text, DS-002 | High | BR-003 |
| EQ-009 | Observation proposal | Propose an observation for pattern *p* (a tag, an activity, or a time of day) when ≥ **3** known reflections [assumption] match *p* **and** ≥ 2/3 of them are completed/partly with enjoyment = 3, "Enjoyed it" (positive; "Okay" and unanswered are neutral), or ≥ 2/3 are skipped with the same barrier (stopped-working). Text from a template, optionally AI-worded (passes EQ-007). Max 1 new proposal per day. A pattern key is `kind:value:outcome` (`tag:with_company:enjoyed`, `activity:running:barrier_weather`, `time:morning:enjoyed`); a pattern already observed, including a deleted one, is not proposed again; "prefer not to say" is not a barrier pattern; only positive (`enjoyed`) confirmed observations add the ranking bonus, so a confirmed "gets in the way" note never raises a score. When several patterns qualify, the highest agreement wins, then the most reflections, then the key. | reflection, action | High (template) / Medium (AI-worded) | F-004, BR-010 |
| EQ-010 | Study metric: options feel feasible | `acceptance = (accepted + light_edits) / (accepted + edited + replaced + declined)` per week (offers still `offered` at day end are left out), so each "Something else" counts as a not-accepted offer by design; a **light edit** = an edit that keeps the action and changes duration by ≤ 50% [assumption]. Compare week 1 with the last week. | option_offer | High | PRD §10 (G2) |
| EQ-011 | Totals: active days, returns | **Active days** = count of distinct reflected days (all time; a reflected day is defined in EQ-001: `completed` or `partly`). **Returns** = count of `return_event` rows; a return is recorded on the first reflected day after a lapse (EQ-001). Both are monotonic: no rule ever decreases them (BR-007). | reflection, return_event | High | F-006, BR-007, PRD §10 (G1, G4) |

**Fixed parameters** (recorded so they aren't re-invented):
| Parameter | Value | Source |
|---|---|---|
| Lapse window | 3 days | [assumption] EQ-001 |
| Options per day | 1–3 | PRD F-002 |
| Grid levels | 0–3 + pause state (drawn as level 0, ADR-012) | [assumption] EQ-002 |
| Default daily goal | 1 action | [assumption] Data Model |
| Pause reach | ≤ 2 taps | PRD BR-006 |
| Reflection | ≤ 3 taps | PRD F-003 acceptance |
| Notification caps | 1/day, 5/7 days, lapse check-in 1/7 days | [assumption] EQ-005 |
| Quiet hours default | 21:00–07:00 | [assumption], as in frame 7.3 |
| Dark hours for "Outdoors after dark" | 18:00–06:00; the slot times 07:00, 12:30, 18:30 and Saturday 10:00 decide it, not the season | [assumption] EQ-003 |
| Today's compact cards | Up to 2: the best option for each other followed activity, never the activity the hero shows | [assumption] sitemap S-004 |
| AI timeout | 4 s | [assumption] EQ-006 |
| AI calls per device per day | 30 | [assumption] EQ-006 |
| Gemini model | `gemini-3.5-flash-lite` | [ADR-003](adr/ADR-003-gemini-via-firebase-ai-logic.md) |
| Observation evidence | ≥ 3 reflections, ≥ 2/3 agreement | [assumption] EQ-009 |
| Light edit | duration change ≤ 50% | [assumption] EQ-010 |

## 3. Dataset / input registry
| `DS-###` | Dataset / input | Origin | Size | Personal data? | Notes |
|---|---|---|---|---|---|
| DS-001 | Action library | Hand-authored by the team; sources TBD (PRD Q1); safety and cultural review before release. **Draft v2 (2026-10-27): 48 actions across the 15 activity kinds** (every kind but `not_sure`, which has none), each with duration (5 to 60 min), intensity, energy, tags, starter flag and 1 to 3 similar actions. Group and team games are worded as "look for a game that welcomes beginners" because the app cannot promise how others play; there are seated options. Fields `reviewed_by` and `reviewed_on` are empty until the owner and Dzelle review it, and `test/content/release_gate_test.dart` fails a release or study build (`--dart-define=REQUIRE_REVIEWED_CONTENT=true`) until they are filled | ~40–60 actions across the activity kinds in docs/data-model.md | No | `app/assets/library/actions.json`; versioned (`library_version`) |
| DS-002 | Red-flag phrase list | Team-authored from public crisis-line and eating-disorder guidance (sources to cite). **Draft v2: 115 phrases** in three groups (self-harm, disordered eating, medical emergency), lowercase, accent-free and written without apostrophes ("cant breathe"). Phrases that fire on ordinary exercise talk were removed or made specific ("stroke", "hurt myself", "short of breath", "purge" alone); English only | ~50 phrases | No | `app/assets/library/red_flags.json`; needs expert review [assumption] |
| DS-003 | Blocked-claims list | Team-authored (cure, treat, diagnose, guarantee, lose weight, burn fat, …). **Draft v2: 67 terms**, each inflection listed on its own because matching is on word boundaries | ~40–100 terms | No | `app/assets/library/blocked_claims.json` |
| DS-004 | Synthetic demo personas | Generated by `app/tool/gen_seed.dart`, fixed seed | 2 personas × 45 days | No (synthetic) | See [seed](../seed/README.md) |
| DS-005 | Participant study exports | Participants' own exports, shared voluntarily | ≥ 5 participants (target) | **Yes**, consented | Handled under ADR-004; not stored in the repo |

## 4. Traceability (numbers ⇄ features ⇄ tests)
| EQ | Feature | Rule | Test |
|---|---|---|---|
| EQ-001 | F-005 | BR-007 | TC-029 |
| EQ-002 | F-006 | BR-006, BR-009 | TC-030 |
| EQ-003 | F-002 | BR-009, BR-010, BR-011 | TC-031 |
| EQ-004 | F-002 | BR-004 | TC-032 |
| EQ-005 | F-008 | BR-012, BR-013 | TC-033 |
| EQ-006 | F-002, F-004 | BR-020 | TC-034 |
| EQ-007 | F-002, F-004 | BR-001, BR-002, BR-007 | TC-035 |
| EQ-008 | F-001, F-003, F-005 | BR-003 | TC-036 |
| EQ-009 | F-004 | BR-010 | TC-037 |
| EQ-010 | — (study metric) | — | TC-038 |
| EQ-011 | F-006 | BR-007 | TC-039 |

## 5. Calibration
Thresholds marked [assumption] are tuned with the user-session and diary-study data (DS-005):
- the lapse window (does 3 days match when participants *feel* they stopped?);
- the ranking weights (do accepted options rise over the study?);
- the notification caps (does anyone report feeling nagged?).

The owner decides changes. Any change to a value in §2 needs an ADR and an update here. Safety
lists (DS-002, DS-003) need expert review before real-user sessions grow beyond informal testing
([ADR-004](adr/ADR-004-wellness-positioning-and-privacy-baseline.md)).
