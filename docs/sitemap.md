# Sitemap — screens, IA, routes, access — Rhythm

> **Purpose:** the static half of the UX map: what screens exist, where they live, who can reach
> them. Movement between screens lives in [User Flow](user-flow.md).
> **Traces back to:** [PRD](prd.md) (`F-###`) · **Status:** Draft v0.1 · **Date:** 2026-10-23

## 1. Navigation model
First run is a short linear wizard (consent → My Starting Point). After that, a
**bottom tab bar** with four tabs, in this order: **Today**, **Discover**, **Together**, **My rhythm** (as in Figma).
The owner cut the bar to three tabs on 2026-10-23 (reference mock-up), then restored the fourth
when community became P0 (F-018, [ADR-009](adr/ADR-009-community-in-p0.md)). Settings & My Data
open from a profile icon in the header. Today shows **one hero suggestion**, with "Something
else" (swap) and "Not today" (lighter / reschedule / pause) as secondary actions. My Way Back is
not a tab. After a lapse (EQ-001) Today offers it with a welcome-back banner that has a "Not now"; it
also opens from "Returning after a break?" on My rhythm and from the post-lapse check-in
notification, so returning feels like a moment rather than a place. Small inputs (reflection, edit, pause, why-this) use bottom sheets, which keep the user in
context and keep taps low (BR-006). Same model on Android and web.

## 2. Screen inventory
IDs: `S-001…` main screens · `S-09x` error/blocked states · `S-1xx` dialogs/sheets.

