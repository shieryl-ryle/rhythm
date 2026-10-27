# Build scope — which Figma frames are built, when, and as which screen

> **Owns:** the map from every frame on the Figma page `Lilt · Screens` (file `QEdjcVZJUBX6jpRxOVblCa`) to its
> screen ID, route, priority and build tier. Screen IDs, routes and states are owned by
> [Sitemap](sitemap.md); behaviour by [User Flow](user-flow.md); look by [DESIGN.md](DESIGN.md).
> **Traces back to:** the UI reviewer's whole-flow review of 2026-10-27 (gate for TASK-005).
> **Status:** Draft · **Date:** 2026-10-27

## 1. How to read it
- **Tier A** is the core loop and everything a person needs on day one. Build it first.
- **Tier B** is Together stage A: sign-in, profile and area, events and clubs, RSVP, join. It needs the backend
  (TASK-013, TASK-014).
- **Cut candidates** are P0 on paper but the first to go if the feature freeze (2026-11-13) is at risk. The owner
  confirms the cut list on **2026-11-06** (the checkpoint in [Implementation Plan](implementation-plan.md) §2).
- **P1 (design only)** frames are drawn and reviewed but not built for the challenge.
- **Evidence** frames (dark, 200% text, superseded) prove a rule; they are not screens.
- "Not drawn" lists states a builder must still invent, so they are visible before the build.

## 2. Frame map

### 1. First run and setup
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 1.1 Welcome & consent | S-001 | `/welcome` | A (built in TASK-001) |
| 1.2 What we store | S-108 sheet | sheet | A (built in TASK-001) |
| 1.3, 1.4 What brings you here? (one or two ticked) | S-003 step | `/setup` | A |
| 1.5 Keep going · your activity; 1.6 Find your activity; 1.7 how it's going | S-003 steps, S-011 | `/setup`, `/find` | A |
| 1.8 Pick up again · which activity; 1.9 when it stopped; 1.10 what got in the way; 1.11 what would help | S-003 steps | `/setup` | A |
| 1.12 Your week | S-003 step, S-017 | `/setup`, `/settings/free-times` | A |
| 1.13 Why it matters; 1.14 Anything to leave out? | S-003 steps | `/setup` | A |
| 1.15 Setting up | S-003 transition | `/setup` | A |
| 1.16 Today · day 1 | S-004 state | `/today` | A |

### 2. Today
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 2.1 Opening the app · loading; 2.2 grid fills in | S-004 states | `/today` | A |
| 2.3 Today; 2.4 Something else (2 of 3) | S-004 | `/today` | A |
| 2.5 Today's plan; 2.5b under way; 2.5c after the planned time | S-004 states | `/today` | A |
| 2.6 After a check-in (and "Done", "no reason given") | S-004 states | `/today` | A |
| 2.7 Today · activity added | S-004 state | `/today` | A |
| 2.8 Paused; 2.9 After a break | S-004 states | `/today` | A |

