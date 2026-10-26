# ADR-016 — Share cards: three templates, a 9:16 image with a 4:5 safe area

- **Date:** 2026-10-26
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) F-015, BR-023, BR-007 · [ADR-002](ADR-002-flutter-android-web-on-device.md) · [ADR-014](ADR-014-lilt-does-not-record-activities.md) · [Review record](../reviews/challenges-in-together-2026-10-26.md)

### Context
F-015 offers one achievement card, "Back at it", with an optional mini grid. The owner found it weak: the same
line for everyone, and the grid works better but needs other templates. A shared card is the main way people
outside the app see Lilt, so it needs more than one look. BR-023 limits what a card may show: no reflections,
free text, times or places; milestones that only increase; no streak counts; no guilt or loss wording.

### Why now
The share sheet (3.13) was being redrawn, and the grid toggle was drawn ON although F-015 says the grid is OFF
by default, which is a privacy default.

### Options considered
1. **Keep one template.** Pros: nothing to build. Cons: weak, repetitive, nothing to choose.
2. **Three milestone templates (Milestone, Activity, Rhythm), plus Together in P1.** Pros: variety inside
   BR-023; reuses the equalizer, the activity art and the grid. Cons: three layouts to build and test.
3. **Add an info card from a confirmed "what works" observation.** Cons: it carries times of day and
   patterns, which F-015 forbids. Rejected.
4. **Add a daily "Ran today" card.** Pros: what Strava users expect. Cons: it is not a milestone, invites daily
   comparison and pressure, and BR-023 and F-015 allow milestones only. Deferred to P1 and needs an amendment.

### Decision
1. The share sheet offers up to three templates, chosen with a segmented control above the preview: Milestone,
   Activity and Rhythm. Only templates that fit the achievement are offered. Together is added in P1.
2. Each card shows only what BR-023 allows. Rhythm and every total use all-time counts, never a rolling count.
3. A card is one 9:16 image (1080 × 1920), generated on the device, with all content inside a centred 4:5 safe
   area (1080 × 1350). The preview shows the 4:5 area. There is no format choice in P0.
4. The grid appears only in the Rhythm template. There is no "Show my grid" toggle (a toggle would add nothing, since Rhythm is the grid, and a default-off privacy switch is simpler as no switch). Explorer offers Milestone and Rhythm only.
5. The QR-style code points to the store page only and holds nothing personal.
6. A single completed-activity card is not offered until F-015 and BR-023 are amended.

### Why this option
It answers "more templates" without breaking the milestone-only, no-streak promise, and uses parts that already
exist. The safe area keeps the content visible on stories and crops to a feed post.

### Overrides
- **Prior ADRs:** none superseded.
- **Docs to reconcile (done):** PRD F-015 and BR-023, DESIGN.md (Share card), QA (TC-047).
- **Out of scope:** the daily "Ran today" card, the info card, format choices, and the Together template's final
  design (P1).

### Consequences
- **Easier:** variety on social; the privacy default is right.
- **Harder / owed:** three card layouts plus light and dark to build and test; a golden-image test.
- **Follow-up:** the Together template when F-012 is built.
