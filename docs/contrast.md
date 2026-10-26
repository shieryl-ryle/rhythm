# Contrast table (D2)

Computed on 2026-10-26 from the Figma Color collection (Light and Dark modes) with the WCAG 2.x relative-luminance
formula. Ratios are rounded to two decimals. **Minimum:** 4.5:1 for text, 3:1 for the border of a control or an
icon or mark that carries meaning. Decorative dividers and the grid ramp have no minimum (their meaning is also
carried by labels and text, see DESIGN.md).

Token names below are the Figma names (`color/…`). DESIGN.md names the same colours by role:

| DESIGN.md | Figma |
|---|---|
| `primary` | `action/accent`, `text/accent`, `border/focus` |
| `on-primary` | `text/on-accent`, `text/on-inverse` |
| `canvas` / `surface` | `bg/canvas` / `bg/surface` (and `bg/raised`) |
| `selected` | `action/selected` |
| `ink` / `ink-muted` | `text/primary` / `text/secondary` |
| `line` / `field` / `sheet-line` | `border/default` / `border/field` / `border/sheet` |
| `accent` | `text/comeback` (decorative marks: `eq/comeback`) |
| `danger` | `text/danger`, `action/danger` |
| `grid-0`…`grid-3`, `grid-pause` | `grid/0`…`grid/3`, `grid/pause` |

## Result

**Every text, control, border and art pair meets its minimum in both modes.** One pair sits exactly on the line
(`border/field` on `bg/raised` in Dark, 3.00).

The first pass of this table found three failures. They were fixed the same day by pointing the tokens at new
primitives (existing primitives were left alone because other tokens use them):

| Token | Mode | Before | After | Ratio before → after |
|---|---|---|---|---|
| `border/field` | Light | `slate/500` #8A9096 | `slate/450` #868C92 | 2.92 → 3.08 on `bg/canvas` |
| `border/field` | Dark | `slate/600` #5A6168 | `slate/550` #646C74 | 2.84 → 3.34 on `bg/surface` |
| `text/on-accent` | Dark | `white` #FFFFFF | `graphite/900` #111418 | 3.54 → 5.22 on `action/accent` |

`border/sheet` in Dark still uses `slate/600` #5A6168 (2.84 on surface, 3.10 on canvas), as specified by the UI review;
it is an edge, not a control, so it has no minimum.

## Text

| Foreground on background | Light | Dark | Result |
|---|---|---|---|
| `text/primary` on `bg/canvas` | 16.74 | 17.03 | pass |
| `text/secondary` on `bg/canvas` | 5.69 | 7.45 | pass |
| `text/accent` on `bg/canvas` | 5.97 | 7.49 | pass |
| `text/danger` on `bg/canvas` | 5.10 | 8.52 | pass |
| `text/primary` on `bg/surface` | 18.47 | 15.59 | pass |
| `text/secondary` on `bg/surface` | 6.28 | 6.82 | pass |
| `text/accent` on `bg/surface` | 6.58 | 6.86 | pass |
| `text/danger` on `bg/surface` | 5.62 | 7.80 | pass |
| `text/primary` on `bg/raised` | 18.47 | 13.98 | pass |
| `text/secondary` on `bg/raised` | 6.28 | 6.12 | pass |
| `text/accent` on `bg/raised` | 6.58 | 6.15 | pass |
| `text/danger` on `bg/raised` | 5.62 | 7.00 | pass |
| `text/primary` on `action/selected` | 14.96 | 11.80 | pass |
| `text/secondary` on `action/selected` | 5.09 | 5.16 | pass |
| `text/accent` on `action/selected` | 5.33 | 5.19 | pass |
| `text/danger` on `action/selected` | 4.55 | 5.90 | pass |
| `text/comeback` on `bg/canvas` | 4.74 | 7.46 | pass |
| `text/comeback` on `bg/surface` | 5.23 | 6.83 | pass |
| `text/comeback` on `bg/comeback-tint` | 4.72 | 5.98 | pass |
| `text/on-inverse` on `bg/inverse` | 18.47 | 16.17 | pass |
| `text/accent-on-inverse` on `bg/inverse` | 7.11 | 5.76 | pass |
| `text/on-accent` on `action/accent` | 6.58 | 5.22 | pass |
| `text/on-inverse` on `action/primary` | 18.47 | 16.17 | pass |

## Controls and borders (3:1)

| Foreground on background | Light | Dark | Result |
|---|---|---|---|
| `border/field` on `bg/canvas` | 3.08 | 3.65 | pass |
| `border/field` on `bg/surface` | 3.40 | 3.34 | pass |
| `border/field` on `bg/raised` | 3.40 | 3.00 | pass (on the line in Dark) |
| `border/focus` on `bg/canvas` | 5.97 | 7.49 | pass |
| `action/accent` on `bg/canvas` | 5.97 | 5.50 | pass |
| `action/danger` on `bg/canvas` | 5.10 | 8.52 | pass |
| `action/primary` on `bg/canvas` | 16.74 | 17.03 | pass |
| `border/focus` on `bg/surface` | 6.58 | 6.86 | pass |
| `action/accent` on `bg/surface` | 6.58 | 5.04 | pass |
| `action/danger` on `bg/surface` | 5.62 | 7.80 | pass |
| `action/primary` on `bg/surface` | 18.47 | 15.59 | pass |

## Activity art marks on their tile (3:1)

| Mark on tile | Light | Dark | Result |
|---|---|---|---|
| `art/peak` on `action/selected` | 5.33 | 3.81 | pass |
| `art/peak` on `bg/comeback-tint` | 5.95 | 4.41 | pass |
| `art/level` on `action/selected` | 3.38 | 5.19 | pass |
| `art/level` on `bg/comeback-tint` | 3.77 | 6.01 | pass |
| `art/comeback` on `action/selected` | 3.23 | 5.17 | pass |
| `art/comeback` on `bg/comeback-tint` | 3.61 | 5.98 | pass |

## Decorative or label-backed (no minimum)

| Foreground on background | Light | Dark | Note |
|---|---|---|---|
| `border/default` on `bg/canvas` | 1.17 | 1.22 | Divider and card border |
| `border/default` on `bg/surface` | 1.29 | 1.11 | Divider and card border |
| `border/sheet` on `bg/surface` | 1.29 | 2.84 | Sheet edge; the scrim and shadow also separate it in Light |
| `border/sheet` on `bg/canvas` | 1.17 | 3.10 | Sheet edge |
| `grid/0` on `bg/surface` | 1.23 | 1.11 | Grid level 0 and pause (labelled "paused") |
| `grid/1` on `bg/surface` | 1.81 | 1.52 | Grid level 1 |
| `grid/2` on `bg/surface` | 3.64 | 2.93 | Grid level 2 |
| `grid/3` on `bg/surface` | 6.58 | 6.86 | Grid level 3 |
| `eq/peak` on `bg/canvas` | 5.97 | 5.50 | Brand bars: decorative |
| `eq/level` on `bg/canvas` | 3.30 | 7.49 | Brand bars: decorative |
| `eq/comeback` on `bg/canvas` | 2.36 | 7.46 | Brand bars: decorative |

The grid never relies on colour alone: the text summary ("Active on 31 days…") and each tile's semantics label
carry the meaning.
