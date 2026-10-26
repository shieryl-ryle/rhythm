# ADR-012 — Paused days look the same as empty days in the grid

- **Date:** 2026-10-26
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) BR-006, F-006 · [Methods](../methods.md) EQ-002 · [QA](../qa-test-plan.md) TC-006, TC-014 · [DESIGN.md](../DESIGN.md)

### Context
EQ-002 and the PRD acceptance criteria drew a paused day as a separate "pause marker": first a
dashed outline in the wireframes, then a hatched square in the Lilt visual design. The owner
reviewed the grids on the Today and Paused screens and found the dashed and hatched tiles noisy
and inconsistent with the rest of the grid.

### Why now
The grid is the app's key visual and appears on Today, Paused, My rhythm and the share card. It has
to be settled before the remaining screens are designed and the Flutter grid is built (TASK-006).

### Options considered
1. **Keep a distinct pause marker** (hatch). Pros: you can see a pause at a glance. Cons: visual
   noise, and the owner rejected it twice.
2. **Pause looks like an empty day** (a level-0 filled square). Pros: one calm, consistent shape.
   Cons: a pause isn't visible in the grid itself.

### Decision
1. In the grid, a paused day is drawn **exactly like a day with no activity**: a filled, rounded,
   level-0 square. There are no outlines, dashes or hatches anywhere in the grid. Today keeps its
   cobalt focus ring.
2. A pause stays a **separate state in the data** (EQ-002 still returns "pause") and in the
   **semantics label**, e.g. "Oct 21: paused".
3. Pauses still never count as a lapse (EQ-001), and are never counted or shown as a failure or
   miss (BR-006 unchanged).

### Why this option
BR-006's goal is that a pause never reads as failure. Level 0 is already neutral (no red, no
"missed" copy), so a pause drawn as level 0 meets BR-006, and the grid stays calm.

### Overrides
- **Prior ADRs:** none.
- **Docs reconciled:** PRD F-006 acceptance and edge case, EQ-002, TC-006, TC-014, DESIGN.md grid
  tokens, demo script, pitch visual direction.

### Consequences
- **Easier:** one tile style to build and test; a calmer key visual.
- **Harder / owed:** the grid no longer *shows* rest days. If testing shows people want to see
  them, the place to add that is the day detail (tap a tile), not the grid.
- **Follow-up:** the golden test for TC-006 checks pause = level-0 rendering plus the "paused"
  semantics label.
