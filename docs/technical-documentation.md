# Lilt: technical documentation

Future Health Digital Innovation Challenge, Wellbeing track. Draft of 2026-11-16 for early screening; the final version is due 2026-11-20.

Prototype: https://lilt-app-2026.web.app (a web build of the Flutter app). Source: private repository `shieryl-ryle/rhythm`; the reviewers can be given access on request.

## 1. What Lilt is

Lilt helps someone start, keep up, or come back to physical activity when life gets in the way. It offers one idea at a time, always with the reason it was offered, and it never treats a missed day as lost progress. The person's progress only goes up: there are no streaks, and a pause or a quiet week does not reduce anything.

The target person is an adult whose routine was disrupted (a move, a demanding period, new responsibilities) and for whom "start again" feels like one overwhelming task. Lilt answers with a small next step that fits their time, energy, access and preferences.

There is no chatbot and no AI model in this prototype. That was a deliberate choice (§4).

## 2. Try it

Open the prototype and agree to the consent screen. Either answer the starting-point questions, or load an invented person: the avatar at the top right opens Settings, and the "Demo build" section loads one of three invented people with history (every screen then shows "Demo data · invented, not a real person").

| To see | Do this |
|---|---|
| Ranked options with reasons | Today: the first card, then "Something else" |
| Why an idea was offered | "Why this?" under any card |
| Adjusting an idea before planning it | "Edit": choose a length and a time, then "Save changes" |
| Nothing is planned without a tap | Close the Edit sheet, or leave Today: the plan stays empty |
| Coming back after a break | Load the person "Noor" (two weeks of walking, then five quiet days): a welcome-back banner leads to three short steps |
| Browsing the library | Discover: For you, Saved, filter chips, an idea's page with "Follow this activity" |
| Pausing | Today, "Not today", then a pause length: two taps |
| Your data | Settings: "Export my data" and "Delete everything" |

## 3. What is built, and what is not