### 3. Sheets and secondary screens
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 3.1 Why this suggestion? | S-107 sheet | sheet | A |
| 3.2 Edit | S-102 sheet | sheet | A |
| 3.3 Not today (pause, lighter, later) | S-103 sheet | sheet | A |
| 3.4 Move it to later; 3.5 My plan fell through | S-114, S-115 sheets | sheet | A |
| 3.6 Find an activity | S-011 | `/find` | A |
| 3.7 Plan your own | S-012 | `/plan` | A |
| 3.8 Add | S-109 sheet | sheet | A |
| 3.9 Where are you with it? | S-112 sheet | sheet | A |
| 3.10 Activity detail | S-013 | `/activity/:id` | A |
| 3.11 How did it go? (Done, Partly, Didn't get to it, nothing chosen, details open) | S-101 sheet | sheet | A |
| 3.12 Achievement earned | S-110 sheet | sheet | A |
| 3.13 Share card · Milestone | S-111 sheet | sheet | A |
| 3.13 Share card · Activity, · Rhythm | S-111 sheet | sheet | **Cut candidate** (ship Milestone only) |

### 4. My Way Back
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 4.1 What changed; 4.2 What to try; 4.3 A smaller first step; 4.4 Stay paused | S-005 | `/way-back` | A |

### 5. Discover
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 5.1 For you; 5.2 Saved; 5.3 Loading | S-009 | `/discover` | A |

### 6. My rhythm
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 6.1 My rhythm | S-006 | `/rhythm` | A |
| 6.2 Achievements | S-014 | `/rhythm/achievements` | A |
| 6.3 Edit observation | S-105 sheet | sheet | A |
| 6.4 Your rhythm · full history | S-015 | `/rhythm/history` | A |
| 6.5 Day detail | S-113 sheet | sheet | A |

### 7. Settings and My Data
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 7.1 Settings | S-008 | `/settings` | A |
| 7.2 My activities | S-016 | `/settings/activities` | A |
| 7.3 Gentle reminders | S-106 | `/settings/reminders` | A (after the core loop) |
| 7.4 Exporting; 7.5 Export done | S-008 states | `/settings` | A |
| 7.6 Delete everything?; 7.7 Deleting | S-104 dialog | dialog | A |
| 7.8 When I'm free | S-017 | `/settings/free-times` | A |
| Not drawn: Access and what I leave out | S-018 | `/settings/access` | A (builder derives it from 1.14) |
| Not drawn: Together account (profile edit, sign out, delete account) | S-025 | `/settings/together` | B |

### 8. Notifications
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 8.1 Reminder notification | system notification (EQ-005) | opens `/today` | A (after the core loop) |

### 9. States and errors
| Frames | Owner | Tier |
|---|---|---|
| 9.1, 9.1b Type your activity | S-011 | A |
| 9.2 Support message | S-090 | A |
| 9.3 Today · nothing fits | S-004 state | A |
| 9.4 Way back · starters | S-005 state | A |
| 9.5 Discover · nothing saved; 9.6 all left out | S-009 states | A |
| 9.7 My rhythm · day 1 | S-006 state | A |
| 9.8 Demo data | S-006 / S-008 banner | A (demo builds only) |
| 9.9 Something went wrong | S-091 | A |
| 9.10 Export error; 9.11 Notifications blocked | S-008, S-106 states | A |
| 9.12 Add something new · first question; 9.13 Start fresh · first question | S-003 steps | A |
| 9.14 Search · no matches | S-011 state | A |
| 9.15 Large text (200%) · superseded | evidence | — |

### 11. Together (P0)
| Frames | Screen | Route | Tier |
|---|---|---|---|
| 11.4, 11.4s Together · events (signed in, signed out) | S-010 | `/together` | B |
| 11.8 Together · clubs; 11.9 Together · mine | S-010 segments | `/together` | B |
| 11.5, 11.5s, 11.6 Event detail, signed out, you're going; 10.5 Event cancelled → alternative | S-021 | `/together/event/:id` | B |
| 11.7 Club page | S-022 | `/together/club/:id` | B |
| 11.1 Together · sign in | S-024 | `/together/sign-in` | B |
| 11.2 Your profile | S-019 | `/together/profile` | B |
| 11.3 Your area | S-020 | `/together/area` | B |
| 11.13 Nothing near you | S-010 state | `/together` | B |
| 11.10 Host an event; 11.11 Event posted | S-023 | `/together/host` | **Cut candidate** (hosting is the only user-generated content) |
| 11.12 Report | report sheet (BR-028) | sheet | **Cut candidate** with hosting; a report route is still needed before any store release |

### 10. P1 (design only, not built for the challenge)
| Frames | What |
|---|---|
| 10.1 Challenges, 10.2 Create, 10.3 Invite, 10.4 Join page, 10.6 Event (challenge) | Challenges (F-012) |
| 10.7 Friends, 10.7b a friend isn't sharing, 10.8 Together milestone | Friends and together days (F-010) |
| 10.1a, 10.1b Share your active days; 7.1 Settings (P1) on and off; 7.6b Stop sharing; 11.9 (P1) | Sharing opt-in and controls (ADR-013, ADR-015) |
| 10.9, 10.10 Watch; 10.11 Home-screen widget; 10.12 Calendar sync | F-017, F-016, F-013 |
| 3.13 Together share template | Not drawn yet |

### Evidence frames (not screens)
All frames named "· dark", "· 200% text" or "superseded", the 9:16 share cards (3.13m, 3.13a, 3.13r) and the
annotations. They prove DESIGN.md rules (contrast, text scale, share-card format).

## 3. Proposed cut list (owner to confirm by 2026-11-06)
Per the UI reviewer, in this order if the freeze is at risk:
1. **Together stage B:** host an event, host cancel, the report and block UI. Keep seeded events and clubs,
   sign-in, profile and area, RSVP to Today's plan, and joining a club.
2. **Share templates:** ship Milestone only; drop Activity and Rhythm.
3. **Dark theme implementation:** the palette is signed off in Figma; build it after the freeze if time allows.
4. The PRD's own order for what else goes first: F-015 (share cards), F-008 (notifications), F-004 (What works).

## 4. Recommended build order
1. TASK-001 skeleton (done).
2. In parallel: TASK-004 activity library (the biggest content dependency), TASK-002 data layer, TASK-003
   domain logic.
3. Setup (S-003) and the Today loop (S-004, S-101, S-102, S-103, the plan states), with the grid.
4. Pause and My Way Back (TASK-006).
5. Discover and What works.
6. Settings, export and delete-all (S-008, S-104).
7. Milestone share card, then notifications (S-106).
8. Together stage A (TASK-013, TASK-014, TASK-015).
9. Text-scale and 48 dp checks (TC-044, TC-045), the demo seed and the submission documents.

## 5. Not drawn, so a builder or the owner must decide
Needed before **TASK-015 (Together)**: "Continue with email" (entry, link sent, error); the Together account screen
(S-025: edit profile, sign out, delete account, which BR-017 requires); where a signed-out person picks an area
(11.4s already says "Near Riverside"); loading, error and offline states for the Together lists; host cancel,
leave club and the report confirmation.
Resolved by a builder during the build: the Access settings screen, the 7.2 overflow menu, the notification
permission prompt, links on the remaining achievement tiles, the wording of grid levels.
Decided on 2026-10-27 and written into the owning docs: no AI-choice screen in P0 (S-002 is cut, ADR-006); every
setup question uses Next with no auto-advance; the header avatar is a neutral person icon when signed out; the
time and energy chips open menus and apply to today only (PRD F-002, UF-002, DESIGN.md).
