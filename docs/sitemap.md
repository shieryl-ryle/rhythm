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
not a tab. It opens automatically after a lapse (EQ-001), from "Returning after a break?" on My
rhythm, and from the welcome-back banner on Today, so returning feels like a moment rather than a
place. Small inputs (reflection, edit, pause, why-this) use bottom sheets, which keep the user in
context and keep taps low (BR-006). Same model on Android and web.

## 2. Screen inventory
IDs: `S-001…` main screens · `S-09x` error/blocked states · `S-1xx` dialogs/sheets.

| ID | Screen | Purpose (one line) | Serves | Entry points | Auth | Required states |
|---|---|---|---|---|---|---|
| S-001 | Welcome & consent | Welcome first (what Rhythm does), then one privacy statement and consent. No "Not now": a person who doesn't agree closes the app, and nothing is stored (owner decision 2026-10-24) | F-007 | First launch; consent version changed | Public (no consent yet) | idle |
| S-002 | AI choice (cut: no AI in P0, [ADR-006](adr/ADR-006-no-ai-in-p0.md)) | — | — | — | — | — |
| S-003 | My Starting Point | A short wizard: what brings you here, your activity and where you are with it (or picking up again), your week (free times), why it matters, and what to leave out. The daily goal is fixed at 1 in P0 and has no screen (EQ-002) | F-001 | After S-001; Settings → Edit starting point | Consented | idle / validation error / red-flag → S-090 |
| S-004 | Today | One hero option with an inline reason; accept, edit, "Something else" (swap through up to 3), "Not today"; time and energy dropdown pills; compact week strip of small rectangles | F-002 | Tab; notification tap | Consented | loading / option / planned / reflected / empty (all excluded or nothing fits) / paused / under way (optional, ADR-014) / welcome-back banner / AI-fallback (silent) |
| S-005 | My Way Back | What changed → previous approach or a different one → a smaller first action | F-005 | Auto after lapse (EQ-001); link on Today; post-lapse check-in notification | Consented | idle / no previous approach (starters) / stay paused |
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
| S-020 | Your area | Choose an approximate area (11.3) | F-018, BR-026 | After S-019; the "Near …" label on S-010 | Any | idle |
| S-021 | Event detail | Event info, RSVP, who is going (counts only when signed out, BR-029); cancelled state with an alternative (11.5, 11.6, 10.5) | F-018 | S-010 | Public to view; sign-in to RSVP | idle / going / cancelled |
| S-022 | Club page | Club info, upcoming sessions, join (11.7) | F-018 | S-010 Clubs | Public to view; sign-in to join | idle / joined |
| S-023 | Host an event | Create an event and confirm it was posted (11.10, 11.11) | F-018, BR-027 | S-010 "+ Host an event" | Signed in, 18+ | idle / posted |
| S-024 | Sign-in step | Google or email sign-in, shown on RSVP, join or host (11.1); email entry and link-sent states are not drawn | F-018 | S-021, S-022 | Public | idle / email sent / error |
| S-025 | Together account | Edit profile, sign out, delete the account (no frame; BR-017) | F-018, BR-017 | Settings | Signed in | idle |
| S-090 | Support message | Fixed, non-AI message pointing to professional or emergency help | BR-003 | Red-flag text anywhere | Any | static |
| S-091 | Something went wrong | Recoverable error with retry; no data loss | — | Unhandled error | Any | static |
| S-101 | Reflection sheet | Completed / partly / skipped + optional enjoyment, effort, barrier | F-003 | Today (after accept); notification | Consented | idle / saved |
| S-102 | Edit option sheet | Adjust duration and time of an option | F-002 | Today → Edit | Consented | idle |
| S-103 | Pause / lighter sheet | Lighter option, reschedule, or pause for a while | F-002, UJ-004 | Today → Pause | Consented | idle |
| S-104 | Delete-all confirm | Irreversible delete confirmation | F-007 | Settings → Delete all | Consented | idle / deleting / done → S-001 |
| S-105 | Observation edit sheet | Confirm, edit, or delete an observation | F-004 | What works → item | Consented | idle |
| S-107 | Why-this sheet | Full explanation of why an option was offered (EQ-004 inputs, AI-worded original text) | F-002, BR-004, BR-019 | Today → "Why this suggestion?" | Consented | idle |
| S-106 | Notification settings (screen 7.3) | Opt in, pick times, quiet hours | F-008 | Settings; first accepted option (one-time prompt) | Consented | idle / OS permission denied (explain + link to OS settings) |
| S-108 | What-we-store sheet | Full detail of what data is used, where it's kept, what AI wording sends, and the user's controls | F-007, BR-014, BR-016 | S-001 → "See exactly what we store" | Public (no consent yet) | idle |
| S-109 | Add sheet | Choose find an activity, type your own or plan a one-off (3.8) | F-002 | Today "+ Add" | Consented | idle |
| S-110 | Achievement earned | Celebration sheet with Share (3.12) | F-015 | After a reflection that earns one | Consented | idle |
| S-111 | Share card | Template picker, 4:5 preview, "Share…" to the system sheet (3.13) | F-015 | S-110; S-014 | Consented | idle |
| S-112 | Where are you with it | Stage question for an activity (3.9) | F-001 | S-011 | Consented | idle |
| S-113 | Day detail | One day's status and what counted (6.5) | F-006 | S-015 | Consented | idle |
| S-114 | Move it to later | Pick a later time (3.4) | F-002 | S-103 | Consented | idle |
| S-115 | My plan fell through | Alternative for the same time slot (3.5) | F-002 | S-103 | Consented | idle |

## 3. Information architecture
```
First run: Welcome & consent (S-001, + What we store S-108) → My Starting Point (S-003) → Today (S-004)
Tabs
 ├─ Today (S-004)
 │   ├─ Edit option (S-102) · Not today (S-103) · Reflection (S-101) · Why this (S-107)
 │   └─ My Way Back (S-005)  ← also auto-opens after a lapse
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
| `/settings/reminders` | S-106 | — | Consented | — | no | Frame 7.3 draws it as a screen |
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
- [x] Every P0 `F-###` is served by at least one screen (F-001 S-003 · F-002 S-004/S-009 · F-003 S-101 · F-004 S-006/S-009 · F-018 S-010 · F-005 S-005 · F-006 S-006 · F-007 S-001/S-002/S-008 · F-008 S-106).
- [x] Every screen lists its required states.
- [x] Every non-public zone is enforced (no server data in P0; P1 circles need server rules).
