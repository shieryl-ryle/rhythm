---
version: alpha
name: Lilt
description: >-
  A calm, warm, unhurried wellness companion on a phone (design width 360–412 dp; the web build is
  centred at 480 px max). It feels like a supportive friend who never keeps score against you.
colors:
  primary: "#2F3BFF"
  on-primary: "#FFFFFF"
  canvas: "#F3F4F2"
  surface: "#FFFFFF"
  selected: "#E5E7EF"
  ink: "#111418"
  ink-muted: "#5A6168"
  line: "#E1E3E0"
  field: "#868C92"
  sheet-line: "#E1E3E0"
  accent: "#B84A00"
  danger: "#C62828"
  grid-0: "#E5E7EF"
  grid-1: "#B5BCFF"
  grid-2: "#6C78FF"
  grid-3: "#2F3BFF"
  grid-pause: "#E5E7EF"
  eq-peak: "#2F3BFF"
  eq-dip: "#6C78FF"
  eq-comeback: "#FF7A1A"
  art-peak: "#2F3BFF"
  art-level: "#5F6BFF"
  art-comeback: "#D55900"
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  xxl: 32px
  section: 40px
  xxxl: 48px
rounded:
  tile: 1.5px
  sm: 8px
  md: 12px
  thumb: 16px
  card: 20px
  sheet: 28px
  pill: 9999px
typography:
  display:
    fontFamily: Instrument Serif
    fontStyle: italic
    fontSize: 2.125rem
    fontWeight: 400
    lineHeight: 1.18
  celebration:
    fontFamily: Unbounded
    fontSize: 1.25rem
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: Geist
    fontSize: 1rem
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: Geist
    fontSize: 0.875rem
    fontWeight: 500
    lineHeight: 1.43
---

