# Sitemap — screens, IA, routes, access — Rhythm

> **Purpose:** the static half of the UX map: what screens exist, where they live, who can reach
> them. Movement between screens lives in [User Flow](user-flow.md).
> **Traces back to:** [PRD](prd.md) (`F-###`) · **Status:** Draft v0.1 · **Date:** 2026-10-23

## 1. Navigation model
First run is a short linear wizard (consent → AI choice → My Starting Point). After that, a
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
| S-002 | AI choice | Opt in or out of AI rewording, with plain explanation | F-007 | After S-001 | Consented | idle |
| S-003 | My Starting Point | Choose behaviour, reason, stage, daily goal, constraints, excluded categories | F-001 | After S-002; Settings → Edit starting point | Consented | idle / validation error / red-flag → S-090 |
| S-004 | Today | One hero option with an inline reason; accept, edit, "Something else" (swap through up to 3), "Not today"; time and energy dropdown pills; compact week strip of small rectangles | F-002 | Tab; notification tap | Consented | loading / option / planned / reflected / empty (all excluded or nothing fits) / paused / welcome-back banner / AI-fallback (silent) |
| S-005 | My Way Back | What changed → previous approach or a different one → a smaller first action | F-005 | Auto after lapse (EQ-001); link on Today; post-lapse check-in notification | Consented | idle / no previous approach (starters) / stay paused |
| S-006 | My rhythm | Compact commit grid (small rectangles), active days, returns, reported experiences, plus the What works section (observations as "Does this still fit?" prompts) and the "Returning after a break?" link | F-006, F-004 | Tab | Consented | empty (day 1) / populated / proposed observation / demo-data banner |
| S-007 | What works for me (cut: merged into S-006 on 2026-10-23) | — | F-004 | — | — | — |
| S-008 | Settings & My Data | Notifications, (P1) Sharing row: stop sharing active days, AI toggle, excluded categories, export, delete-all, edit starting point | F-007, F-008 | Header profile icon | Consented | idle / exporting / export done / export error |
| S-009 | Discover | Browse the action library ("For you", filtered by exclusions and preferences) and "Saved" actions; try or save one | F-002, F-004 | Tab | Consented | loading / list / saved empty / all excluded |
| S-010 | Together | Events and clubs near the chosen area, filterable by activity, level and day; RSVP, join, host, report and block. Signed-out people can browse public events and clubs; RSVP, join and host ask them to sign in first (owner decision 2026-10-26). This is the only screen group that needs an account (BR-025) | F-018 | Tab | Tab and public lists are open to everyone; sign-in is needed to RSVP, join or host | signed out (browse; sign-in on RSVP, join or host) / loading / list / empty / error. Segments: Events, Clubs, Mine. Signed-out lists show attendee counts only (BR-029). Detail screens (event, club, host, sign-in, report; P1: challenges, friends, invite, join) get their own S-IDs when TASK-015 starts |
| S-090 | Support message | Fixed, non-AI message pointing to professional or emergency help | BR-003 | Red-flag text anywhere | Any | static |
| S-091 | Something went wrong | Recoverable error with retry; no data loss | — | Unhandled error | Any | static |
| S-101 | Reflection sheet | Completed / partly / skipped + optional enjoyment, effort, barrier | F-003 | Today (after accept); notification | Consented | idle / saved |
| S-102 | Edit option sheet | Adjust duration and time of an option | F-002 | Today → Edit | Consented | idle |
| S-103 | Pause / lighter sheet | Lighter option, reschedule, or pause for a while | F-002, UJ-004 | Today → Pause | Consented | idle |
| S-104 | Delete-all confirm | Irreversible delete confirmation | F-007 | Settings → Delete all | Consented | idle / deleting / done → S-001 |
| S-105 | Observation edit sheet | Confirm, edit, or delete an observation | F-004 | What works → item | Consented | idle |
| S-107 | Why-this sheet | Full explanation of why an option was offered (EQ-004 inputs, AI-worded original text) | F-002, BR-004, BR-019 | Today → "Why this suggestion?" | Consented | idle |
| S-106 | Notification settings sheet | Opt in, pick times, quiet hours | F-008 | Settings; first accepted option (one-time prompt) | Consented | idle / OS permission denied (explain + link to OS settings) |
| S-108 | What-we-store sheet | Full detail of what data is used, where it's kept, what AI wording sends, and the user's controls | F-007, BR-014, BR-016 | S-001 → "See exactly what we store" | Public (no consent yet) | idle |

## 3. Information architecture
```
First run: Welcome & consent (S-001, + What we store S-108) → AI choice (S-002) → My Starting Point (S-003)
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
| `/ai-choice` | S-002 | — | Consented | — | no | |
| `/setup` | S-003 | `?edit=1` | Consented | — | no | |
| `/today` | S-004 | — | Consented | — | no | Default route after setup |
| `/way-back` | S-005 | — | Consented | — | no | |
| `/rhythm` | S-006 | — | Consented | — | no | Replaces `/progress` and `/works` |
| `/discover` | S-009 | `?tab=saved` | Consented | — | no | |
| `/together` | S-010 | — | Consented | — | no | Public lists are open to signed-out users; RSVP, join and host show the sign-in screen first. Sub-routes come with TASK-015 |
| `/settings` | S-008 | — | Consented | — | no | |
| `/support` | S-090 | — | Any | — | no | |

The web build is a private demo: `noindex` for all routes.

## 5. Access boundaries
There are no accounts and no server data in P0, so the only "zone" is consent.

| Zone | Screens | Who gets in | Enforced where | On denial |
|---|---|---|---|---|
| Public | S-001, S-090, S-091 | Anyone | n/a | n/a |
| Consented | All others | Users with a stored, current consent record | go_router redirect plus the data layer refusing writes without consent (no server exists) | Redirect to `/welcome` |
| (P1) Circle member | Circle screens | Signed-in circle members | Firestore security rules (server-side) | Not built in P0 |

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
- Accounts and sign-in (P1 only).
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
