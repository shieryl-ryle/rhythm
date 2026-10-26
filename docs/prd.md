# PRD — Rhythm (working name)

**Status:** Draft v0.5 · **Owner:** Shieryl · **Last updated:** 2026-10-25

v0.5 changes ([ADR-009](adr/ADR-009-community-in-p0.md)):
- **Community is P0 (F-018).** A Together tab with events and clubs near you, RSVP, join and host.
- The app now needs an account, but only for Together.
- Health data stays on the device.
- F-013 (calendar sync) and F-016 (widget) move to P1.
- New rules: BR-025 to BR-029.

v0.4 changes ([ADR-008](adr/ADR-008-phone-integrations-and-platform-roadmap.md)):
- Setup asks which of 4 paths fits, with follow-ups for each (F-001).
- People can follow more than one activity (F-002).
- The grid shows on Today when the app opens (F-006).
- Challenges and events get their own tab with invites, in P1 (F-012).
- F-013 now adds activities to the phone's calendar instead of reading free slots.
- New features: share achievements (F-015) and an Android widget (F-016), both P0; iPhone and Apple
  Watch (F-017), P1.

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
- **Platform:** Flutter app for Android (APK) and a web demo for the challenge
  ([ADR-002](adr/ADR-002-flutter-android-web-on-device.md)). iPhone, Apple Watch and iOS widgets
  are P1 ([ADR-008](adr/ADR-008-phone-integrations-and-platform-roadmap.md)).
- **Domain:** **physical activity** ([ADR-005](adr/ADR-005-physical-activity-focus.md)). Other
  healthy habits (sleep, hydration…) are out of scope for this phase.
- **Interaction model:** one suggestion card, quick selections, and progress views. **No chatbot.**
- **Learning approach:** a transparent, rules-based ranking over a curated activity library. It
  learns from each person's own answers: activities they like and why, what they finished or
  enjoyed, what got in the way, and when they are free. Every suggestion shows its reason.
  **No LLM in P0** ([ADR-006](adr/ADR-006-no-ai-in-p0.md)).
