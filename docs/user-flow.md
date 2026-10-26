# User Flow — journeys across the sitemap — Rhythm

> **Purpose:** the dynamic half of the UX map: how people move from arrival to value, what
> branches, and how paths break. Screens are defined in [Sitemap](sitemap.md) and only cited here.
> **Traces back to:** [PRD](prd.md) (`UJ-###`, `F-###`), [Sitemap](sitemap.md)
> **Status:** Draft v0.1 · **Date:** 2026-10-23

## 1. Flow inventory
| ID | Flow | Persona | Starts at | Ends at | Serves | Priority | Frequency |
|---|---|---|---|---|---|---|---|
| UF-001 | First run | All | S-001 | S-004 | F-007, F-001 (UJ-001) | Must-Have | once |
| UF-002 | Daily options | All | S-004 | S-004 | F-002 (UJ-002) | Must-Have | frequent |
| UF-003 | Reflect on an action | All | S-101 | S-004 | F-003, F-006 (UJ-002) | Must-Have | frequent |
| UF-004 | Return after a lapse | Returner (primary) | S-005 | S-004 | F-005, F-006 (UJ-003) | Must-Have | occasional |
| UF-005 | Demanding period: lighter / reschedule / pause | Returner | S-103 | S-004 | F-002, F-008 (UJ-004) | Must-Have | occasional |
| UF-006 | Review what works | All | S-006 | S-006 | F-004 | Must-Have | weekly |
| UF-007 | Set up gentle notifications | All | S-106 | S-008 | F-008 | Must-Have | once |
| UF-008 | Export or delete my data | All | S-008 | S-008 / S-001 | F-007 | Must-Have | rare |
| UF-009 | Check progress | All | S-006 | S-006 | F-006 | Must-Have | weekly |
| UF-010 | Find people to do it with | All | S-010 | S-004 | F-018 (UJ-005) | Must-Have | weekly |
| UF-011 | Create or join a challenge (P1) | All | S-010 (Mine) | S-010 (Mine) | F-012 (UJ-005) | Later (P1) | occasional |

**Coverage:** every P0 F-### appears in at least one flow (F-001 UF-001 · F-002 UF-002/005 · F-003 UF-003 · F-004 UF-006 · F-005 UF-004 · F-006 UF-003/004/009 · F-007 UF-001/008 · F-008 UF-005/007).

## 2. Happy path (primary)
UF-001 → UF-002 → UF-003 → (days pass, a lapse) → UF-004 → UF-002 → UF-009. A Returner sets up
Rhythm, gets options that fit today, reflects, and later lapses. On returning they are welcomed
back without guilt, choose what changed, take a smaller first step, and see the return on their
grid.

## 3. Alternate / secondary flows
- Declines AI on S-002 → every flow uses library text (BR-016).
- Starts at stage "returning" in setup → UF-004 offered straight after UF-001.
- Never answers reflections → the grid shows unknown days neutrally (BR-009).
- Pauses for a week (UF-005) → no lapse is detected during the pause (EQ-001) and notifications
  stop (BR-013).
- Denies the OS notification permission → the app works fully; Settings explains how to enable it.

## 4. Flow detail

### UF-001 — First run
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-001 | Reads and accepts consent | Stores the consent version and time | Proceeds to S-002 |
| 2 | S-002 | Opts in or out of AI | Stores `ai_opt_in` | Proceeds to S-003 |
| 3 | S-003 | Picks behaviour, reason, stage, daily goal, constraints, exclusions | Checks free text for red flags (EQ-008); saves the profile | Proceeds to S-004 |
| 4 | S-004 | Sees the first options | Ranks the library (EQ-003) with reasons (EQ-004) | 1–3 options visible |

**Branch points:** wants detail → S-108 sheet, then back to S-001; doesn't agree → closes the
app, nothing stored (there is no decline screen); red-flag text → S-090, the text is not stored.

