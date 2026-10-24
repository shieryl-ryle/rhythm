---
version: alpha
name: Rhythm
description: >-
  A calm, warm, unhurried wellness companion on a phone (design width 360–412 dp; the web build is
  centred at 480 px max). It feels like a supportive friend who never keeps score against you.
colors:
  primary: "#2F7D6D"
  on-primary: "#FFFFFF"
  surface: "#FBF8F3"
  ink: "#1F2A2E"
  ink-muted: "#5B6770"
  line: "#E3DED6"
  accent: "#D98F2B"
  danger: "#B3261E"
  success: "#3C8D5A"
  grid-0: "#ECE7DF"
  grid-1: "#CDE5DE"
  grid-2: "#8CC4B5"
  grid-3: "#2F7D6D"
  grid-pause: "#E3DED6"
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  xxl: 32px
rounded:
  tile: 3px
  card: 16px
  pill: 9999px
typography:
  display:
    fontFamily: Fraunces
    fontSize: 1.75rem
    fontWeight: 600
    lineHeight: 1.2
  body:
    fontFamily: Inter
    fontSize: 1rem
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: Inter
    fontSize: 0.875rem
    fontWeight: 500
    lineHeight: 1.4
---

# Design — Rhythm

> Owns: visual tokens and component rules for the UI. Agents building screens read this before
> writing styles. Token names above are the source of truth: code uses the names, not raw hex.
> Contrast values are estimates until checked with a contrast tool (D2).

## Overview
**Calm, warm, unhurried, honest.** It borrows from a paper journal and GitHub's contribution
graph. The one thing the design must make obvious: **any amount counts, and coming back is
progress.** Nothing on screen should feel like a debt.

## Colors
| Token | Use for | Never use for |
|---|---|---|
| `primary` | Main actions (Accept), selected tab, grid level 3 | Warnings |
| `on-primary` | Text and icons on `primary` | — |
| `surface` | App background, sheets | — |
| `ink` | Body text, titles | — |
| `ink-muted` | Reasons, helper text, timestamps | Primary actions |
| `line` | Dividers, card borders, pause pattern stroke | Text |
| `accent` | "Welcome back" moments, returns count, saved items | Errors, missed days |
| `danger` | Delete-all only (destructive) | **Missed, skipped, or lapsed days, ever** |
| `success` | Saved / done toasts | Comparing users |
| `grid-0`..`grid-3` | Commit grid levels (EQ-002) | Anything else |
| `grid-pause` | Pause-day tile, drawn with a diagonal hatch in `line` | Empty days |

Contrast: `ink` and `ink-muted` on `surface`, and `on-primary` on `primary`, are intended to meet
WCAG AA (verify, D2). Grid tiles also differ by the hatch pattern and by semantics labels, not
colour alone.

## Typography
`display` for screen titles and the "Welcome back" heading only. `body` for options, reasons, and
reflections. `label` for chips, tabs, and the grid legend. Max line length about 60 characters.
Respect the system text scale up to 200% without clipping.

## Layout
Spacing scale 4 / 8 / 12 / 16 / 24 / 32. 16 dp page padding. One primary action per screen. Option
cards stack vertically, max 3. The grid shows 7 rows (days of the week) × N weeks, scrollable
horizontally, with the newest week at the right.

## Elevation & Depth
Flat: cards use a 1 dp `line` border, no shadows. Bottom sheets use one soft shadow.

## Shapes
Cards 16 dp radius; buttons and chips fully rounded (pill). Grid tiles are **small rectangles,
not squares**, at GitHub contribution-graph scale (compact, not a hero element). Exact size and
gap are set in the wireframe (owner direction, 2026-10-23).

## Components
| Component | Variants | States | Notes |
|---|---|---|---|
| Button | primary / secondary / text / danger (delete-all only) | default / pressed / disabled / loading | Min height 48 dp |
| Option card | library / AI-worded | default / accepted / edited | Shows reason (BR-004) in `ink-muted`; AI-worded label chip (BR-019) |
| Quick chip | single / multi select | default / selected | Used for time, energy, reflection, barrier |
| Commit grid tile | level 0–3 / pause / today | default / focused | Semantics label e.g. "Oct 20: goal met" / "Oct 21: paused" |
| Bottom sheet | reflection / edit / pause / observation / notifications | — | Pause reachable in ≤ 2 taps (BR-006) |
| Support message | — | static | No AI; calm tone; buttons to call help, not dismissive (BR-003) |
| Welcome-back banner | — | — | `accent`; never shows the length of the lapse |

## Wording list (BR-007)
**Never use** (UI, notifications, AI output; checked by TC-015 and EQ-007): "broke", "broken",
"lost your streak", "streak lost", "failed", "failure", "missed", "behind", "lazy", "you should",
"don't give up", "no excuses", "cheat day", "guilt".
**Prefer:** "Welcome back", "Paused, resume anytime", "Rest counts too", "Any amount counts",
"Want something lighter today?", "What would make this easier?".

## Do's and Don'ts
- **Do:** celebrate returns as much as completions; show why each option was offered; keep pause
  one step away.
- **Do:** label AI-worded text and synthetic demo data visibly.
- **Don't:** use red, warning icons, or empty grey to mean a missed day; show "days since" counts;
  compare users; use confetti for streak lengths.

## Open decisions
| # | Decision | Owner |
|---|---|---|
| D1 | Bundle fonts vs. `google_fonts` package (offline-first favours bundling) | Team |
| D2 | Verify contrast of all text tokens with a contrast checker and adjust | Design |
| D3 | Dark mode palette | Design (P1) |