| ID | Screen | Purpose (one line) | Serves | Entry points | Auth | Required states |
|---|---|---|---|---|---|---|
| S-001 | Welcome & consent | Welcome first (what Rhythm does), then one privacy statement and consent. No "Not now": a person who doesn't agree closes the app, and nothing is stored (owner decision 2026-10-24) | F-007 | First launch; consent version changed | Public (no consent yet) | idle |
| S-002 | AI choice (cut: no AI in P0, [ADR-006](adr/ADR-006-no-ai-in-p0.md)) | — | — | — | — | — |
| S-003 | My Starting Point | A short wizard: what brings you here, your activity and where you are with it (or picking up again), your week (free times), why it matters, and what to leave out. The daily goal is fixed at 1 in P0 and has no screen (EQ-002) | F-001 | After S-001; Settings → Edit starting point | Consented | idle / required answer missing (grey Next with a hint) / saving (frame 1.15, "Finding ideas that fit you…") / save failed ("That didn’t save", nothing stored, Try again) / red-flag → S-090. The progress total follows the paths ticked (4 steps before any is ticked, up to 11). Built 2026-10-28; **edit mode** (`/setup?edit=1`, a "Save" button that updates only preferences) and the **My Way Back hand-off** for a person who ticked "Pick up something I stopped" (PRD UJ-001) are not built yet |
| S-004 | Today | One hero option with an inline reason; accept, edit, "Something else" (swap through up to 3), "Not today"; time and energy dropdown pills; compact week strip of small rectangles | F-002 | Tab; notification tap | Consented | loading / option / planned / reflected / empty (all excluded or nothing fits) / paused / under way (optional, ADR-014) / welcome-back banner |
| S-005 | My Way Back | What changed → previous approach or a different one → a smaller first action | F-005 | Welcome-back banner on Today after a lapse (EQ-001; offered, with "Not now"); link on My rhythm; post-lapse check-in notification | Consented | idle / no previous approach (starters) / stay paused |
| S-006 | My rhythm | Compact commit grid (small rectangles), active days, returns, reported experiences, plus the What works section (observations as "Does this still fit?" prompts) and the "Returning after a break?" link | F-006, F-004 | Tab | Consented | empty (day 1) / populated / proposed observation / demo-data banner |
| S-007 | What works for me (cut: merged into S-006 on 2026-10-23) | — | F-004 | — | — | — |
| S-008 | Settings & My Data | Notifications, (P1) Sharing row: stop sharing active days, excluded categories, export, delete-all, edit starting point | F-007, F-008 | Header profile icon | Consented | idle / exporting / export done / export error |
| S-009 | Discover | Browse the action library ("For you", filtered by exclusions and preferences) and "Saved" actions; try or save one | F-002, F-004 | Tab | Consented | loading / list / saved empty / all excluded |
| S-010 | Together | Events and clubs near the chosen area, filterable by activity, level and day; RSVP, join, host, report and block. Signed-out people can browse public events and clubs; RSVP, join and host ask them to sign in first (owner decision 2026-10-26). This is the only screen group that needs an account (BR-025) | F-018 | Tab | Tab and public lists are open to everyone; sign-in is needed to RSVP, join or host | signed out (browse; sign-in on RSVP, join or host) / loading / list / empty / error. Segments: Events, Clubs, Mine. Signed-out lists show attendee counts only (BR-029). Detail screens (event, club, host, sign-in, report; P1: challenges, friends, invite, join) get their own S-IDs when TASK-015 starts |
| S-011 | Find an activity | Search the library and pick one to follow or plan; type your own when nothing matches (frames 3.6, 9.1, 9.14) | F-002 | Today "+ Add an activity"; Discover search; S-109 | Consented | idle / results / no matches / keyboard open |
| S-012 | Plan your own | Add a one-off activity with a day and time (3.7) | F-002 | Today "+ Plan your own"; S-109 | Consented | idle |
| S-013 | Activity detail | What it is, who it suits, find a session near you (3.10) | F-002, F-018 | Discover card; Today card | Consented | idle / saved |
| S-014 | Achievements | Earned and locked achievements; tapping an earned one opens the share sheet (6.2) | F-015 | My rhythm | Consented | populated / none yet |
| S-015 | Full history | The commit grid over time; tap a day for detail (6.4) | F-006 | My rhythm "See all" | Consented | populated |
| S-016 | My activities | Follow, unfollow and add the activities Lilt suggests from (7.2) | F-002 | Settings | Consented | idle |
| S-017 | When I'm free | Edit the free times Lilt plans around (7.8, 1.12) | F-001, F-002 | Settings; setup | Consented | idle |
| S-018 | Access and what I leave out | Access, limits and excluded categories (no frame yet; builder derives it from 1.14) | F-001 | Settings | Consented | idle |
| S-019 | Your profile | Together profile: display name, optional photo, 18+ confirmation (11.2) | F-018, BR-027 | After S-024; Settings › Together account | Signed in | idle / error |
| S-020 | Your area | Choose an approximate area (11.3) | F-018, BR-026 | After S-019; a tappable "Near …" label on S-010 (proposed, not drawn: the frame shows plain text) | Any | idle |
| S-021 | Event detail | Event info, RSVP, who is going (counts only when signed out, BR-029); cancelled state with an alternative (11.5, 11.6, 10.5) | F-018 | S-010 | Public to view; sign-in to RSVP | idle / going / cancelled |
| S-022 | Club page | Club info, upcoming sessions, join (11.7) | F-018 | S-010 Clubs | Public to view; sign-in to join | idle / joined |
| S-023 | Host an event | Create an event and confirm it was posted (11.10, 11.11) | F-018, BR-027 | S-010 "+ Host an event" | Signed in, 18+ | idle / posted |
| S-024 | Sign-in step | Google or email sign-in, shown on RSVP, join or host (11.1); email entry and link-sent states are not drawn | F-018 | S-021 "I'm going", S-022 Join, S-010 "+ Host an event", the signed-out "Mine" segment | Public | idle / email sent / error |
| S-025 | Together account | Edit profile, sign out, delete the account (no frame; BR-017) | F-018, BR-017 | Settings | Signed in | idle |
| S-090 | Support message | Fixed, non-AI message pointing to professional or emergency help. Three rows (emergency services, a crisis line, your doctor) open the numbers for the person's region **as text**; the app never dials (owner decision 2026-10-28). The numbers are data in `app/assets/support/helplines.json`, which the owner fills and verifies per region (South Africa, MENA and APAC first); until a region is listed the screen says "call your local emergency number" | BR-003 | Red-flag text anywhere | Any | static |
| S-091 | Something went wrong | Recoverable error with retry; no data loss | — | Unhandled error | Any | static |
| S-101 | Reflection sheet | Completed / partly / skipped + optional enjoyment, effort, barrier | F-003 | Today (after accept); notification | Consented | idle / saved |
| S-102 | Edit option sheet | Adjust duration and time of an option | F-002 | Today → Edit | Consented | idle |
| S-103 | Pause / lighter sheet | Lighter option, reschedule, or pause for a while | F-002, UJ-004 | Today → Pause | Consented | idle |
| S-104 | Delete-all confirm | Irreversible delete confirmation | F-007 | Settings → Delete all | Consented | idle / deleting / done → S-001 |
| S-105 | Observation edit sheet | Confirm, edit, or delete an observation | F-004 | What works → item | Consented | idle |
| S-107 | Why-this sheet | Full explanation of why an option was offered (EQ-004 inputs) | F-002, BR-004 | Today → "Why this suggestion?" | Consented | idle |
| S-106 | Notification settings sheet (frame 7.3) | Opt in, pick times, quiet hours | F-008 | Settings; first accepted option (one-time prompt) | Consented | idle / OS permission denied (explain + link to OS settings) |
| S-108 | What-we-store sheet | Full detail of what data is used, where it's kept, and the user's controls | F-007, BR-014 | S-001 → "See exactly what we store" | Public (no consent yet) | idle |
| S-109 | Add sheet | Choose find an activity, type your own or plan a one-off (3.8) | F-002 | Today "+ Add" | Consented | idle |
| S-110 | Achievement earned | Celebration sheet with Share (3.12) | F-015 | After a reflection that earns one | Consented | idle |
| S-111 | Share card | Template picker, 4:5 preview, "Share…" to the system sheet (3.13) | F-015 | S-110; S-014 | Consented | idle |
| S-112 | Where are you with it | Stage question for an activity (3.9) | F-001 | S-011 | Consented | idle |
| S-113 | Day detail | One day's status and what counted (6.5) | F-006 | S-015 | Consented | idle |
| S-114 | Move it to later | Pick a later time (3.4) | F-002 | S-103 | Consented | idle |
| S-115 | My plan fell through | Alternative for the same time slot (3.5) | F-002 | S-103 | Consented | idle |