### UF-002 — Daily options
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-004 | Optionally sets time and energy | Filters and re-ranks (EQ-003) | Options fit the inputs |
| 2 | S-004 | Accepts / edits (S-102) / replaces / pauses (S-103) | Records the offer status; reworded text has an AI label (BR-019) | The accepted option shows as today's plan |

**Branch points:** nothing fits → empty state with "lighter option" and "adjust exclusions";
AI timeout → library text (BR-020).

### UF-003 — Reflect on an action
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-101 | Marks completed / partly / skipped | Saves the reflection | ≤ 3 taps |
| 2 | S-101 | Optionally picks enjoyment, effort, barrier | Updates the ranking inputs; may propose an observation (EQ-009) | Saved toast |
| 3 | S-004 | Returns to Today | Grid level updated (EQ-002) | Tile brightens |

**Branch points:** dismissed → reflection stays `unknown` (BR-009).

### UF-004 — Return after a lapse
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-005 | Opens the app after a lapse | Detects the lapse (EQ-001); shows "Welcome back" | No loss or guilt wording (BR-007) |
| 2 | S-005 | Optionally picks what changed (or "prefer not to say") | Stores the answer (BR-008) | Can skip |
| 3 | S-005 | Chooses a previous helpful approach or a different one | Offers a smaller first action | One clear option |
| 4 | S-004 | Accepts it | Records the return event once the action is reflected (EQ-011) | Returns count +1 on S-006 |

**Branch points:** no previous approach → library starters; chooses "stay paused" → creates a
pause and goes to S-004 (paused state).

### UF-005 — Demanding period
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-103 | Chooses lighter / reschedule / pause for N days | Lighter: re-rank with low energy and short time. Pause: store the pause and silence notifications (BR-013) | ≤ 2 taps to pause (BR-006) |
| 2 | S-004 | — | Shows the paused state with "Resume anytime" | Neutral copy |

### UF-006 — Review what works
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-006 | Opens My rhythm | Lists confirmed and proposed observations; saved actions live in Discover → Saved (S-009) | Proposed ones ask "Does this still fit?" |
| 2 | S-105 | Confirms, edits, or deletes | Only confirmed observations affect ranking (BR-010) | List updates |

### UF-007 — Gentle notifications
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-106 | Turns on and picks a time | Requests the OS permission; schedules within caps (EQ-005) | Shows the next reminder time |

**Branch points:** OS permission denied → explanation plus a link to OS settings; the toggle stays off.

### UF-008 — Export or delete my data
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-008 | Taps Export | Writes a JSON file of all tables; opens the share sheet (Android) or downloads (web) | File saved |
| 2 | S-104 | Taps Delete all → confirms | Hard-deletes all tables; cancels notifications | Returns to S-001 with no data |

### UF-009 — Check progress
| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-006 | Opens My rhythm | Renders the grid (EQ-002) and totals (EQ-011) | Pause days marked neutrally; totals never decrease |

### UF-010 — Find people to do it with
Detail screens have no S-IDs yet (TASK-015); they are named in brackets.

| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-010 | Opens Together | Lists public events and clubs near the chosen area, signed in or not | Sample items are labelled |
| 2 | S-010 | Filters by activity, level or day; opens an event [event detail] | Shows time, public venue, level, host, who is going and spots left | Everything needed to decide is on one screen |
| 3 | S-010 | Taps "I'm going" | Saves the RSVP; adds the event to Today's plan (F-018) | The event appears on S-004 |

### UF-011 — Create or join a challenge (P1)
Not built for the challenge submission (PRD §11). Shown in the wireframes as "11.9 Together · mine (P1)".

