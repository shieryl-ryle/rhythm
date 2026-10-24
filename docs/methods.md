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
| EQ-001 | Lapse detected | `lapsed` iff the user has ≥ 1 reflected day ever **and** the last **3** consecutive local days [assumption] before today are neither reflected days nor paused days. The lapse starts on the first such day. | reflection, pause | High | BR-007, F-005 |
| EQ-002 | Grid level for a day (0–3, plus pause) | `s` = (count of `completed`) + 0.5 × (count of `partly`) that day; `r = s / daily_goal`. Level **0** if r = 0, **1** if 0 < r < 0.5, **2** if 0.5 ≤ r < 1, **3** if r ≥ 1 [assumption]. Paused day with r = 0 → **pause marker** (not level 0). `unknown` and `skipped` add 0 but never darken a day below its level. | reflection, profile.daily_goal, pause | High | F-006, BR-006, BR-009 |
| EQ-003 | Option ranking | **Filter:** drop actions in excluded categories (BR-011); if a time input exists, drop `duration_min` > time; if energy = low, drop `energy_needed` = high. **Score** per action *a* using only reflections with status ≠ `unknown` (BR-009): `fit = (done + 1) / (n + 2)` where done = completed + 0.5 × partly and n = known reflections of *a* (Laplace smoothing); `enjoy = (sum of enjoyment − n_e) / (2 × n_e + 1)`, or 0 if n_e = 0 (scale 0–1); `hard = share of effort = hard`; `bonus = 0.2 if saved + 0.2 per confirmed observation whose tag matches *a*` (only `confirmed`, BR-010). **score = 0.5 × fit + 0.3 × enjoy − 0.2 × hard + bonus** [assumption: weights]. Take the top 3 with at most one per tag group; if the user has no history, take starters (`is_starter`). Lighter mode (UJ-004): restrict to `duration_min` ≤ 10 and `energy_needed` = low. | action, reflection, saved_action, observation, preference | High | F-002, F-005 |
| EQ-004 | Reason shown with an option | The term with the largest positive contribution to EQ-003 picks a template: `fit` → "You managed this before"; `enjoy` → "You said this felt good"; `bonus` (observation) → the observation text; `bonus` (saved) → "You saved this"; starter → "A small way to begin"; lighter mode → "Short and gentle for today". | EQ-003 terms | High | BR-004 |
| EQ-005 | Notification caps | Max **1** scheduled reminder per day and **5** per rolling 7 days [assumption]. None during quiet hours (default 21:00–08:00 [assumption]) or on paused days. While lapsed (EQ-001): only the weekly check-in, max **1** per 7 days, and only if `lapse_checkin_enabled`. | notification_setting, pause, EQ-001 | High | BR-012, BR-013 |
| EQ-006 | AI call limits | Timeout **4 s** per call [assumption] → fall back to library text (BR-020). Budget: max **30** AI calls per device per day [assumption]; beyond it, library text. Batch: one call rewords up to 3 options. | clock, local counter | High | BR-020, ADR-003 |
| EQ-007 | AI output safety check | Accept AI text only if **all** pass: (a) no term from the blocked-claims list DS-003 (case-insensitive, word boundaries); (b) no regex match for numeric body or diet targets `\b\d+\s*(kg|lbs?|kcal|calories|bpm|mg)\b`; (c) every number in the output appears in the library text (duration unchanged); (d) length ≤ 1.5 × library text length + 20 chars; (e) no guilt words from the DESIGN.md wording list. Otherwise use library text. | AI output, DS-003, action | Medium | BR-001, BR-002, BR-007 |
| EQ-008 | Red-flag detection on free text | Flag iff the normalised text (lowercase, accents stripped) contains any phrase from the red-flag list DS-002 (word boundaries). On flag: show S-090, do not store the text, no AI call. | free text, DS-002 | High | BR-003 |
| EQ-009 | Observation proposal | Propose an observation for pattern *p* (a tag, category, or time of day) when ≥ **3** known reflections [assumption] match *p* **and** ≥ 2/3 of them are completed/partly with enjoyment ≥ 2 (positive), or ≥ 2/3 are skipped with the same barrier (stopped-working). Text from a template, optionally AI-worded (passes EQ-007). Max 1 new proposal per day. | reflection, action | High (template) / Medium (AI-worded) | F-004, BR-010 |
| EQ-010 | Study metric: options feel feasible | `acceptance = (accepted + light_edits) / offered` per week, where **light edit** = an edit that keeps the action and changes duration by ≤ 50% [assumption]. Compare week 1 with the last week. | option_offer | High | PRD §10 (G2) |
| EQ-011 | Totals: active days, returns | **Active days** = count of distinct reflected days (all time). **Returns** = count of `return_event` rows; a return is recorded on the first reflected day after a lapse (EQ-001). Both are monotonic: no rule ever decreases them (BR-007). | reflection, return_event | High | F-006, BR-007, PRD §10 (G1, G4) |

**Fixed parameters** (recorded so they aren't re-invented):
| Parameter | Value | Source |
|---|---|---|
| Lapse window | 3 days | [assumption] EQ-001 |
| Options per day | 1–3 | PRD F-002 |
| Grid levels | 0–3 + pause marker | [assumption] EQ-002 |
| Default daily goal | 1 action | [assumption] Data Model |
| Pause reach | ≤ 2 taps | PRD BR-006 |
| Reflection | ≤ 3 taps | PRD F-003 acceptance |
| Notification caps | 1/day, 5/7 days, lapse check-in 1/7 days | [assumption] EQ-005 |
| Quiet hours default | 21:00–08:00 | [assumption] |
| AI timeout | 4 s | [assumption] EQ-006 |
| AI calls per device per day | 30 | [assumption] EQ-006 |
| Gemini model | `gemini-3.5-flash-lite` | [ADR-003](adr/ADR-003-gemini-via-firebase-ai-logic.md) |
| Observation evidence | ≥ 3 reflections, ≥ 2/3 agreement | [assumption] EQ-009 |
| Light edit | duration change ≤ 50% | [assumption] EQ-010 |

## 3. Dataset / input registry
| `DS-###` | Dataset / input | Origin | Size | Personal data? | Notes |
|---|---|---|---|---|---|
| DS-001 | Action library | Hand-authored by the team; sources TBD (PRD Q1); safety and cultural review before release | ~40–60 actions across 3–4 categories (target) | No | `app/assets/library/actions.json`; versioned |
| DS-002 | Red-flag phrase list | Team-authored from public crisis-line and eating-disorder guidance (sources to cite) | ~50 phrases | No | `app/assets/library/red_flags.json`; needs expert review [assumption] |
| DS-003 | Blocked-claims list | Team-authored (cure, treat, diagnose, guarantee, lose weight, burn fat, …) | ~40 terms | No | `app/assets/library/blocked_claims.json` |
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