### S-004 as built (TASK-005 piece b1, 2026-10-28)
Rules decided in the build and the reviews (record: docs/reviews/today-b1-2026-10-28.md): **day one** means no reflected day yet (a completed or partly day), so the week strip and "Your first ideas" stay until the first one; the suggested time is the next free slot **strictly after now**, and a waiting option whose time has passed moves to the next slot (the options and their order do not change); the time and energy chips filter only options suggested for today (EQ-003); a swapped-away activity does not come back as a compact card, and a rebuilt chain never re-offers an action already stepped past, declined or accepted today; "Something lighter" is hidden when the shown option is already that light; **"Not today"** opens S-103 from the hero, a compact card, the planned card and the empty states, and an offer becomes `declined` only when a path in the sheet is taken (a pause), so closing the sheet is no signal and ignoring an option is fine (BR-005, BR-009); "I'll try this" shows "Added to today's plan" with Undo; a pause made with a plan keeps the plan visible; **all done** ("That's all for today", an extra state with no frame yet) shows when every option has been stepped past or declined; at large text the rhythm card moves under the options so the action is on the first screen; a screen reader hears the 12-week grid as one summary, with today named. Nothing here promises reminders yet: "Reminders stop" and "Reminders are off until" describe F-008, which is not built; check them when it is.
Built: the tab shell (Discover, Together and My rhythm say "coming soon"), the rhythm card (12 weeks, or this week on day one), the time and energy chips with their lists, one expanded option with its reason, "I'll try this", "Something else" ("N of M", gone on the last option), compact cards for other followed activities, today's plan, "Still open", the two nothing-fits states, "Not today" with "Something lighter" and the pause (3 days, 1 week, 2 weeks), and Paused with "Resume now". **Not built yet, so not drawn as dead controls:** the ⋮ menu and ⓘ "why this" on cards, "Try something new", "Add an activity", "Move it to later", "My plan fell through", "I'm starting" and its states, and "How did it go?" (the Reflection sheet, next), "See all" on the rhythm card, the "Review my choices" button in state N3 (needs edit mode), and Settings behind the header avatar.

