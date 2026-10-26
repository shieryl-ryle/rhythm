# ADR-011 — Product name: Lilt

- **Date:** 2026-10-25
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [DESIGN.md](../DESIGN.md) "Brand motion: the equalizer" · [BRD](../brd.md) · [PRD](../prd.md) · Figma file `QEdjcVZJUBX6jpRxOVblCa`, page "Brand · Lilt"

### Context
"Rhythm" was a working name. The branding round for the RevenueCat Shipaton Design Award produced
an equalizer logo (three bars) and a first name choice, "Rally", whose wordmark turned the a-stem
and both Ls into the bars. A store and trademark check then found the same name already in use:
- **Rally Health** (UnitedHealth) holds registered "RALLY HEALTH" and "RALLY / COACH" marks for
  health and wellness apps.
- **"Rally: Move Together"** is a social fitness app on both stores, using RevenueCat.
- Several other Rally fitness apps exist.

For a store release under Shipaton, that is a rejection and takedown risk.

### Why now
Shipaton means shipping to the stores, and the brand, wordmark and motion are being finished now.
Renaming after the screens are built would cost more.

### Options considered
1. **Keep "Rally".** Pros: wordmark and motion done. Cons: a registered health mark and a
   near-identical social fitness app.
2. **Rally for the hackathon, rename at launch.** Pros: no rework now. Cons: rebrand later, and
   judges would see the conflicting name.
3. **"Lilt" now.** It means a lively rise and fall, which is exactly what the equalizer shows.
   l · i · l become the bars: peak, dip, comeback. Pros: the name tells the comeback story, no
   health or fitness app or health trademark found. Cons: a common App Store word (a habit
   tracker, a music player and others use it), and Lilt, Inc. holds "LILT" for software
   development services (AI translation).
4. **Allez, Tallo, Billow and others.** Weaker story or crowded (see the conversation record in
   memory).

### Decision
1. The product name is **Lilt**, for the hackathon submission and the store launch.
2. **Wordmark:** "lilt" in Unbounded Bold outlines. l · i · l are equalizer bars: peak (cobalt),
   dip (light cobalt, the i, which keeps its dot), comeback (orange). The t is tilted 12° onto its
   toe.
3. **Logo mark and app icon:** the same three bars in the same order (peak, dip, comeback), on a
   cobalt icon.
4. **Store listing** uses a descriptive subtitle, e.g. "Lilt: move at your rhythm", to stand apart
   from other apps named Lilt.
5. "Rally" assets stay in Figma, labelled "[archived]".

### Why this option
The name and the logo tell the same story as the product: up, dip, and back again. Its overlaps
are in unrelated categories, unlike Rally's.

### Overrides
- **Prior ADRs:** none (the name was never recorded in an ADR).
- **Docs to reconcile:**
  - DESIGN.md (done).
  - "Rhythm" appears 58 times in 25 docs (PRD, BRD, sitemap, user flow, store listing and
    others). Rename these in TASK-009, keeping the "My rhythm" tab name as is.
  - The Figma wireframe pages still say "Rhythm".
- **Out of scope:** the package name and app ID (set when the Flutter app is created).

### Consequences
- **Easier:** one story across name, logo, icon, opening animation and demo video.
- **Harder / owed:**
  - A professional trademark search before the store launch, covering USPTO, IP Australia and
    EUIPO, classes 9 and 42.
  - A store listing subtitle.
- **Follow-up:** run the doc-wide rename in TASK-009.
