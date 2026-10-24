# PRD — Rhythm (working name)

**Status:** Draft v0.2 (v0.2: BR-019 and BR-020 added for the AI capability during bootstrap) · **Owner:** Shieryl · **Last updated:** 2026-10-23

**Conventions.** `F-###` features, `UJ-###` user journeys, `BR-###` business rules. Acceptance
criteria are plain, testable bullets. IDs are never renumbered; removed items are marked `(cut)`.

**Sources.**
| Source | Used for |
|---|---|
| "Sustaining Healthy Behaviors — Problem and Concept Brief" (owner, 2026-10-23): UNITE job statement, behaviour stages, research grounding, Rhythm concept and core features | §1, §4, §5, §6, §7 |
| PRD interview with the owner, 2026-10-23 (learning approach, P0 scope, data location, outcomes, notifications, streaks, circles, rewards, commit grid) | §2, §3, §5, §6, §10, §11 |
| [Future Health Challenge page](https://hack2skill.com/event/futurehealthchallenge/), checked 2026-10-23 (Wellbeing track, deadlines, judging criteria, consent and data-minimisation expectations) | §2, §6 |
| [BRD](brd.md) | Business objectives, payer hypotheses, business risks (not restated here) |

---

## 1. Problem
People who want healthier routines struggle to start, sustain, or resume them when those
behaviours feel hard to fit into their current circumstances: limited time, energy, money, access,
or control over the day. Even when they value the benefits, they postpone acting or stop. Today
they cope with tracking apps and wearables (satisfying at first, then repetitive), all-or-nothing
restarts that collapse after a setback, and social accountability. After a disruption such as a
move, a demanding period, or new responsibilities, rebuilding can feel like one overwhelming whole,
and a missed day can feel like erased progress.

**Job statement (UNITE):** *When everyday demands or life changes make healthy behaviours difficult
to sustain, I want to find a manageable way to start, continue, or return within my current
circumstances, so I can care for my health alongside my responsibilities and personal priorities.*

**Evidence boundary:** written responses from six friends (four students, two working people) plus
the founder's experience. This is a convenience sample, not representative and not validated in
Abu Dhabi. It informs hypotheses only.

## 2. Context & constraints
- **Why now:** the Future Health Digital Innovation Challenge, Wellbeing track. Prototype submission
  is due **2026-11-20**; it needs a working prototype plus technical documentation of assumptions
  and limitations.
- **Deadline / budget:** about 4 weeks; team of 2–4; target $0 (free tiers). See [BRD](brd.md) §8.
- **Platform:** mobile app. The team has Flutter experience; the stack is decided in `choose-stack`.
- **Interaction model:** action cards, quick selections, and progress views. **No chatbot.**
- **Learning approach (hybrid):** a transparent ranking over a curated action library, driven by
  the user's reflections. An LLM only rewords library options and drafts observations for the user
  to confirm. The app works fully with AI switched off.
- **Data:** on-device first, with no account, for all P0 features. P1 circles need an opt-in
  account and a backend.
- **Legal / privacy:** users are global. Explicit consent, data minimisation, user-controlled
  sharing and deletion. Wellness framing only, with no diagnosis or treatment, to stay outside
  medical-device rules. Respect cultural and religious sensitivities. The challenge rules page
  could not be read (see §13).

## 3. Goals
| # | Goal (outcome, not output) | Measured by (§10) |
|---|---|---|
| G1 | People who lapse come back to their chosen behaviour | Return after lapse |
| G2 | Offered options fit people's real circumstances, and fit better over time | Options feel feasible |
| G3 | The behaviour feels worthwhile, not just tracked | Worthwhile, not just tracked |
| G4 | Participation continues across ordinary ups and downs, without streak pressure | Sustained participation |

## 4. Personas
Behaviour stages are situations a person moves between, not fixed types. Every stage is a valid
entry point.

| Persona | Goal | Context | Constraint | Primary? |
|---|---|---|---|---|
| **The Returner** (stages 4–6: demanding period → lapse → returning) | Find a workable way back when the previous routine no longer fits | Moving, exams, caregiving, a new job, or household disruption broke an established routine | Recovery feels like an overwhelming whole; old arrangements may no longer work | ✅ |
| The Stretched Starter/Sustainer (stages 1–3) | Begin or keep a meaningful behaviour | Work or study load, commuting, fatigue, valued leisure, doomscrolling | Limited time and energy; benefits feel distant | |
| The Repeat Attempter (stage 7) | Understand what makes the behaviour worthwhile | Starts and stops; tracking feels repetitive; results feel insufficient | Low perceived reward; sometimes financial limits | |

## 5. Features & user stories
| ID | Feature | User story | Priority |
|---|---|---|---|
| F-001 | My Starting Point | As a person starting, maintaining, or returning, I want to choose one healthy behaviour, my personal reason, my stage, and my constraints and preferences, so that suggestions fit my life from day one. | P0 |
| F-002 | Today's Options | As a busy person, I want a small selection of actions I can accept, edit, replace, or pause, with optional time and energy inputs, so that I do something realistic today. | P0 |
| F-003 | Quick Reflection | As a user who just tried (or skipped) an action, I want to mark completed, partly completed, or skipped and optionally note enjoyment, effort, or a barrier, so that future options fit better. | P0 |
| F-004 | What Works for Me (lite) | As a user, I want to see, edit, and delete observations about what works for me and save actions to repeat, so that I stay in control of what the app has learned. | P0 |
| F-005 | My Way Back | As a Returner, I want to say what changed (schedule, environment, responsibilities, energy, or something else) and then review a previously helpful approach or try a different one, so that returning feels manageable. | P0 |
| F-006 | Meaningful Progress (commit grid) | As a user, I want a GitHub-style grid of tiles that get brighter the more of my daily goal I achieve, plus returns after breaks and my reported experiences, so that I see progress without guilt. | P0 |
| F-007 | Consent & My Data | As a user, I want to understand what data is used and how, opt in or out of AI, and export or delete all my data, so that I trust the app. | P0 |
| F-008 | Gentle Notifications | As a user, I want occasional opt-in reminders at times I choose that never nag or guilt me, and that quiet down when I pause, so that I remember without feeling pressured. | P0 |
| F-009 | Personal Rewards | As a user, I want to set my own reward for a goal I choose (e.g. "after 5 walks this month → movie night"), so that progress feels worthwhile. | P1 |
| F-010 | Cooperative Circles | As a user, I want to join a small circle of friends, family, or a community group with a shared goal, where we encourage each other and can see each other's grids if we choose, with no ranking, so that I have support without competition. | P1 |
| F-011 | Group Rewards | As a circle creator, I want to set a shared reward for a group goal (e.g. "family dinner out"), so that the group celebrates together. | P1 |

**Hard cuts (this phase):**
- Competitive leaderboards: they create pressure and guilt for people in a lapse, which conflicts
  with the primary persona. Circles are cooperative instead.
- Chatbot: not part of the concept.

## 6. Business rules

### Safety & scope
| ID | Rule | Applies to |
|---|---|---|
| BR-001 | No screen, option, observation, or notification contains diagnosis, treatment, medical claims, or a promise of results (e.g. "will lower your blood pressure", "guaranteed"). | All |
| BR-002 | Every offered action comes from the curated action library. AI may reword an action's text, but must not change its type, duration, or intensity, and must not add numeric body targets (weight, calories), medication, or supplement advice. Text failing the check is replaced by the library's original text. | F-002, F-004, F-005 |
| BR-003 | If free text contains a red-flag term from the red-flag list ([Methods](methods.md)), such as self-harm, disordered eating, or chest pain, the app shows no suggestion for that input. It shows a fixed, non-AI support message that points to professional or emergency help instead. | F-001, F-003, F-005 |
| BR-004 | Every offered option shows a plain-language reason it was offered, based on the user's own inputs (e.g. "You said walks with company felt good"). | F-002 |
| BR-019 | Any text reworded or drafted by AI carries a visible "AI-worded" label, and the original library text is one tap away. | F-002, F-004 |
| BR-020 | No prompt or AI response content is logged or stored beyond the displayed text. An AI call that fails or exceeds the timeout in [Methods](methods.md) silently falls back to library text, with no error blocking the flow. | F-002, F-004 |

### Autonomy & tone
| ID | Rule | Applies to |
|---|---|---|
| BR-005 | No action is planned, scheduled, or counted unless the user accepts or edits it. | F-002 |
| BR-006 | A pause is available on every options screen, takes at most 2 taps, and is never counted or displayed as a failure or a miss. | F-002, F-006 |
| BR-007 | Ending a streak, skipping, or lapsing never erases or resets prior progress. Totals such as active days and returns never decrease, and no copy uses guilt or loss wording (e.g. "you broke", "you lost", "failed"). The wording list is in [DESIGN.md](DESIGN.md). | F-003, F-005, F-006, F-008 |
| BR-008 | The app never assumes why a lapse happened. It asks with neutral options that include "prefer not to say", and the question can be skipped. | F-003, F-005 |
| BR-009 | A missing reflection is stored as "unknown", never as "skipped", and does not lower an option's ranking. | F-003, F-006 |
| BR-010 | AI-drafted observations affect ranking only after the user confirms them. Users can edit or delete any observation, and a deleted one stops affecting ranking. | F-004 |
| BR-011 | Users can exclude any action category, for personal, cultural, or religious fit. Excluded categories are never offered. | F-001, F-002 |

### Notifications
| ID | Rule | Applies to |
|---|---|---|
| BR-012 | Notifications are off until the user opts in and picks the times. | F-008 |
| BR-013 | At most the daily and weekly caps in [Methods](methods.md) are sent. None are sent during a pause or quiet hours. After a lapse, only one gentle check-in per week is sent, and the user can turn it off. | F-008 |

### Data & privacy
| ID | Rule | Applies to |
|---|---|---|
| BR-014 | A consent screen explains what data is used, what is not, and what (if anything) leaves the device, before any personal data is collected. | F-007 |
| BR-015 | For P0, all personal data is stored only on the device. There is no account and no analytics that include personal data. | All P0 |
| BR-016 | Data is sent to the LLM only after explicit AI opt-in, and only in de-identified minimum form (no name, contact details, or device IDs). With AI off, every P0 feature still works using library text. | F-002, F-004, F-007 |
| BR-017 | The user can export all their data and delete all their data from settings. Delete-all removes every local record and cannot be undone. | F-007 |
| BR-018 | (P1 circles) A member shares only what they opt into (by default grid brightness only, never reflections or barriers). Circles show no ranking. A paused member is shown neutrally. Leaving a circle or deleting an account removes the member's shared data. | F-010, F-011 |

## 7. User journeys
### UJ-001 — First run
1. Open the app → consent screen (BR-014) → choose whether to opt in to AI (BR-016).
2. My Starting Point: choose a behaviour, a reason, a stage (starting, maintaining, or returning),
   and constraints and excluded categories.
3. See the first Today's Options.
- **Edge cases:** user declines AI (library text only); user picks "returning" (offer My Way Back);
  red-flag text in the reason (BR-003).

### UJ-002 — Daily loop
1. Optional gentle notification (F-008) → open Today's Options.
2. Optionally set time and energy → see 1–3 options with reasons (BR-004).
3. Accept, edit, replace, or pause.
4. Later: Quick Reflection (optional).
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

### UJ-004 — Demanding period
1. From Today's Options, choose "lighter option", "reschedule", or "pause for a while".
2. Notifications quiet down (BR-013). Progress is kept (BR-007).

## 8. Acceptance criteria
### F-001 — My Starting Point
- [ ] The user can complete setup with one behaviour, one reason, a stage, and optional
  constraints in ≤ 2 minutes.
- [ ] Excluded categories are saved and never offered (BR-011).
- [ ] Red-flag text triggers the fixed support message and no suggestion (BR-003).

### F-002 — Today's Options
- [ ] Shows 1–3 library actions, each with a reason (BR-002, BR-004).
- [ ] Accept, edit, replace, and pause all work; pause takes ≤ 2 taps (BR-006).
- [ ] Nothing is planned without accept or edit (BR-005).
- [ ] With AI off, options use library text and the flow is otherwise identical (BR-016).

### F-003 — Quick Reflection
- [ ] Completed, partly completed, or skipped, plus optional enjoyment, effort, or barrier, saved
  in ≤ 3 taps.
- [ ] Unanswered reflection is stored as unknown (BR-009).
- [ ] Reflections change the next ranking in the expected direction ([Methods](methods.md)).

### F-004 — What Works for Me (lite)
- [ ] Lists observations; each can be confirmed, edited, or deleted (BR-010).
- [ ] Saved actions appear as options again.

### F-005 — My Way Back
- [ ] Shown after a lapse with neutral copy (BR-007, BR-008).
- [ ] Offers the previous helpful approach (if any) and a different one.

### F-006 — Meaningful Progress (commit grid)
- [ ] The grid shows one tile per day; brightness level follows the goal-achievement levels in
  [Methods](methods.md).
- [ ] Pause days have a distinct neutral marker, not an empty or "failed" tile (BR-006).
- [ ] Active-day and return totals never decrease after a skip or lapse (BR-007).
- [ ] No guilt or loss wording appears anywhere on the screen (BR-007).

### F-007 — Consent & My Data
- [ ] The consent screen appears before any data is collected (BR-014).
- [ ] The AI toggle works both ways at any time (BR-016).
- [ ] Export produces a readable file; delete-all leaves no local records (BR-017).

### F-008 — Gentle Notifications
- [ ] Off by default; the user picks times (BR-012).
- [ ] Caps, quiet hours, pause silence, and the post-lapse weekly check-in are enforced (BR-013).
- [ ] No notification text contains guilt wording (BR-007).

## 9. Vocabulary
| Term | Meaning in this product |
|---|---|
| Behaviour | One healthy routine the user chose (user-defined, within the safety boundary) |
| Action | One small, concrete thing to do, from the curated library |
| Option | An action offered today, with a reason |
| Reflection | The user's optional report after an action: completed, partly completed, skipped, or unknown, plus enjoyment, effort, or barrier |
| Observation | A statement about what works for the user; AI-drafted ones need confirmation |
| Pause | An intentional, user-chosen break; never a failure |
| Lapse | No logged action for the threshold set in [Methods](methods.md), without a pause |
| Return | The first logged action after a lapse |
| Commit grid | GitHub-style day tiles; brighter means more of the day's goal achieved |
| Circle (P1) | A small cooperative group with a shared goal and no ranking |

## 10. Success metrics
Measured in user sessions or a short diary study during the challenge. These are not at-scale
analytics; on-device data is shared only with the participant's consent.

| Metric | Target | Why it matters (not a vanity metric) |
|---|---|---|
| Return after lapse: share of participants who lapse and then log a return | Report count/total; no fixed target (hypothesis test) | Directly tests G1 and the primary persona |
| Options feel feasible: share of options accepted as-is or with small edits, early vs. later | Rises over the study (direction, not a number) | Shows the learning works (G2) |
| Worthwhile: participants reporting a personally meaningful benefit or enjoyment | Report count/total | Tests "worthwhile, not just tracked" (G3) |
| Sustained participation: active weeks out of study weeks, regardless of streaks | Report distribution | Continuity without streak pressure (G4) |

## 11. Non-goals
- Chatbot or free-form AI conversation: not part of the concept.
- Competitive leaderboards: they conflict with the no-guilt principle; circles are cooperative.
- Diagnosis, clinical risk scores, or medical advice: wellness only (BR-001).
- Wearable or health-platform integration: scope; possibly later.
- Monetisation and billing during the challenge: the payer is still a hypothesis ([BRD](brd.md) §5).
- Accounts and sync for P0: on-device first; accounts arrive only with P1 circles.

## 12. Risks & dependencies
| Risk / dependency | Impact | Mitigation |
|---|---|---|
| Curated action library: needs authoring and a safety review | P0 blocked without it | Start with a small library for 3–4 behaviours; a reviewed seed set ([seed](../seed/README.md)) |
| LLM provider: availability, quota, policy | Rewording and observations degrade | AI-off fallback is fully functional (BR-016) |
| Learning shows no visible improvement within a short study | G2 unproven | Make the ranking transparent; report honestly in the technical documentation |
| 8 P0 features in about 4 weeks | Missed submission | Walking skeleton first; feature freeze 2026-11-13; F-004 kept lite |
| Notification permission refused | F-008 unused | The app works without notifications |
| P1 circles add accounts and a backend | Architecture rework later | System design leaves a seam for optional sync |

## 13. Open questions
| # | Question | Owner | Blocks |
|---|---|---|---|
| Q1 | Who writes the action library, and from which evidence sources? | Owner | F-002 |
| Q2 | Which LLM provider and model (on-device vs. API)? | Team (choose-stack) | F-002 AI path, F-004 |
| Q3 | Lapse threshold in days, and notification caps ([Methods](methods.md), assumptions until sourced) | Owner | F-005, F-008 |
| Q4 | How do judges get the app: APK, TestFlight, or a web build? | Team | Deployment |
| Q5 | The challenge rules (data use, IP, submission format): rules page unreadable on 2026-10-23 | Owner | Submission |
| Q6 | Personal Rewards (F-009) was set to P1 to limit the P0 count. Promote it? | Owner | Nothing |

## 14. Traceability
| Feature | Story / journey | Rules | Tests |
|---|---|---|---|
| F-001 | UJ-001 | BR-003, BR-011, BR-014 | TC-001 |
| F-002 | UJ-002 | BR-002, BR-004, BR-005, BR-006, BR-011, BR-016, BR-019, BR-020 | TC-002 |
| F-003 | UJ-002 | BR-003, BR-007, BR-008, BR-009 | TC-003 |
| F-004 | UJ-002 | BR-002, BR-010, BR-016, BR-019, BR-020 | TC-004 |
| F-005 | UJ-003 | BR-002, BR-003, BR-007, BR-008 | TC-005 |
| F-006 | UJ-002, UJ-003 | BR-006, BR-007, BR-009 | TC-006 |
| F-007 | UJ-001 | BR-014, BR-015, BR-016, BR-017 | TC-007 |
| F-008 | UJ-002, UJ-004 | BR-007, BR-012, BR-013 | TC-008 |
| F-009 | — (P1) | BR-001, BR-007 | — |
| F-010 | — (P1) | BR-018 | — |
| F-011 | — (P1) | BR-018 | — |