### S-101 and the plan as built (TASK-005 piece c, 2026-10-28)
The planned card for today has "How did it go?" as its one primary and a quiet "Not today". The sheet (frame 3.11) has Done, Partly and Didn't get to it; "What got in the way? (optional)" (tickless chips including "Prefer not to say") appears only after Partly or Didn't get to it (BR-008); "How was it? (optional)" appears after Done or Partly; Save is off until an answer is chosen, so the common case is two taps; closing the sheet leaves the reflection unknown (BR-009). After saving, the card shows its answer ("Partly done", "Not this time"), an affirming line ("Any amount counts." or "Rest counts too.") and "Change my answer", and under it a "What changes next" block with one sentence (EQ-012). The sentence stays on the page and comes from the stored answer, so it survives a restart; it is not a snackbar. Sections run Today, Coming up, From earlier, Still open. At 150% text and above the sheet's title scrolls with the body and only the close button stays pinned; the three-way "How was it?" control stacks whenever a label would not fit on one line (checked at 130% too). An answer can be kept or raised, never lowered (Done stays Done, Partly can become Done, Didn't get to it can become anything), because lowering one would take a day away from active days and the grid (BR-007, EQ-011); the barrier and enjoyment can always be edited, and changing to Done clears the barrier. An unanswered item older than 7 days stops asking and is neither deleted nor counted [assumption]. The plan is read by the day each item is planned for: items for later days show under "Coming up" with no button, and items from an earlier day that were never answered show under "From earlier" with a quieter "How did it go?" and no overdue or missed wording. The first reflected day switches the rhythm card from the week strip to the 12-week grid. Not built: "I'm starting" and its states, "Change" (time or day), and the effort question (retired, EQ-003).

### S-008 as built (first version, 2026-10-30)
The profile button on Today opens `/settings` (a page above the tabs, with Back). Rows: **Need support?** (opens S-090), **Export my data** (every user table as one JSON document, copied to the clipboard: there is no file or share sheet yet; the row has a copy icon, says "Copies everything on this phone as text", then "Exporting…", "Copied. Paste it into a note or a file to keep it." (a tick), or "That didn’t work. Try again."; its line is a live region, so a screen reader announces the change), and **Delete everything**, which opens the destructive dialog (7.6): "Keep my data" is the one filled button, "Delete everything" is outlined in the danger colour, and the body scrolls at large text. It sits in its own group below Export, with no chevron (it opens a dialog, not a screen). Deleting removes every user row, keeps the library, and shows the consent screen (BR-017); if a step fails nothing is removed and the row says so and can be tried again. In a demo build only, a **Demo build** section loads Rana or Sam after a confirmation ("This replaces everything on this phone with invented data"; seed/README.md). If a load fails after it has deleted, the person is sent to the consent screen rather than left on a phone with no consent record (BR-014); while demo rows exist a "Demo data · invented, not a real person" strip shows above the tab bar and at the top of Settings. Not built: reminders (S-106), edit my starting point, My activities (S-016), When I'm free (S-017), and sharing (P1).

### S-006 My rhythm, S-015 Full history, S-105 Observation sheet and S-113 Day detail as built (TASK-006 piece b, 2026-10-31)
**My rhythm** (the fourth tab, `/rhythm`; frames 6.1, 6.3, 6.4, 6.5): the grid for the last 17 weeks with the month names above it, the legend "Done / Partly / Rest or not shared", and the totals line from EQ-011: "Active on 31 days. Came back 2 times after a break." (the second sentence only when there has been a return; both totals only ever go up, BR-007). Under it **What works for me**: a noticed pattern waits in a "We noticed" card with two equal outlined buttons, "Yes, it fits" (confirms it, so suggestions may use it) and "Not really" (deletes it and it is never proposed again); confirmed ones show "Confirmed · used for suggestions" and an Edit link (BR-010). The rules propose at most one new pattern a day and none while one is waiting (EQ-009, `RhythmRepository.proposeIfDue`). **Edit** opens the observation sheet (frame 6.3): the observation as the title, "Does this still fit you?", "It still fits" or "Say it differently" (a text field of at most 140 characters, no suggestions or keyboard learning, BR-015; writing their own words confirms it), Save, and "Remove it". Closing the sheet changes nothing. **See every day** opens `/rhythm/history` (a page above the tabs, with Back): every month as a calendar, newest first, with the same colours as the grid; days after today and days before the first plan are plain numbers. A day opens its **detail** (frame 6.5): the date, how it counted in words ("Done · counts toward your rhythm", "Partly · counts toward your rhythm", "Paused", "Rest or not shared"), and each planned thing with its status and **Edit** or **Add answer**, which reuses the "How did it go?" sheet; an answer can be kept or raised, never lowered (BR-007), and a day never answered stays "Not shared", not skipped (BR-009). A day with nothing planned says "Nothing was planned this day."
Differences from Figma, for the design review: the frame's refinement choices ("Weekday evenings only", "Only in winter") need data the app does not hold, so the sheet offers keep or reword instead; "See every day" is a visible link (the frame has no way in to 6.4); the year chip on 6.4 is left out (every month heading names its year); the day-one state has no frame and uses one plain line.
Not built, and why: the "How Lilt has adjusted to you" timeline (no history of changed suggestions is stored yet, F-004), Achievements and 6.2 (the earning rules belong to F-015), "What you've shared" (open question Q1: list or tags), and the "Returning after a break?" link (My Way Back, S-005, is the next piece).