- **Data:** personal and health data (setup answers, reflections, grid, observations) stays on
  the device, with no account needed. **Together (F-018)** is the exception:
  - It needs an account.
  - It stores a community profile (display name, optional photo, approximate area), clubs,
    events, RSVPs and reports in Firebase.
  - It never stores health data there (BR-025).

  Sharing a card is a user action through the phone's share sheet
  ([ADR-009](adr/ADR-009-community-in-p0.md)).
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
| F-001 | My Starting Point | As a person starting, maintaining, or returning, I want to tick every situation that fits me, then answer one question at a time for each:<br>(1) **continue** an activity I already do;<br>(2) **add a new** activity alongside it;<br>(3) **pick up again** one I stopped, including why it stopped;<br>(4) **start** for the first time (this one can't be combined with the others).<br>Then I tell it, by tapping options, when I'm usually free, what I have access to, what gets in the way, why it matters to me, and what to leave out, so that suggestions fit my life from day one. | P0 |
| F-002 | Today's Suggestion | As a busy person, I want one activity suggestion that fits today, with the reason and a suggested time. I want to accept or edit it, swap it ("Something else", up to 2 more), or choose "Not today" (lighter, later, pause, or "my plan fell through"), so that I do something realistic today. I can follow more than one activity (e.g. running and pickleball) and add or remove them anytime. Today also shows a few new activities to try. Each opens a detail page where I can add it or plan it. I can **plan my own** activity (pick activity, day, time, length), and it joins Today's plan next to the ones I accepted. | P0 |
| F-003 | Quick Reflection | As a user who just tried (or skipped) an activity, I want to mark completed, partly completed, or skipped and optionally note enjoyment, effort, or a barrier (including "didn't fit my schedule"). I want to see what the app will change as a result, so that future suggestions fit better. | P0 |
| F-004 | What Works for Me (lite) | As a user, I want to see, edit, and delete observations about what works for me, see how my suggestions have changed over time, and save activities to repeat, so that I stay in control of what the app has learned. | P0 |
| F-005 | My Way Back | As a Returner, I want to say what changed (schedule, environment, responsibilities, energy, or something else) and then review a previously helpful approach or try a different one, so that returning feels manageable. | P0 |
| F-006 | Meaningful Progress (commit grid) | As a user, I want a GitHub-style grid of small rectangles that get brighter the more of my daily goal I achieve, shown on Today as soon as I open the app, plus returns after breaks and my reported experiences on My rhythm, so that I see progress without guilt. | P0 |
| F-007 | Consent & My Data | As a user, I want to understand what data is used and that it stays on my phone, and export or delete all my data, so that I trust the app. | P0 |
| F-008 | Gentle Notifications | As a user, I want occasional opt-in reminders at times I choose that never nag or guilt me, and that quiet down when I pause, so that I remember without feeling pressured. | P0 |
| F-009 | Personal Rewards | As a user, I want to set my own reward for a goal I choose (e.g. "after 5 walks this month → movie night"), so that progress feels worthwhile. | P1 |
| F-010 | Friends & Circles | As a user, I want to add friends or join a small circle (friends, family, a community group), share my progress if I choose, see how they are doing, cheer them on, and see our "together days" (days we were both active, a count that only goes up) with milestone celebrations, so that my effort is seen and celebrated. | P1 |
| F-011 | Group Rewards | As a circle creator, I want to set a shared reward for a group goal (e.g. "family dinner out"), so that the group celebrates together. | P1 |
| F-012 | Group Challenges & Events | As a user, I want a **Challenges** section in **Together › Mine** (no separate tab) where I can create and join group challenges and events (e.g. "pickleball this Saturday"). I want to invite people who already use Rhythm in the app, and people who don't through a link, QR code or join code that also brings them to the app. I want a suggested alternative if an event is cancelled, so that being active is something I do with others. | P1 |
| F-013 | Calendar Sync | As a user, I want to add my planned activities to my phone's calendar if I allow it, so that they show up in Google Calendar or Apple Calendar alongside everything else. Rhythm writes to the calendar on the device, and my calendar account syncs it as usual. | P1 (moved from P0 stretch by ADR-009) |
| F-014 | Activity Data Import | As a user, I want the app to learn from activities my phone or watch already records (Health Connect, Apple Health), so that I don't have to log everything by hand. | P1 |
| F-015 | Share Achievements | As a user, I want to share an achievement card (e.g. "Came back after a break", "First pickleball game", "30 active days") through my phone's share sheet to Instagram, TikTok, Facebook or X, so that my effort is seen and celebrated. In P1 I can also share an open challenge as a link, QR code or join code (F-012). | P0 (cards) · P1 (challenge sharing) |
| F-016 | Home-screen Widget | As a user, I want a home-screen widget that shows today's suggestion and my grid, and opens Today when tapped, so that I see it without opening the app. | P1 (moved from P0 by ADR-009) |
| F-018 | Community (Together tab) | As someone who'd rather be active with others, I want a **Together** tab where I can find events and clubs near me, filter by activity, level and time, see who's going, RSVP so it joins Today's plan, join clubs, and host my own event at a public place, so that I find people to do it with. Like Reclub, but tied to my rhythm. | P0 ([ADR-009](adr/ADR-009-community-in-p0.md)) |
| F-017 | iPhone & Apple Watch | As an iPhone user, I want Rhythm on my iPhone, and on my Apple Watch to see today's suggestion and log a quick check-in, so that it's with me wherever I am. | P1 |

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
| BR-007 | **Personal progress:** skipping, pausing, or lapsing never erases or resets prior progress. There are no personal streaks. Totals such as active days and returns never decrease, and no copy uses guilt or loss wording (e.g. "you broke", "you lost", "failed"). The wording list is in [DESIGN.md](DESIGN.md). This applies to shared and friend features too: there are no streaks anywhere ([ADR-010](adr/ADR-010-together-days-instead-of-friend-streaks.md)). | F-003, F-005, F-006, F-008 |
| BR-008 | The app never assumes why a lapse happened. It asks with neutral options that include "prefer not to say", and the question can be skipped. | F-003, F-005 |
| BR-009 | A missing reflection is stored as "unknown", never as "skipped", and does not lower a suggestion's ranking. | F-003, F-006 |
| BR-010 | Proposed observations affect ranking only after the user confirms them. Users can edit or delete any observation, and a deleted one stops affecting ranking. | F-004 |
| BR-011 | Users can exclude any activity category, for personal, cultural, or religious fit. Excluded categories are never offered. | F-001, F-002 |
| BR-021 | (P1, [ADR-010](adr/ADR-010-together-days-instead-of-friend-streaks.md)) Shared progress between friends only ever goes up. "Together days" counts days both people were active and never decreases or resets. The count is a high-water mark kept on each person's own phone: while both share, each phone updates it from the shared daily flags; when one person stops sharing, their flags are removed from the server (BR-018) and each phone keeps its last count, frozen. No pair count is stored on the server. A friend who is not sharing is shown as "Not sharing right now", with no notification and no "stopped" or "left" wording. Milestones are celebrated, and nothing is shown as ending, broken or lost. An optional weekly shared goal starts fresh each Monday, with no "missed" copy. Only people who opt in share it. | F-010, F-012 |

### Notifications
| ID | Rule | Applies to |
|---|---|---|
| BR-012 | Notifications are off until the user opts in and picks the times. | F-008 |
| BR-013 | At most the daily and weekly caps in [Methods](methods.md) are sent. None are sent during a pause or quiet hours. After a lapse, only one gentle check-in per week is sent, and the user can turn it off. | F-008 |

### Data & privacy
| ID | Rule | Applies to |
|---|---|---|
| BR-014 | Before any personal data is collected, a consent screen explains what data is used and that it stays on the device. Nothing is stored until the user agrees. | F-007 |
| BR-015 | For P0, all personal data is stored only on the device. There is no account, no network call by Rhythm that carries personal data, and no analytics that include personal data. Data leaves only through actions the user takes: export (BR-017), calendar sync (BR-022) and sharing (BR-023). | All P0 |
| BR-016 | (Dormant in P0, ADR-006) Data is sent to an LLM only after explicit AI opt-in, and only in de-identified minimum form. | — |
| BR-017 | The user can export all their data and delete all their data from settings. Delete-all removes every local record and, if a Together account exists, deletes that account and its server data (profile, RSVPs, hosted events). It cannot be undone. | F-007, F-018 |
| BR-018 | (P1 social) A member shares only what they opt into. The default is two daily flags: "active" (a day with at least one completed or partly action; a day with no reflection is unknown, BR-009, and is not shown as active) and "paused". Brightness levels are shared only if the member chooses that, and never reflections, barriers, activity names or durations. A one-time opt-in ("Share my active days" or "Not now") comes before the first challenge or friend, and nothing is sent until it is accepted. Social views show no ranking. A paused member is shown neutrally. Stopping sharing (Settings › Sharing, with a confirmation that names what is removed), leaving a circle or challenge, or deleting an account removes the member's shared flags from the server. The "together days" count is not recomputed from them (BR-021). | F-010, F-011, F-012 |
| BR-022 | Calendar sync is opt-in, and the user picks which calendar. Rhythm only adds and updates its own activity events (activity name, time, duration). It never reads, stores or exports the user's other events. Turning sync off stops new events; the user chooses whether to remove the ones already added. | F-013 |
| BR-023 | Nothing is shared unless the user taps Share. A shared achievement card or widget shows no reflections, barriers, reasons for stopping or other free text by default. Achievements are milestones that only ever increase (e.g. active days, returns, first time trying an activity). There are no personal streak counts (BR-007). Cards, widgets and notifications use no guilt or loss wording. | F-015, F-016 |
| BR-025 | Health data never leaves the device for Together: no setup answers, reflections, barriers, grid, observations or stop reasons. Firebase stores only the community profile (display name, optional photo, approximate area), clubs joined, events hosted, RSVPs and reports. Everything outside Together works without an account. (P1 exception, F-010/F-012, defined in BR-018: with the user's opt-in, only two daily flags leave the device, "active" and "paused". They are visible only to members of a challenge or friendship the user has joined, and stopping sharing removes them. The flags are stored on the user's Lilt account. What the user did, wrote or felt stays on the device.) | F-018 |
| BR-026 | Location is approximate. The user picks an area, or allows coarse location to suggest one. Precise coordinates are never stored or shown. Event venues are public places that the host enters. | F-018 |
| BR-027 | Together is for people aged 18+, confirmed at account creation. Hosts accept the community guidelines before posting, and events must be at public venues. | F-018 |
| BR-028 | Every event, club and profile can be reported or blocked. Content reported by 3 or more people [assumption] is hidden until reviewed. Blocked people's events and profiles are never shown to the blocker. | F-018 |
| BR-029 | Attendee lists show display names and avatars only, visible to signed-in users. Hosts can't see attendees' activity history. RSVP changes and cancellations show no guilt wording (BR-007). | F-018 |
| BR-024 | (P1) An invite link, QR code or join code carries only the challenge or event details and the inviter's chosen display name. A person who isn't a user sees only that public summary until they join. | F-012, F-015 |

## 7. User journeys
### UJ-001 — First run
1. Open the app → Welcome & consent (BR-014). The user agrees; there is no decline path (closing
   the app stores nothing).
2. My Starting Point, step 1: "What brings you here?"
   1. **Continue:** which activity, how it's going, what's getting harder.
   2. **Add a new one:** what they already do, then what they'd like to add or are curious about.
   3. **Pick up again:** which activity, roughly when it stopped, and why it stopped. The reasons
      are neutral options, plus "prefer not to say", and the question can be skipped (BR-008).
      Then what would make it easier now.
   4. **Start fresh:** what they enjoy or are curious about ("not sure yet" allowed).
3. Shared steps: usual free times, access and memberships, what gets in the way, what to leave
   out, and an optional reason.
4. See the first suggestion on Today, with the grid at the top.
- **Edge cases:**
  - Path (3) leads to Today opening with My Way Back's smaller first step.
  - Red-flag text in any free text triggers BR-003.

### UJ-002 — Daily loop
1. Optional gentle notification (F-008) → open Today.
2. Optionally set time and energy → see one suggestion with its reason and a suggested time
   (BR-004).
3. Accept, edit, swap ("Something else", up to 2 more), or "Not today".
4. Later: Quick Reflection (optional) → the app says what it will change next time.
5. The grid tile brightens according to the share of the goal achieved (F-006).
- **Edge cases:** no reflection (stays unknown, BR-009); pause (neutral level-0 tile, labelled "paused" for screen readers; BR-006, ADR-012); all
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

### UJ-005 — Find people to do it with
1. From Together, or from "Find a session near you" on an activity, browse events near your area.
2. Open an event → see who's going → "I'm going" → it appears in Today's plan.
3. Afterwards, check in as usual. The grid counts it like any other activity.
- **Edge cases:**
  - Not signed in: public events can be browsed; "I'm going", Join and Host show sign-in first, which explains that health data stays local.
  - No events nearby: clubs to join, or host one.
  - The event is cancelled: neutral notice plus an alternative for the same slot.

## 8. Acceptance criteria
### F-001 — My Starting Point
- [ ] The first question offers the 4 paths as checkboxes. Several can be ticked, except "start
  fresh", which clears the others. Next stays disabled until one is ticked, so no error screen is
  needed.
- [ ] Follow-ups appear one question at a time. A single-choice answer moves on automatically, and
  earlier answers fold into a summary that can be changed.
- [ ] "Other" opens an activity search over the library, with "Can't find it? Type it" as the only
  free text (red-flag checked, BR-003).
- [ ] Setup has no other free text. "Why it matters" is a set of tap options, including "Prefer not
  to say".
- [ ] Path (3) asks why the activity stopped, with neutral options, "prefer not to say", and skip
  (BR-008).
- [ ] The user can complete setup in ≤ 2 minutes. It covers at least one activity (or "not sure
  yet"), usual free times, and optional reason, access, barriers, and exclusions.
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
- [ ] The user can follow more than one activity, and add or remove them from Settings or Discover.
- [ ] Today shows one suggestion card per followed activity, each with its own reason, time,
  swap and "Not today".
- [ ] Today has "Try something new" (activities with reasons), "+ Add an activity" and "+ Plan your
  own". A custom plan appears in Today's plan with the accepted suggestions (BR-005: the user made
  it).
- [ ] Opening the app shows the grid as empty outlines while loading, then fills it in.

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
- [ ] The grid is visible at the top of Today when the app opens, with no scrolling. My rhythm
  shows the full history.
- [ ] The grid shows one small rectangle per day; brightness level follows the goal-achievement
  levels in [Methods](methods.md).
- [ ] Pause days show as a neutral filled tile, the same as a day with no activity, never a
  "failed" tile; the semantics label says "paused" (BR-006, ADR-012).
- [ ] Active-day and return totals never decrease after a skip or lapse (BR-007).
- [ ] No guilt or loss wording appears anywhere on the screen (BR-007).

### F-007 — Consent & My Data
- [ ] The consent screen appears before any data is collected, and nothing is stored before the
  user agrees (BR-014).
- [ ] The app makes no network call carrying personal data (BR-015).
- [ ] Export produces a readable file; delete-all leaves no local records (BR-017).

### F-018 — Community (Together tab)
- [ ] Together is the third of four tabs (Today, Discover, Together, My rhythm). Signed-out people can browse public events and clubs; "I'm going", Join and Host show the sign-in screen first, which explains what's shared. The rest
  of the app never requires an account (BR-025).
- [ ] It lists events and clubs near the chosen area, filterable by activity, level and day. Each
  event shows its time, public venue, level, host and spots left.
- [ ] "I'm going" RSVPs and adds the event to Today's plan. Cancelling uses neutral copy
  (BR-029).
- [ ] Clubs can be joined, and a club page lists its upcoming sessions.
- [ ] A signed-in adult can host an event: activity, title, date and time, public venue, level
  and spots, after accepting the guidelines (BR-027).
- [ ] Report and block work on events, clubs and profiles (BR-028).
- [ ] Firestore security rules allow writing only one's own profile, RSVPs and hosted events.
  Rule tests pass.
- [ ] Seeded events and clubs are labelled as samples.
- [ ] Together has three segments: Events, Clubs and Mine. Mine lists my RSVPs, the events I host and my
  clubs. In P1 it also holds a "With friends" section with Challenges and Friends (F-010, F-012). The
  P1 section is drawn as a separate frame, "11.9 Together · mine (P1)".

### F-013 — Calendar Sync (P1)
- [ ] Off by default. Turning it on asks for the calendar permission and which calendar to use
  (BR-022).
- [ ] An accepted or edited activity appears in that calendar with its name, time and duration.
  Moving or cancelling it in Rhythm updates the event.
- [ ] Rhythm never reads other calendar events (BR-022).

### F-015 — Share Achievements
- [ ] An achievement card is generated on the device and shared through the system share sheet.
  Nothing is sent without the user tapping Share (BR-023).
- [ ] Cards show only milestones that never decrease. No reflections, barriers or free text
  appear (BR-023).
- [ ] P0 achievements:
  - **Back at it:** the first check-in after a break.
  - **Bounced back:** 3 returns.
  - **Something new:** the first time doing an activity new to you.
  - **Explorer:** 3 different activities tried.
  - **10, 30 and 100 active days:** lifetime totals, where partly counts and pauses never reset.
  - **Found your rhythm:** the first confirmed observation.

  In P1: **Better together** (first group challenge or event) and **Brought a friend** (an invite
  joins). Nothing is based on streaks, distance, calories or speed.
- [ ] The card shows the achievement name and one line, an activity illustration, an optional
  mini grid (off by default) and the Rhythm mark with a download link or QR code. It never shows
  times, places, notes or reasons for stopping.

### F-016 — Home-screen Widget (P1)
- [ ] Shows today's suggestion (or the planned activity) and a compact grid. Tapping opens Today.
- [ ] While paused, it shows the paused state neutrally. No guilt wording (BR-007, BR-023).

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
| Together days (P1) | The number of days two friends were both active, ever; only goes up (BR-021) |
| Achievement | A milestone that only ever increases (e.g. 30 active days, came back after a break, first time trying an activity); shareable as a card (BR-023) |
| Path | The situation chosen at setup: continue, add a new one, pick up again, or start fresh |

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
- Friends, circles, group challenges, invites and together days in P0: they arrive in P1
  (F-010..F-012). Together (F-018) is the only P0 feature with an account.
- Chat or messaging between users: not planned.
- Wearable or health-platform integration in P0: planned as P1 (F-014).
- iPhone, Apple Watch, iOS widgets and Apple Calendar in P0: planned as P1 (F-017,
  [ADR-008](adr/ADR-008-phone-integrations-and-platform-roadmap.md)).
- Direct Google Calendar sign-in: calendar sync goes through the phone's own calendar instead
  (F-013).
- Monetisation and billing during the challenge: the payer is still a hypothesis ([BRD](brd.md) §5).

## 12. Risks & dependencies
| Risk / dependency | Impact | Mitigation |
|---|---|---|
| Curated activity library: needs authoring, attributes for similarity, and a safety review | P0 blocked without it | ~40 activities across clear categories; a reviewed seed set ([seed](../seed/README.md)) |
| Setup asks more (liked activities, access, free times) and feels long | Drop-off at first run | ≤ 2 minutes; most answers are taps; "not sure yet" allowed |
| Learning shows no visible improvement within a short study | G2 unproven | After every reflection, say what changes; show "how Rhythm adjusted" on My rhythm; report honestly |
| No LLM weakens the AI and technical-depth judging criteria | Lower score | Present the ranking as an explainable personalisation engine; document it in depth ([BRD](brd.md) RK-009) |
| New ideas keep expanding scope (P0 is 10 features including a backend, with no code yet) | Missed submission | Build order: core loop (F-001..F-003, F-006, F-007) → F-018 Together → F-005 → F-004 → F-015 → F-008. Feature freeze 2026-11-13; cut from the end of that list if late |
| Together has no real events on day one (empty network) | The highlight looks empty | Labelled seed clubs and events (DS-006); outreach to 2–3 local clubs; the demo account is pre-joined |
| User-generated events bring safety and moderation duties | Harm, or store rejection | BR-027/028: 18+, public venues, report/block, auto-hide after reports, manual review queue |
| Firestore free-tier limits or rule mistakes | Data exposure or an outage | Security-rule tests in CI; budget alert; no health data on the server (BR-025) |
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
| Q8 | ~~Friend-streak guardrails?~~ Resolved 2026-10-25: no streaks; "together days" instead (ADR-010) | — | — |
| Q9 | Is F-013 (calendar sync) attempted before the 2026-11-13 freeze? Decide by 2026-11-06 | Owner | Nothing in P0 |
| Q10 | ~~One suggestion across activities or one per activity?~~ Resolved 2026-10-25: **one per activity** (F-002) | — | — |
| Q11 | ~~Which achievements exist?~~ Resolved 2026-10-25 with the recommended set in F-015 acceptance; Dzelle may suggest changes | — | — |

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
| F-012 | — (P1) | BR-018, BR-021, BR-024 | — |
| F-013 | UJ-002 (P0 stretch) | BR-015, BR-022 | TC placeholder |
| F-014 | — (P1) | BR-015, BR-018 | — |
| F-015 | UJ-002 | BR-007, BR-015, BR-023, BR-024 | TC placeholder |
| F-016 | UJ-002 | BR-007, BR-023 | TC placeholder |
| F-017 | — (P1) | All P0 rules | — |
| F-018 | UJ-005 | BR-007, BR-015, BR-017, BR-025..BR-029 | TC placeholder |