# Design — Lilt

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
| `primary` | Brand cobalt: selected states, links, focus ring, saved items, grid level 3 | Warnings |
| `on-primary` | Text and icons on `primary` and on filled `ink` buttons | — |
| `canvas` | App background | — |
| `surface` | Cards, sheets, dialogs | — |
| `selected` | Fill of a selected row, chip or tab | — |
| `ink` | Body text, titles, filled buttons | — |
| `ink-muted` | Reasons, helper text, timestamps | Primary actions |
| `line` | Dividers, card borders, pause pattern stroke | Text |
| `field` | Field and chip borders (3:1 against `canvas`) | Dividers |
| `accent` | "Welcome back" moments, returns count (text #B84A00; decorative marks may use #FF7A1A) | Errors, missed days |
| `danger` | Delete-all only (the one irreversible action) | **Missed, skipped, or lapsed days, ever** |
| `grid-0`..`grid-3` | Commit grid levels (EQ-002) | Anything else |
| `grid-pause` | Pause-day tile: drawn exactly like `grid-0`, a filled neutral square ([ADR-012](adr/ADR-012-pause-days-look-like-empty-days.md)) | Outlines, dashes or hatches |

Contrast: `ink` and `ink-muted` on `surface`, and `on-primary` on `primary`, are intended to meet
WCAG AA (verify, D2). Grid tiles are always filled rounded squares, never outlines, with one exception: today's tile
has a 2 px focus ring. Future days are not drawn in the 12-week grid; on week strips and the
widget they are filled `grid-0`; in the month calendar they have no fill. The legend reads
"Done · Partly · Rest or not shared" (a paused day is drawn as level 0, ADR-012). Levels also
differ by semantics labels ("Oct 21: goal met", "Oct 21: paused"), not colour alone.

**Activity art** (the 56 dp thumbnails) uses `art-peak`, `art-level` and `art-comeback`, which are
held to 3:1 against their tile. Light mode: cobalt #2F3BFF, cobalt #5F6BFF, orange #D55900. Dark
mode: #6E7BFF, #8E98FF, #FF7A1A. The wordmark and equalizer bars (`eq-peak`, `eq-dip`,
`eq-comeback`, orange #FF7A1A) are decorative brand marks and are not held to 3:1. Activity art
is decorative too: the activity name is always in text beside it.

## Typography
`display` (Instrument Serif italic) for screen titles and the "Welcome back" heading only.
`celebration` (Unbounded) for milestone and achievement titles and big numbers. `body` (Geist) for
options, reasons, and reflections. `label` (Geist) for chips, tabs, and the grid legend. Max line
length about 60 characters. Dark-mode colour values live in the Figma Color collection (Dark mode).
Respect the system text scale up to 200% without clipping.

## Layout
Spacing scale 4 / 8 / 12 / 16 / 24 / 32. 16 dp page padding. One primary action per screen. Option
cards stack vertically (up to 4; five or more long options become list rows). The grid shows 7 rows (days of the week) × N weeks, scrollable
horizontally, with the newest week at the right.

## Elevation & Depth
Flat: cards use a 1 dp `line` border, no shadows. Bottom sheets use one soft shadow.

## Shapes
Cards 20 dp radius (`card`); activity-art tiles 16 dp (`thumb`); two-line action rows (the Support message options) 12 dp
(`md`); buttons and chips fully rounded (pill). Grid tiles are **small rectangles,
not squares**, at GitHub contribution-graph scale (compact, not a hero element). Exact size and
gap are set in the wireframe (owner direction, 2026-10-23).

## Components
| Component | Variants | States | Notes |
|---|---|---|---|
| Button | primary / secondary / text | default / pressed / disabled / loading | Min height 48 dp. Delete-all is a secondary button with `danger` text and border, never filled. The design system also has a filled danger variant; it is not used |
| Option card | library (AI-worded is dormant, ADR-006) | default / accepted / edited | Shows reason (BR-004) in `ink-muted` |
| Quick chip | single / multi select | default / selected | Used for time, energy, reflection, barrier. Multi-select shows a ✓; single-select does not |
| Segmented control | 2 or 3 segments | one selected | Single choice with short labels. 48 dp tall, tinted track, white outlined selected segment. Not for navigation tabs |
| Tabs | 2 or 3 tabs | one selected | Navigation between sections (For you / Saved, Events / Clubs / Mine). Surface track with a hairline border; the selected tab has a tinted fill and a semibold label, the others a regular secondary label |
| Achievement badge | earned / locked | — | 56 dp tile (`thumb` radius). Earned: the equalizer in brand colours on `selected`. Locked: a canvas tile with a solid hairline and `grid-0` bars. "Earned ·" / "Not yet ·" text always accompanies it |
| Commit grid tile | level 0–3 / pause / today | default / focused | Semantics label e.g. "Oct 20: goal met" / "Oct 21: paused" |
| Bottom sheet | reflection / edit / pause / observation / notifications | — | Pause reachable in ≤ 2 taps (BR-006) |
| Activity art | Running / Walking / Pickleball / Bouldering / Gym / Swimming / Cycling / Yoga / Social / Other | — | 56 dp tile, scales with its slot (event and club detail use 56 dp). Social sits on the warm tint. Decorative |
| Avatar | tone: blue / warm / neutral | — | Initials circle from 32 dp up (first letter for a person, two for a club); below that, a solid dot (blue `eq-dip`, warm `eq-comeback`, neutral `field`) so three people read as three. The profile button is the blue avatar. Stacks overlap with a 2 dp ring. No dots when there are no attendees. A person keeps one tone everywhere |
| Share card | Milestone / Activity / Rhythm (P1: Together); light / dark | 9:16 image (1080 × 1920) with all content inside a centred 4:5 safe area (1080 × 1350). Content centred, footer row with the wordmark and a QR-style code (store page only). Sheet: title "Share this", segmented control, 4:5 preview, primary "Share…". The grid appears only on the Rhythm template (no toggle). On Milestone the number is the hero (96 px) with "active days" below, so 10, 30 and 100 break the same way | Follows the app theme and meets 4.5:1. All-time totals only. At 200% the segments stack, the body scrolls and "Share…" stays pinned |
| Plan card | planned / under way | Under the heading "Today"; a Together RSVP sits under "Coming up" with status "You're going" and "Can't make it? Cancel". Planned: status "Planned", the time, filled "I'm starting", text "Change". Under way: status "Under way", "Started 12:31 · 20 min planned" (a fixed time the person marked, never a ticking timer), filled "I'm finished", text "Not started yet" | Optional state (ADR-014). Nothing is recorded. Never "overdue" or "missed". After the planned window with no start, the primary reads "How did it go?" |
| Support message | — | static | No AI; calm tone; buttons to call help, not dismissive (BR-003). "Call emergency services" is the screen's one filled primary; the other options are outlined buttons with a phone icon |
| Welcome-back banner | — | — | `accent`; never shows the length of the lapse |

## Wording list (BR-007)
**Never use** (UI, notifications, AI output; checked by TC-015 and EQ-007): "broke", "broken",
"lost your streak", "streak lost", "failed", "failure", "missed", "behind", "lazy", "you should",
"don't give up", "no excuses", "cheat day", "guilt".
**Prefer:** "Welcome back", "Paused, resume anytime", "Rest counts too", "Any amount counts",
"Want something lighter today?", "What would make this easier?", "What got in the way?".

## Do's and Don'ts
- **Do:** celebrate returns as much as completions; show why each option was offered; keep pause
  one step away.
- **Do:** label synthetic demo data visibly (AI-worded text is dormant in P0, ADR-006).
- **Don't:** use red, warning icons, or empty grey to mean a missed day; show "days since" counts;
  compare users; use confetti for streak lengths.

## Interaction and accessibility rules (UI review, 2026-10-25)
These come from the senior UI/UX review of Wireframes v4, accepted by the owner and applied in
Wireframes v5.
- **Touch targets:** at least 48 dp for every button, link, icon button and chip hit area, with
  at least 8 dp between them. Calendar day cells are 44 dp or larger. The one exception is a
  full-width list row (for example Report options): rows touch, each is a 48 dp target, and a
  1 dp divider separates them.
- **Sizes:** all buttons 48 dp tall. Chips are one height (32 dp visual) whether selected or not, with a 48 dp hit area:
  wrapped chip rows are 56 dp apart (a 24 dp visible gap) so neighbouring hit areas stay 8 dp
  apart, and a chip is never narrower than 48 dp.
  The profile button is a 40 dp circle.
- **Text:** 12 sp minimum, and nothing lighter than #6B6B6B on white. Muted text never sits on a
  grey box, except the unselected labels of a segmented control (`ink-muted` on the `selected`
  tint, about 5:1).
- **Fields:** the border is at least 3:1 against the background, with a 2 px focus state. Typed
  text is ink and hints are muted. Labels sit above fields.
- **Search:** a 56 dp rounded search bar with a magnifier and a clear (×) button. While typing it
  shows a 48 dp back arrow in place of the magnifier, so there is always a way out. It opens full
  screen while typing so the keyboard doesn't hide results, and has a "no matches" state.
- **Selection:**
  - **Single choice:** a segmented control for 2 or 3 short options (labels that fit on one line
    in a third of the width); cards for 4 or fewer longer options; 48 dp list rows with dividers
    for 5 or more long options (for example Report); chips for many short options, selected
    with a tint and border but **no ✓**.
  - **Multiple choice:** chips show a ✓, and checkboxes show a tick. A ✓ always means "you can
    pick more than one".
  - **Reflection barrier** ("What got in the way? (optional)") is single choice with tickless
    chips, and "Prefer not to say" is one of the options. It appears only after "Partly" or
    "Didn't get to it": asking after "Done" would presume difficulty (BR-008).
  - **A sheet whose content depends on a choice** (the reflection sheet) grows upward from the
    bottom edge and keeps its primary button in the same place in every state.
  - **Pickers are actions, not options.** "Pick a time ›" or "Pick a date ›" opens a picker, so
    it is a text button beside or below the choice, never a segment, card or chip in the group.
  - **Spacing:** on a screen, at least 40 dp above the heading of each chip, segmented or card
    group; in a height-capped sheet, at least 24 dp. At least 16 dp between the last chip row
    and a primary button (chip hit areas reach 8 dp below the chips).
  - Every setup question uses a Next button (no auto-advance).
- **Setup steps:** the primary button is always at the same place at the bottom (y736–784 on an
  800 dp screen). When an answer is required, Next is the grey disabled button with a hint above
  it ("Pick at least one to continue."). An exclusive choice that is unavailable keeps its text
  readable (`ink-muted`) but loses its fill. Progress bars fill with `primary` and are named
  "step N of M" for screen readers.
- **One primary per screen.** Today has one expanded suggestion card with the only filled button.
  Other followed activities are compact cards.
- **Sheets:** the screen behind stays visible under a 32% black scrim, and every sheet has a 48 dp
  close (×) as well as swipe (WCAG 2.5.7). Top radius 28 dp. A 1 px `sheet-line` stroke on the top
  and side edges keeps the sheet visible over the scrim in both modes.
  - **Position:** a sheet sits on the bottom edge (top = screen height − sheet height) with
    28 dp under the last button, which covers the system gesture inset on gesture navigation.
    Nothing is ever clipped
    by the screen edge.
  - **Height:** at most 90% of the screen, so the screen behind stays visible. A sheet that fits
    does not scroll.
  - **When content is taller (200% text, short phones):** the close (×) stays pinned, the body
    scrolls, and a 1 dp divider sits above a sticky footer that holds the primary button. Only
    a button that is the one primary of the sheet is sticky.
  - **A menu sheet may have no filled primary.** Not today is a list of paths, so it has none.
    Its pause block (a segmented length control with "1 week" preselected and an outlined
    "Pause for 1 week" button) always stays visible and inline, never sticky and never filled,
    so pausing is two taps from Today (BR-006) without being the heaviest thing on the sheet.
    Do not hide the button until a length is chosen: that makes it three taps. The
    confirmation is the Paused screen, which has "Resume now" as the undo.
  - **Keyboard:** when a field is focused, the sticky footer sits above the keyboard.
  - **Specs show the stress case:** a static frame never silently clips. Large-text frames name
    their layers `scroll-body` and `sticky-footer`, show a row cut at the fold with a fade, and
    carry a short annotation.
- **Feedback patterns:**
  - Snackbars for quick confirmations (with Undo or Open). They float, 16 dp from each side,
    16 dp above the navigation bar (or 16 dp from the bottom when there is none), and never
    cover a destructive row or the screen's primary action. A snackbar goes after 6 seconds, stays while a
    screen reader is on (WCAG 2.2.1), and is cleared when the person changes tab or opens Settings, the support
    message or a sheet. Edit (S-102) adjusts an option before it is planned, so once something is planned Undo on its snackbar is the only way to take it back; Undo after "Save changes" removes the edit with it.
  - Banners with an action inside for persistent states.
  - Inline progress for running tasks.
  - Explanations ("What changes next", "Why we suggest it") use a left rule, not a grey box.
- **Destructive actions** use a dialog. The safe choice is the default, and the destructive
  button uses the `danger` token. For delete-all that means an outlined button with `danger` text
  and border, so "Keep my data" stays the only filled button. Stop sharing (P1) is reversible (the person can opt in again), so it uses a neutral outlined button, not `danger`, with "Keep sharing" as the filled default. Dialog bodies scroll at 200% text and the buttons stay pinned.
- **Header avatar:** the round button at the top right of the main screens opens Settings (S-008). Signed in to Together it shows the initial of the display name; signed out it shows a neutral person icon, never a made-up initial. It is a 48 dp target with the label "Settings".
- **Navigation bar:** 80 dp with an active pill behind the icon and 12 sp labels. Labels scale
  with system text up to 16 sp (1.33x), then stop: they never wrap, break mid-word or ellipsise.
  The icon, the active pill and the accessible name carry the destination at larger sizes. This is
  the one documented exception to 200% text.
- **Large text:** at 200% text size, side-by-side buttons stack, segmented controls stack into
  one option per row, a picker button that sits beside a control drops below it, and
  label/value pairs stack label above value.
- **Share** through the system share sheet, never with app buttons drawn by us.
- **Links vs buttons:**
  - In-app actions ("Something else", "Not today", "Edit", "Skip", "See all") are **text buttons**:
    semibold, no underline, 48 dp tall. A standalone, left-aligned text button sits flush with the
    content edge (its label on the margin) and keeps its 48 dp hit area.
  - Underlines are reserved for real links that open something outside the current flow, such as
    a web page.
- **Filter chips** (e.g. Discover) are **multi-select** with a ✓. Selecting none means "All".
- **Menu chips** (a pill that opens a list, e.g. the Together filters) use a short label with a
  trailing chevron icon (the Chip's Menu property) and show the chosen value; they have no ✓. A filter row sits at least 8 dp below the tabs
  above it, counting the chips' 48 dp hit area.
- **Build checks:** 200% text (TC-044) and 48 dp tap areas, including on visually 32 dp chips
  (TC-045).

## Brand motion: the equalizer (2026-10-25)
Source of truth: Figma file `QEdjcVZJUBX6jpRxOVblCa`, page "Brand · Lilt" ("Lilt — brand board",
components "Wordmark / lilt" and "Logo mark / lilt", and the prototype flows "Lilt · app opening"
and "Lilt · reveal (video)"). Design system pages: "Lilt DS · Components" and "Lilt DS ·
Foundations". Name decision: [ADR-011](adr/ADR-011-product-name-lilt.md). The tokens above are
the Lilt brand tokens, synced from Figma on 2026-10-26 (the earlier teal / Fraunces / Inter
tokens are gone).
- **One object.** The logo mark, app icon, wordmark ("lilt": l · i · l are the bars), Today
  header, achievements and the demo video all use the same three bars, in this order: `peak`
  (cobalt #2F3BFF, the first l), `dip` (light cobalt #6C78FF, the i), `comeback` (orange
  #FF7A1A, the second l). Keep these names on the layers and in the code so shared-element
  transitions connect.
- **Fixed ratios:** heights 1 : 0.75 : 0.87 (the l is the font's own l height, the i stem is the
  x-height); gap = half a bar width; bars sit on one baseline. The logo mark uses the same ratio
  (bars 44 / 33 / 38 in a 72 viewBox). The i keeps its dot; the t is tilted 12° onto its toe.
- **Opening sequence:** icon → icon fills the screen → brand colours → bars become l · i · l →
  the i squeezes out its dot in light cobalt → the dot pops up and settles → ink spreads through
  it from the centre → the t drops from the sky, squashes, springs upright and tilts onto its
  toe → one out-of-sync beat → the wordmark shrinks into the Today header. The standalone
  "Lilt · reveal (video)" flow (bars rising one by one from below) is for the demo video.
- **Beat:** bars never move in unison; each beat pose changes each bar by a different amount and
  direction. The dot always rides on top of the i bar.
- **Tempos:** spring only when bars rise or celebrate; a gentle ease for moves. With reduced
  motion, cross-fade only.
- **Flutter:** one `EqualizerBars` widget driven by an animated layout value, with `Hero` tags
  `eq-peak`, `eq-dip`, `eq-comeback`. The wordmark is an exported SVG from Figma; it's never
  rebuilt from text plus CSS.

## Open decisions
| # | Decision | Owner |
|---|---|---|
| D1 | Bundle fonts vs. `google_fonts` package (offline-first favours bundling) | Team |
| D2 | Verify contrast of all text tokens with a contrast checker and adjust. Computed in [contrast.md](contrast.md) (2026-10-26): every text, control, border and art pair meets its minimum in both modes (three failures found in the first pass were fixed the same day; `border/field` on a raised surface in Dark sits exactly at 3.0) | Design |
| D3 | Dark mode palette: values exist in the Figma Color collection (Dark mode). **Resolved 2026-10-26** (UI reviewer verified): palette accepted. Done: unselected tab labels bound to `ink-muted` (95 hard-coded greys fixed), 1 px `sheet-line` edge on sheets, ten dark evidence frames (7.6, 2.7, 2.9, 8.1, 10.11, 11.12, 9.8, 2.1, 5.1 with tabs, 3.3 with a segmented control), full contrast table with the three failures fixed. Not claimed: every one of the 99 screens has been looked at in dark (10 have) | Design (P1) |