### S-004 when few or no options fit
Senior UI review of 2026-10-27 (record: [docs/reviews/pre-task-005-build-plan-2026-10-27.md](reviews/pre-task-005-build-plan-2026-10-27.md)). It
extends frame 9.3 "Today · nothing fits" (163:5310); no new frame is needed, and Figma 9.3 is updated after the build.

**Detection (two pure calls).** Run `rankOptions` with the person's chips. If it returns options, show them. If it
returns none, run it again with the time and energy chips removed. Options now: state **N2** (the chips are the
cause). Still none: state **N3** (leave-outs, access or an empty library).

**Rules for all states.** Nothing is auto-planned (BR-005): the relax button only shows options, and the person
still taps "I'll try this". Any option shown gets its normal reason (BR-004). Never relax leave-outs or access
automatically (BR-011); only today's time and energy chips may change. "Not today" stays on screen (BR-006), and
S-103 hides its "Something lighter" row when lighter would be empty. No red, no warning icon, nothing written onto
today's grid tile, no "ran out" wording (BR-007). Hide the chips in N3, because they cannot fix it. The title is
Instrument Serif italic and a live region; at 200% text the buttons stack at full width and the title wraps. Day 1
(frame 1.16) uses the same states with the state title in place of "Your first ideas". The old "Show a lighter
option" button is removed from this state: lighter mode is 10 minutes and low energy, which is what the chips
already say.

| | N2: time or energy is the cause | N3: nothing even without the chips |
|---|---|---|
| Title | Nothing fits those choices | Nothing to suggest right now |
| Body | Change the time or energy. ("or add something of your own" joins when "Add an activity" exists) | Your leave-out and access choices cover everything we have. ("You can change them any time" joins when edit mode exists) |
| Primary (filled) | "Show options up to {n} min" (raise the time first: 20, 30, 45). If energy is the blocker: "Show {medium or high}-energy options". If both: "Show options for any time and energy" | "Review my choices": opens `/setup?edit=1` at the leave-out step (frame 1.14), with "Save" instead of "Show me today" |
| Text button 1 | Add an activity (opens S-109, same label as Today) | Add an activity |
| Text button 2 | Not today (opens S-103) | Not today |

Tapping the N2 primary sets the chip for today only and the person can see and undo it.

**Fewer than 3 options (k of them).** Show the counter "1 of k" only when k is 2 or more. With k = 1 hide the counter
and "Something else". On the last option hide "Something else" instead of cycling back (EQ-010 counts every swap as
not accepted). "Not today" keeps its place so nothing jumps. The hero card cycles the ranker's top options (one per
activity, EQ-003); the compact cards below are the person's other followed activities.

## 3. Information architecture
```
First run: Welcome & consent (S-001, + What we store S-108) → My Starting Point (S-003) → Today (S-004)
Tabs
 ├─ Today (S-004)
 │   ├─ Edit option (S-102) · Not today (S-103) · Reflection (S-101) · Why this (S-107)
 │   └─ My Way Back (S-005)  ← offered by a banner after a lapse
 ├─ Discover (S-009)  — For you · Saved
 ├─ Together (S-010)  — Events · Clubs · Mine
 │   └─ Mine: Going · Hosting · My clubs · (P1) With friends → Challenges · Friends (pushed screens, no tab bar)
 └─ My rhythm (S-006)  — grid · totals · experiences · what works
     ├─ Observation edit (S-105)
     └─ My Way Back (S-005)  ← "Returning after a break?"
Header profile icon → Settings & My Data (S-008)
     ├─ Notification settings (S-106)
     ├─ Edit starting point (S-003)
     └─ Delete all (S-104)
Anywhere: Support message (S-090) · Error (S-091)
```

