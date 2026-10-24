# PRD — Rhythm (working name)

**Status:** Draft v0.3 · **Owner:** Shieryl · **Last updated:** 2026-10-24

v0.3 changes:
- Narrowed to physical activity. Setup now learns about the person first, Today shows one hero
  suggestion, and two options are added: "my plan fell through" and suggested times (ADR-005).
- No LLM in P0 (ADR-006).
- Social features expanded in P1, with friend streaks (ADR-007).
- Consent has no decline screen.

v0.2: BR-019 and BR-020 added.

**Conventions.** `F-###` features, `UJ-###` user journeys, `BR-###` business rules. Acceptance
criteria are plain, testable bullets. IDs are never renumbered; removed items are marked `(cut)`.

**Sources.**
| Source | Used for |
|---|---|
| "Sustaining Healthy Behaviors — Problem and Concept Brief" (owner, 2026-10-23): UNITE job statement, behaviour stages, research grounding, Rhythm concept and core features | §1, §4, §5, §6, §7 |
| PRD interview with the owner, 2026-10-23 (learning approach, P0 scope, data location, outcomes, notifications, streaks, circles, rewards, commit grid) | §2, §3, §5, §6, §10, §11 |
| Dzelle's concept input, 2026-10-24: Strava's social motivation, activity fit (running, gym, pickleball), learning about the person first, schedule fit and calendar, plans that fall through, health-platform tracking | §1, §5, §7, §11 |
| Owner decisions, 2026-10-24: physical-activity focus, social in P1, friend streaks allowed, free times now with calendar as a stretch, no AI in P0, no consent decline screen ([ADR-005](adr/ADR-005-physical-activity-focus.md), [ADR-006](adr/ADR-006-no-ai-in-p0.md), [ADR-007](adr/ADR-007-friend-streaks-in-social-phase.md)) | §2, §5, §6, §7, §8, §11 |
| [Future Health Challenge page](https://hack2skill.com/event/futurehealthchallenge/), checked 2026-10-23 (Wellbeing track, deadlines, judging criteria, consent and data-minimisation expectations) | §2, §6 |
| [BRD](brd.md) | Business objectives, payer hypotheses, business risks (not restated here) |

---

## 1. Problem
Many people want to be active, but struggle to start, sustain, or resume it when it feels hard to
fit into their current circumstances: limited time, energy, money, access, or control over the day.
Two things make it worse:
- **Not every activity suits every person.** Some like running, some the gym, some pickleball, and
  many never find the kind that suits them.
- **Activity doesn't fit their schedule.** Most people don't know how to fit it in, and plans with
  friends fall through.

Today they cope with tracking apps and wearables (satisfying at first, then repetitive),
all-or-nothing restarts that collapse after a setback, and social accountability. After a
disruption such as a move, a demanding period, or new responsibilities, rebuilding can feel like one
overwhelming whole, and a missed day can feel like erased progress.

**Job statement (UNITE):** *When everyday demands or life changes make healthy behaviours difficult
to sustain, I want to find a manageable way to start, continue, or return within my current
circumstances, so I can care for my health alongside my responsibilities and personal priorities.*

**Evidence boundary:** written responses from six friends (four students, two working people), the
founder's experience, and one teammate's review. This is a convenience sample, not representative
and not validated in Abu Dhabi. It informs hypotheses only.

## 2. Context & constraints
- **Why now:** the Future Health Digital Innovation Challenge, Wellbeing track. Prototype submission
  is due **2026-11-20**; it needs a working prototype plus technical documentation of assumptions
  and limitations.
- **Deadline / budget:** about 4 weeks; team of 2–4; target $0 (free tiers). See [BRD](brd.md) §8.
- **Platform:** Flutter app for Android (APK) and a web demo ([ADR-002](adr/ADR-002-flutter-android-web-on-device.md)).
- **Domain:** **physical activity** ([ADR-005](adr/ADR-005-physical-activity-focus.md)). Other
  healthy habits (sleep, hydration…) are out of scope for this phase.
- **Interaction model:** one suggestion card, quick selections, and progress views. **No chatbot.**
- **Learning approach:** a transparent, rules-based ranking over a curated activity library. It
  learns from each person's own answers: activities they like and why, what they finished or
  enjoyed, what got in the way, and when they are free. Every suggestion shows its reason.
  **No LLM in P0** ([ADR-006](adr/ADR-006-no-ai-in-p0.md)).
- **Data:** on the device only, with no account, for all P0 features. Nothing leaves the phone. P1
  social features need an opt-in account and a backend.
- **Legal / privacy:** users are global. Explicit consent, data minimisation, user-controlled
  sharing and deletion. Wellness framing only, with no diagnosis or treatment, to stay outside
  medical-device rules. Respect cultural and religious sensitivities. The challenge rules page
  could not be read (see §13).

## 3. Goals
| # | Goal (outcome, not output) | Measured by (§10) |
|---|---|---|
| G1 | People who lapse come back to being active | Return after lapse |
| G2 | Suggested activities fit people's real circumstances (what they like, their time, access and energy), and fit better over time | Options feel feasible |
| G3 | Being active feels worthwhile, not just tracked | Worthwhile, not just tracked |
| G4 | Participation continues across ordinary ups and downs, without personal streak pressure | Sustained participation |

## 4. Personas
Behaviour stages are situations a person moves between, not fixed types. Every stage is a valid
entry point.

| Persona | Goal | Context | Constraint | Primary? |
|---|---|---|---|---|
| **The Returner** (stages 4–6: demanding period → lapse → returning) | Find a workable way back to being active when the previous routine no longer fits | Moving, exams, caregiving, a new job, or household disruption broke an established routine | Recovery feels like an overwhelming whole; old arrangements (gym times, a running group) may no longer work | ✅ |
| The Stretched Starter/Sustainer (stages 1–3) | Begin or keep being active | Work or study load, commuting, fatigue, valued leisure, doomscrolling | Limited time and energy; doesn't know which activity suits them or when to fit it in | |
| The Repeat Attempter (stage 7) | Find an activity that feels worth continuing | Starts and stops; tracking feels repetitive; results feel insufficient | Low perceived reward; hasn't found an activity they enjoy; sometimes financial limits | |

## 5. Features & user stories
| ID | Feature | User story | Priority |
|---|---|---|---|
| F-001 | My Starting Point | As a person starting, maintaining, or returning, I want to tell the app which activities I already like and why, what I have access to (e.g. a gym membership), when I'm usually free, what gets in the way, what to leave out, my reason and my stage, so that suggestions fit my life from day one. | P0 |
| F-002 | Today's Suggestion | As a busy person, I want one activity suggestion that fits today, with the reason and a suggested time. I want to accept or edit it, swap it ("Something else", up to 2 more), or choose "Not today" (lighter, later, pause, or "my plan fell through"), so that I do something realistic today. Suggestions may include new activities similar to ones I like. | P0 |
| F-003 | Quick Reflection | As a user who just tried (or skipped) an activity, I want to mark completed, partly completed, or skipped and optionally note enjoyment, effort, or a barrier (including "didn't fit my schedule"). I want to see what the app will change as a result, so that future suggestions fit better. | P0 |
| F-004 | What Works for Me (lite) | As a user, I want to see, edit, and delete observations about what works for me, see how my suggestions have changed over time, and save activities to repeat, so that I stay in control of what the app has learned. | P0 |
| F-005 | My Way Back | As a Returner, I want to say what changed (schedule, environment, responsibilities, energy, or something else) and then review a previously helpful approach or try a different one, so that returning feels manageable. | P0 |
| F-006 | Meaningful Progress (commit grid) | As a user, I want a GitHub-style grid of small rectangles that get brighter the more of my daily goal I achieve, plus returns after breaks and my reported experiences, so that I see progress without guilt. | P0 |
| F-007 | Consent & My Data | As a user, I want to understand what data is used and that it stays on my phone, and export or delete all my data, so that I trust the app. | P0 |
| F-008 | Gentle Notifications | As a user, I want occasional opt-in reminders at times I choose that never nag or guilt me, and that quiet down when I pause, so that I remember without feeling pressured. | P0 |
| F-009 | Personal Rewards | As a user, I want to set my own reward for a goal I choose (e.g. "after 5 walks this month → movie night"), so that progress feels worthwhile. | P1 |
| F-010 | Friends & Circles | As a user, I want to add friends or join a small circle (friends, family, a community group), share my progress if I choose, see how they are doing, cheer them on, and keep a friend streak if we opt in, so that my effort is seen and celebrated. | P1 |
| F-011 | Group Rewards | As a circle creator, I want to set a shared reward for a group goal (e.g. "family dinner out"), so that the group celebrates together. | P1 |
| F-012 | Group Challenges & Events | As a user, I want to create or join a challenge or an event (e.g. "pickleball this Saturday"), and get a suggested alternative if it is cancelled, so that being active is something I do with others. | P1 |
| F-013 | Calendar-aware Timing | As a user, I want the app to read my phone's calendar (on the device, if I allow it) and suggest a free slot, so that I don't have to work out when to fit activity in. | P1 (stretch for P0) |
| F-014 | Activity Data Import | As a user, I want the app to learn from activities my phone or watch already records (Health Connect, Apple Health), so that I don't have to log everything by hand. | P1 |

**Hard cuts (this phase):**
- Competitive leaderboards: they create pressure and guilt for people in a lapse, which conflicts
  with the primary persona. Social features are cooperative.
- Chatbot: not part of the concept.
- LLM rewording ([ADR-006](adr/ADR-006-no-ai-in-p0.md)).

## 6. Business rules

### Safety & scope
| ID | Rule | Applies to |
|---|---|---|
| BR-001 | No screen, option, observation, or notification contains diagnosis, treatment, medical claims, or a promise of results (e.g. "will lower your blood pressure", "guaranteed"). | All |
| BR-002 | Every offered activity comes from the curated activity library, using its reviewed text. Nothing adds numeric body targets (weight, calories), medication, or supplement advice. | F-002, F-004, F-005 |
| BR-003 | If free text contains a red-flag term from the red-flag list ([Methods](methods.md)), such as self-harm, disordered eating, or chest pain, the app shows no suggestion for that input. It shows a fixed support message that points to professional or emergency help instead. | F-001, F-003, F-005 |
| BR-004 | Every offered suggestion shows a plain-language reason based on the user's own inputs (e.g. "You said walks with company felt good"). A new-to-you activity says why it is similar to something they like. | F-002 |
| BR-019 | (Dormant in P0, ADR-006) Any text reworded or drafted by AI carries a visible "AI-worded" label, and the original library text is one tap away. | — |
| BR-020 | (Dormant in P0, ADR-006) No prompt or AI response content is logged or stored beyond the displayed text. An AI call that fails or times out silently falls back to library text. | — |

### Autonomy & tone
| ID | Rule | Applies to |
|---|---|---|
| BR-005 | No activity is planned, scheduled, or counted unless the user accepts or edits it. | F-002 |
| BR-006 | A pause is available on every suggestion screen, takes at most 2 taps, and is never counted or displayed as a failure or a miss. | F-002, F-006 |
| BR-007 | **Personal progress:** skipping, pausing, or lapsing never erases or resets prior progress. There are no personal streaks. Totals such as active days and returns never decrease, and no copy uses guilt or loss wording (e.g. "you broke", "you lost", "failed"). The wording list is in [DESIGN.md](DESIGN.md). Friend streaks (P1) follow BR-021. | F-003, F-005, F-006, F-008 |
| BR-008 | The app never assumes why a lapse happened. It asks with neutral options that include "prefer not to say", and the question can be skipped. | F-003, F-005 |
| BR-009 | A missing reflection is stored as "unknown", never as "skipped", and does not lower a suggestion's ranking. | F-003, F-006 |
| BR-010 | Proposed observations affect ranking only after the user confirms them. Users can edit or delete any observation, and a deleted one stops affecting ranking. | F-004 |
| BR-011 | Users can exclude any activity category, for personal, cultural, or religious fit. Excluded categories are never offered. | F-001, F-002 |
| BR-021 | (P1, [ADR-007](adr/ADR-007-friend-streaks-in-social-phase.md); guardrails to confirm, Q8) Friend streaks exist only between people who opt in. When one ends, no personal total, tile or history changes. The app never shows who ended it. A member's pause doesn't end it. Ending copy is neutral and avoids the DESIGN.md "never use" list. | F-010, F-012 |

### Notifications
| ID | Rule | Applies to |
|---|---|---|
| BR-012 | Notifications are off until the user opts in and picks the times. | F-008 |
| BR-013 | At most the daily and weekly caps in [Methods](methods.md) are sent. None are sent during a pause or quiet hours. After a lapse, only one gentle check-in per week is sent, and the user can turn it off. | F-008 |

### Data & privacy
| ID | Rule | Applies to |
|---|---|---|
| BR-014 | Before any personal data is collected, a consent screen explains what data is used and that it stays on the device. Nothing is stored until the user agrees. | F-007 |
| BR-015 | For P0, all personal data is stored only on the device. There is no account, no network call that carries personal data, and no analytics that include personal data. | All P0 |
| BR-016 | (Dormant in P0, ADR-006) Data is sent to an LLM only after explicit AI opt-in, and only in de-identified minimum form. | — |
| BR-017 | The user can export all their data and delete all their data from settings. Delete-all removes every local record and cannot be undone. | F-007 |
| BR-018 | (P1 social) A member shares only what they opt into (by default grid brightness only, never reflections or barriers). Social views show no ranking. A paused member is shown neutrally. Leaving a circle or deleting an account removes the member's shared data. | F-010, F-011, F-012 |
| BR-022 | (F-013) Calendar access is opt-in and read on the device only, to find free slots. Event titles and details are never stored, shown elsewhere, or exported. | F-013 |

## 7. User journeys
### UJ-001 — First run
1. Open the app → Welcome & consent (BR-014). The user agrees; there is no decline path (closing
   the app stores nothing).
2. My Starting Point: activities they like and why, access and memberships, usual free times, what
   gets in the way, what to leave out, their reason and stage.
3. See the first suggestion on Today.
- **Edge cases:** user picks "returning" (offer My Way Back); red-flag text in the reason (BR-003).

### UJ-002 — Daily loop
1. Optional gentle notification (F-008) → open Today.
2. Optionally set time and energy → see one suggestion with its reason and a suggested time
   (BR-004).
3. Accept, edit, swap ("Something else", up to 2 more), or "Not today".
4. Later: Quick Reflection (optional) → the app says what it will change next time.
5. The grid tile brightens according to the share of the goal achieved (F-006).
- **Edge cases:** no reflection (stays unknown, BR-009); pause (neutral tile, BR-006); all
  categories excluded (prompt to adjust).

### UJ-003 — Return after a break (primary)
1. After a lapse ([Methods](methods.md)), the app opens with a neutral "welcome back", not a
   lost-streak message (BR-007).
2. My Way Back: what changed? (optional, includes "prefer not to say")
3. Choose a previous helpful approach or try a different one → a smaller first action.
4. The grid shows the return; the returns count increases.
- **Edge cases:** no previous helpful approach (offer library starters); user chooses to stay
  paused.

### UJ-004 — Demanding period or a plan falls through
1. From Today, choose "Not today": "something lighter", "move it to later", "pause for a while", or
   "my plan fell through".
2. "My plan fell through" offers an alternative that fits the same time slot.
3. Notifications quiet down during a pause (BR-013). Progress is kept (BR-007).

## 8. Acceptance criteria
### F-001 — My Starting Point
- [ ] The user can complete setup in ≤ 2 minutes. It covers at least one liked activity (or "not
  sure yet"), usual free times, a stage, and optional reason, access, barriers, and exclusions.
- [ ] Excluded categories are saved and never offered (BR-011).
- [ ] Red-flag text triggers the fixed support message and no suggestion (BR-003).

### F-002 — Today's Suggestion
- [ ] Shows one library activity with a reason and a suggested time from the user's free times
  (BR-002, BR-004).
- [ ] "Something else" shows up to 2 more, each with a reason.
- [ ] A new-to-you activity names the liked activity it is similar to (BR-004).
- [ ] Accept, edit, swap, lighter, later, pause, and "my plan fell through" all work; pause takes
  ≤ 2 taps (BR-006).
- [ ] Nothing is planned without accept or edit (BR-005).

### F-003 — Quick Reflection
- [ ] Completed, partly completed, or skipped, plus optional enjoyment, effort, or barrier, saved
  in ≤ 3 taps.
- [ ] Unanswered reflection is stored as unknown (BR-009).
- [ ] Reflections change the next ranking in the expected direction ([Methods](methods.md)).
- [ ] After saving, the app states in one sentence what it will change (e.g. shorter, earlier, a
  different activity).

### F-004 — What Works for Me (lite)
- [ ] Lists observations; each can be confirmed, edited, or deleted (BR-010).
- [ ] Shows how suggestions have changed since setup (e.g. "Week 1: 20-min runs → now 10-min lunch
  walks with a friend").
- [ ] Saved activities appear as suggestions again.

### F-005 — My Way Back
- [ ] Shown after a lapse with neutral copy (BR-007, BR-008).
- [ ] Offers the previous helpful approach (if any) and a different one.

### F-006 — Meaningful Progress (commit grid)
- [ ] The grid shows one small rectangle per day; brightness level follows the goal-achievement
  levels in [Methods](methods.md).
- [ ] Pause days have a distinct neutral marker, not an empty or "failed" tile (BR-006).
- [ ] Active-day and return totals never decrease after a skip or lapse (BR-007).
- [ ] No guilt or loss wording appears anywhere on the screen (BR-007).

### F-007 — Consent & My Data
- [ ] The consent screen appears before any data is collected, and nothing is stored before the
  user agrees (BR-014).
- [ ] The app makes no network call carrying personal data (BR-015).
- [ ] Export produces a readable file; delete-all leaves no local records (BR-017).

### F-008 — Gentle Notifications
- [ ] Off by default; the user picks times (BR-012).
- [ ] Caps, quiet hours, pause silence, and the post-lapse weekly check-in are enforced (BR-013).
- [ ] No notification text contains guilt wording (BR-007).

## 9. Vocabulary
| Term | Meaning in this product |
|---|---|
| Activity | One kind of physical activity (running, gym, pickleball, walking…) in the curated library, with attributes such as social, cost, access and intensity |
| Suggestion | An activity offered today, with a reason and a suggested time |
| Activity profile | What the user told us in setup: liked activities and why, access, free times, barriers, exclusions |
| Reflection | The user's optional report after an activity: completed, partly completed, skipped, or unknown, plus enjoyment, effort, or barrier |
| Observation | A statement about what works for the user, proposed from their reflections; it needs confirmation |
| Pause | An intentional, user-chosen break; never a failure |
| Lapse | No logged activity for the threshold set in [Methods](methods.md), without a pause |
| Return | The first logged activity after a lapse |
| Commit grid | GitHub-style day tiles (small rectangles); brighter means more of the day's goal achieved |
| Circle (P1) | A small cooperative group with a shared goal and no ranking |
| Friend streak (P1) | A shared, opt-in run of active days between friends, governed by BR-021 |

## 10. Success metrics
Measured in user sessions or a short diary study during the challenge. These are not at-scale
analytics; on-device data is shared only with the participant's consent.

| Metric | Target | Why it matters (not a vanity metric) |
|---|---|---|
| Return after lapse: share of participants who lapse and then log a return | Report count/total; no fixed target (hypothesis test) | Directly tests G1 and the primary persona |
| Options feel feasible: share of suggestions accepted as-is or with small edits, early vs. later | Rises over the study (direction, not a number) | Shows the learning works (G2) |
| New activity tried: participants who try at least one suggested activity new to them | Report count/total | Tests "find activities that fit you" (G2, G3) |
| Worthwhile: participants reporting a personally meaningful benefit or enjoyment | Report count/total | Tests "worthwhile, not just tracked" (G3) |
| Sustained participation: active weeks out of study weeks, regardless of streaks | Report distribution | Continuity without streak pressure (G4) |

## 11. Non-goals
- Chatbot or free-form AI conversation: not part of the concept.
- LLM features in P0 ([ADR-006](adr/ADR-006-no-ai-in-p0.md)).
- Competitive leaderboards: they conflict with the no-guilt principle; social features are
  cooperative.
- Diagnosis, clinical risk scores, or medical advice: wellness only (BR-001).
- Healthy habits other than physical activity (sleep, hydration…) in this phase.
- Social features, accounts and sync in P0: on-device first; they arrive with P1 (F-010..F-012).
- Wearable or health-platform integration in P0: planned as P1 (F-014).
- Monetisation and billing during the challenge: the payer is still a hypothesis ([BRD](brd.md) §5).

## 12. Risks & dependencies
| Risk / dependency | Impact | Mitigation |
|---|---|---|
| Curated activity library: needs authoring, attributes for similarity, and a safety review | P0 blocked without it | ~40 activities across clear categories; a reviewed seed set ([seed](../seed/README.md)) |
| Setup asks more (liked activities, access, free times) and feels long | Drop-off at first run | ≤ 2 minutes; most answers are taps; "not sure yet" allowed |
| Learning shows no visible improvement within a short study | G2 unproven | After every reflection, say what changes; show "how Rhythm adjusted" on My rhythm; report honestly |
| No LLM weakens the AI and technical-depth judging criteria | Lower score | Present the ranking as an explainable personalisation engine; document it in depth ([BRD](brd.md) RK-009) |
| New ideas keep expanding scope | Missed submission | Social, calendar and health data are P1; feature freeze 2026-11-13 |
| Notification permission refused | F-008 unused | The app works without notifications |
| P1 social adds accounts and a backend | Architecture rework later | System design leaves a seam for optional sync |

## 13. Open questions
| # | Question | Owner | Blocks |
|---|---|---|---|
| Q1 | Who writes the activity library, and from which evidence sources? | Owner | F-002 |
| Q2 | ~~Which LLM provider and model?~~ Resolved: no LLM in P0 (ADR-006) | — | — |
| Q3 | Lapse threshold in days, and notification caps ([Methods](methods.md), assumptions until sourced) | Owner | F-005, F-008 |
| Q4 | How do judges get the app: APK, TestFlight, or a web build? | Team | Deployment |
| Q5 | The challenge rules (data use, IP, submission format): rules page unreadable on 2026-10-23 | Owner | Submission |
| Q6 | Personal Rewards (F-009) was set to P1 to limit the P0 count. Promote it? | Owner | Nothing |
| Q7 | Which activity categories go in library v1 (e.g. walking, running, gym, home workouts, racket sports, team sports, dance)? | Owner + Dzelle | TASK-004 |
| Q8 | Confirm the friend-streak guardrails (BR-021) and how a streak counts (daily or weekly) | Owner | F-010, F-012 design |
| Q9 | Is F-013 (calendar) attempted before the 2026-11-13 freeze? Decide by 2026-11-06 | Owner | Nothing in P0 |

## 14. Traceability
| Feature | Story / journey | Rules | Tests |
|---|---|---|---|
| F-001 | UJ-001 | BR-003, BR-011, BR-014 | TC-001 |
| F-002 | UJ-002, UJ-004 | BR-002, BR-004, BR-005, BR-006, BR-011 | TC-002 |
| F-003 | UJ-002 | BR-003, BR-007, BR-008, BR-009 | TC-003 |
| F-004 | UJ-002 | BR-002, BR-010 | TC-004 |
| F-005 | UJ-003 | BR-002, BR-003, BR-007, BR-008 | TC-005 |
| F-006 | UJ-002, UJ-003 | BR-006, BR-007, BR-009 | TC-006 |
| F-007 | UJ-001 | BR-014, BR-015, BR-017 | TC-007 |
| F-008 | UJ-002, UJ-004 | BR-007, BR-012, BR-013 | TC-008 |
| F-009 | — (P1) | BR-001, BR-007 | — |
| F-010 | — (P1) | BR-018, BR-021 | — |
| F-011 | — (P1) | BR-018 | — |
| F-012 | — (P1) | BR-018, BR-021 | — |
| F-013 | — (P1, stretch) | BR-022 | — |
| F-014 | — (P1) | BR-015, BR-018 | — |