| Step | Screen | User does | System does | Success looks like |
|---|---|---|---|---|
| 1 | S-010 (Mine) | Taps "Challenges" in the "With friends" section | First time only: the "Share active days?" opt-in sheet (BR-018). "Share my active days" opens the Challenges screen [pushed, back returns to Mine]; "Not now" returns to Mine and nothing is sent | 3 taps from the tab bar, 4 the first time |
| 2 | S-010 [create] | Taps "+ Create a challenge"; picks a type, name, goal and who can join | An event type follows BR-027 (public venue, guidelines). First use shows the one-line sharing note (BR-025 P1 clause) | Create and invite is the one primary button |
| 3 | S-010 [invite] | Shares a link, QR code or join code | A private challenge issues a single-use or expiring code (BR-024) | The invite shows only the inviter's name, the challenge name and the people count |
| 4 | [join page] | An invitee opens the link and taps "Get Lilt to join" | Account creation with the 18+ confirmation (BR-027), then joins | Joined challenge appears in the invitee's Mine |

**Not drawn yet:** challenge detail, leave a challenge, join with a typed code, add a friend, an invalid or expired code, and the empty state of the Challenges screen.

## 5. Edge cases and breaks
| ID | Flow | Break | User sees | Recovery | Work lost? |
|---|---|---|---|---|---|
| EV-001 | UF-001 | Red-flag text in the reason | S-090 support message | Can edit the text and continue | No (red-flag text is not stored) |
| EV-002 | UF-002 | AI call fails or times out | Library text, no error | Automatic (BR-020) | No |
| EV-003 | UF-002 | All categories excluded / nothing fits | Empty state with "lighter option" and "adjust exclusions" | Adjust in S-003 | No |
| EV-004 | UF-003 | Reflection dismissed | Nothing | Stays unknown (BR-009) | No |
| EV-005 | UF-004 | No previous helpful approach | Library starters | Choose one | No |
| EV-006 | UF-007 | OS notification permission denied | Explanation and a link to OS settings | User enables it in the OS | No |
| EV-007 | UF-008 | Export fails (storage or browser blocked) | Error with retry (S-091 pattern) | Retry | No |
| EV-008 | UF-002 | Offline | Normal options (library text) | Automatic | No |
| EV-009 | UF-003 | AI-drafted observation fails the safety check | No observation proposed | Automatic (EQ-007) | No |
| EV-010 | All | Device date changes or timezone travel | Days computed in local time | Grid follows local dates | No |
| EV-011 | UF-010 | Not signed in, taps "I'm going", Join or Host | Sign-in screen that explains what is shared and that health data stays local (BR-025) | Sign in and continue, or go back to browsing | No |
| EV-012 | UF-010 | No events nearby | Clubs to join, or host one | Choose either | No |
| EV-013 | UF-010 | The event is cancelled | Neutral notice and an alternative for the same slot (BR-029) | Pick the alternative | No |
| EV-014 | UF-010, UF-011 | Report or block an event, club or profile | Blocked people's events and profiles are never shown to the blocker; content reported by 3 or more people is hidden until reviewed (BR-028) | Continue | No |

## 6. Instrumentation
**No analytics SDKs and no events leave the device** (BR-015). Study metrics ([PRD](prd.md) §10)
are computed on the device from local tables (EQ-010, EQ-011) and shared only when a participant
chooses to export them.

| Event | Fired when | Properties (no personal data) | Used for |
|---|---|---|---|
| Local record: `option_offer` status | Option offered / accepted / edited / replaced | action_id, status, ai_reworded | EQ-010 acceptance rate |
| Local record: `reflection` | Reflection saved | status, enjoyment, effort, barrier code | EQ-002, EQ-003, EQ-009 |
| Local record: `return_event` | First reflected action after a lapse | dates, what-changed codes | EQ-011 returns; PRD return-after-lapse metric |

## 7. Open questions
| # | Question | Owner |
|---|---|---|
| Q1 | Should a one-time notification prompt appear after the first accepted option, or only in Settings? | Owner |

## Self-check
- [x] Every flow starts and ends on a screen in the Sitemap.
- [x] Every Must-Have flow has at least one edge case listed.
- [x] No instrumentation event carries personal data.