## 4. Route table
| Route | Screen | Params | Auth | Method(s) | Indexable | Notes |
|---|---|---|---|---|---|---|
| `/welcome` | S-001 | — | Public | — | no | Redirect target when consent is missing or outdated |
| `/setup` | S-003 | `?edit=1` | Consented | — | no | |
| `/today` | S-004 | — | Consented | — | no | Default route after setup |
| `/way-back` | S-005 | — | Consented | — | no | |
| `/rhythm` | S-006 | — | Consented | — | no | Replaces `/progress` and `/works` |
| `/discover` | S-009 | `?tab=saved` | Consented | — | no | |
| `/together` | S-010 | — | Consented | — | no | Public lists are open to signed-out users; RSVP, join and host show the sign-in screen first. Sub-routes come with TASK-015 |
| `/settings` | S-008 | — | Consented | — | no | |
| `/find` | S-011 | `?q=` | Consented | — | no | |
| `/plan` | S-012 | — | Consented | — | no | |
| `/activity/:id` | S-013 | `id` | Consented | — | no | |
| `/rhythm/achievements` | S-014 | — | Consented | — | no | |
| `/rhythm/history` | S-015 | — | Consented | — | no | |
| `/settings/activities` | S-016 | — | Consented | — | no | |
| `/settings/free-times` | S-017 | — | Consented | — | no | |
| `/settings/access` | S-018 | — | Consented | — | no | |
| `/settings/together` | S-025 | — | Signed in | — | no | |
| `/together/profile` | S-019 | — | Signed in | — | no | |
| `/together/area` | S-020 | — | Any | — | no | |
| `/together/event/:id` | S-021 | `id` | Public to view | — | no | |
| `/together/club/:id` | S-022 | `id` | Public to view | — | no | |
| `/together/host` | S-023 | — | Signed in, 18+ | — | no | |
| `/together/sign-in` | S-024 | — | Public | — | no | |
| `/support` | S-090 | — | Any | — | no | |

The web build is a private demo: `noindex` for all routes.

## 5. Access boundaries
Everything except Together works with no account and no server data. Together (F-018) is the one exception: it has an account, and signed-out people can browse public events and clubs (BR-025). The zones are consent and, for RSVP, join, host and the Together account screens, sign-in.

| Zone | Screens | Who gets in | Enforced where | On denial |
|---|---|---|---|---|
| Public | S-001, S-090, S-091 | Anyone | n/a | n/a |
| Consented | All other screens | Users with a stored, current consent record | go_router redirect plus the data layer refusing writes without consent | Redirect to `/welcome` |
| Signed in (Together) | S-019, S-023, S-025, and RSVP, join and host on S-021, S-022 | Signed-in adults (BR-027) | Firestore security rules (server-side) plus the client gate | Show the sign-in step S-024 |
| (P1) Challenge or friend member | Challenges, Friends | Members of that challenge or friendship, after the opt-in | Firestore security rules (server-side) | Not built in P0 |

## 6. Entry points from outside
- **Daily notification tap** → `/today`.
- **Post-lapse weekly check-in tap** → `/way-back`.
- **Web demo URL** → `/welcome` on a fresh browser, or `/today` if already set up.

## 7. Responsive / platform variants
Design width 360–412 dp (phone). The web build is centred at a max width of 480 px on desktop so
it looks like the phone app for judges. Android back and predictive back pop sheets and then
tabs to Today.

## 8. Not in the map
- Circles, group rewards, personal rewards (P1: F-009..F-011).
- Accounts for anything other than Together (none planned).
- Chat screen (non-goal).

## 9. Open questions
| # | Question | Owner |
|---|---|---|
| Q1 | Should My rhythm show "reported experiences" as a list or as tags on the grid? | Design |
| Q2 | ~~Can a signed-out user browse Together?~~ Resolved 2026-10-26: yes, public events and clubs can be browsed; RSVP, join and host show the sign-in screen first | Owner |

## Self-check
- [x] Every P0 `F-###` is served by at least one screen (F-001 S-003 · F-002 S-004/S-009 · F-003 S-101 · F-004 S-006/S-009 · F-018 S-010 · F-005 S-005 · F-006 S-006 · F-007 S-001/S-008 · F-008 S-106).
- [x] Every screen lists its required states.
- [x] Every non-public zone is enforced (no server data in P0; P1 circles need server rules).