Built and tested:
- Consent first, then My starting point: what the person already does or used to do, free times, access (gym, pool, courts), what they want to leave out, and what would help.
- Today: up to three options with reasons, time and energy chips, "Something else", "Not today", pause, a plan with Undo, and a reflection ("How did it go?") that says what will change next.
- Edit and "Why this suggestion?" on every option card.
- My rhythm: a calendar grid of active days, totals (active days, returns), a day detail, and observations the person confirms before they affect anything.
- My Way Back: a welcome-back banner after a lapse and three optional steps.
- Discover and an activity page: browse the library with filters, save ideas, follow or stop following an activity.
- Settings: export everything as JSON, delete everything, and the demo people.
- A support message reachable from the start, before consent. It lists no helpline numbers yet (each region's numbers must be sourced and verified first), so it tells the person to call their local emergency number.

Designed but not built for this submission: Together (events, clubs, accounts, a Firebase backend), gentle reminder notifications, adding an activity of your own from Today, search inside Discover, the timeline of how suggestions changed, share cards and achievements, and native Android and iPhone builds. The prototype is the web build only.

## 4. How it works

**Stack.** Flutter 3.41 (Dart 3.11) for web and mobile from one code base; Riverpod for state; go_router for navigation; Drift (SQLite compiled to WebAssembly in the browser) for storage. Hosted on Firebase Hosting. No other backend exists: the prototype makes no network call that carries personal data.

**A rules-based ranking, on purpose.** Every option comes from a library of 48 activities across 15 activity kinds that the team wrote. The ranking is a documented formula (docs/methods.md EQ-003), the same inputs always give the same answer, and each part can be explained in one sentence:

`score = 0.5 × fit + 0.3 × enjoy + help + bonus`

- `fit` rises with how often the person completed that activity (smoothed so one try does not decide everything).
- `enjoy` uses only enjoyment answers the person gave; an unanswered question counts as neutral.
- `help` is a small bonus when what the person said would help (shorter sessions, someone to go with) matches the idea.
- `bonus` is for ideas they saved and for observations they confirmed.

Before scoring, the ranking removes everything the person left out, anything needing access they do not have, and anything longer than the time they chose; "Outdoors after dark" is respected when a time is chosen, including on Edit. One idea is shown per activity.

**Every option names its reason**, from a fixed set of templates tied to those same terms ("You managed this before", "You said this felt good", "You saved this", "A small way to begin", and so on). A reason is shown only when it rests on something the person did or said. "Why this?" lists every reason that applies, strongest first. We chose rules over a language model so that a reason is always true, never invented, and so the behaviour can be tested.

**Lapse and return.** A "reflected day" is a day with at least one completed or partly-done reflection. Three days in a row with none (not counting paused days) is a lapse; the first reflected day after it is a return, recorded once. Totals only ever increase. A missing reflection is stored as "unknown", never as "skipped", and never lowers a suggestion.

**Pause.** Available from Today in two taps. Nothing is planned while paused, and a paused day looks like an empty day, not a miss.

## 5. Data, privacy and safety

- **On the device.** Setup answers, reflections, the grid and observations are stored only on the phone or browser, with no account. Nothing is stored before the person agrees on the consent screen.
- **Export and delete.** Settings can copy every record as JSON, or delete all of them; deleting also clears what is held in memory.
- **No diagnosis or treatment.** The app is framed as wellness, not medical advice. It adds no numeric body targets (weight, calories) and no medication or supplement advice.
- **Red flags.** If free text the person types (a custom activity, a note on an observation) matches a team-written list of 115 phrases (self-harm, disordered eating, medical emergency), the app shows no suggestion for that text and shows a support message instead.
- **Leave-outs are never relaxed.** Anything the person excludes for personal, cultural or religious reasons is never offered, by the ranking, by Discover, by "Plan it", or by Edit.
- **Demo data is synthetic** and generated from a fixed seed; it exists only in the demo build, which can never run on a real person's phone.

## 6. Assumptions

These are assumptions, not findings.
1. The problem is as described by six friends (four students, two working people), one teammate's review and the founder's own experience. This is a convenience sample, not representative, and not validated in Abu Dhabi.
2. Three quiet days is the right point to call a lapse. The scoring weights (0.5, 0.3, 0.1, 0.2), "quick means 20 minutes or less", and the clock times behind the free-time choices (07:00, 12:30, 18:30, Saturday 10:00) are our estimates.
3. Small, reasoned steps help people return more than reminders or streaks do. We have not tested this with users.
4. A person will answer a short reflection after an activity. Without answers the ranking learns nothing, so it falls back to starter ideas.

## 7. Limitations

- **The activity library is a team-written draft.** It has not been reviewed by an exercise or health professional, or for cultural fit. The file says so (`status: draft`, `reviewed_by: null`), and the build has a release gate that fails until a reviewer is recorded. We therefore do not describe the library as reviewed anywhere in the app.
- **No target-user sessions have been completed yet.** The plan is three to five. Until then the prototype demonstrates that the ideas work in software, not that they help people.
- **Small library.** 48 ideas will feel repetitive after a few weeks.
- **The support message has no helpline numbers yet.** It tells the person to call their local emergency number. We will add a number only when we can source and verify it, and the build has a release gate that fails until some are listed.
- **The ranking does not learn across people.** There is no model, so it cannot discover patterns we did not write down. That is the price of being explainable.
- **Web only.** Nothing has been tested on a real phone; accessibility has been tested by automated checks at 100% and 200% text, not by people using assistive technology.
- **Single device.** Data does not sync, and clearing browser data removes it. Export is the only backup.
- **No scale evidence.** The prototype has not been load- or security-tested beyond the review of its rules.

## 8. Quality evidence

- 624 automated tests pass and 2 are skipped by design (the content release gate), the Flutter analyzer reports no issues, and the release web build compiles. Tests cover the ranking, the reasons, lapse and return, pause, delete-all, export, every business rule above, and tap-target and label checks at 100% and 200% text on the main screens.
- Each change was reviewed against the written business rules by a separate review step before merging; the findings and fixes are in the pull request history.
- Not done: integration tests on a device, golden tests of every sheet at 200% text, and a manual Android pass.

## 9. What comes next

1. Have the library reviewed for safety and culture, and replace "team-written" with the reviewer's name.
2. Run three to five sessions with people in the target group and report what we learn, including what does not work.
3. Gentle reminders with the caps already specified (one a day at most, none while paused), then Together with its own consent and privacy rules.
4. Native Android and iPhone builds.
