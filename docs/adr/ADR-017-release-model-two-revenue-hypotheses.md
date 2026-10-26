# ADR-017 — Release model: a free core loop and two unvalidated revenue paths

- **Date:** 2026-10-26
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [BRD](../brd.md) §5, BO-003, RK-004 · [PRD](../prd.md) BR-015, BR-025 · [ADR-004](ADR-004-wellness-positioning-and-privacy-baseline.md) · [ADR-013](ADR-013-p1-sharing-two-flags-and-device-local-count.md) · [PM memo](../reviews/pm-release-sequencing-2026-10-26.md)

### Context
The owner's main goal is to ship Lilt on the Apple App Store and Google Play after the hackathon, as a free app
with an optional subscription. The hackathon BRD kept the payer open as three untested hypotheses and said end
users are free in all three options. The hackathon is scored partly on "Commercial viability and path to pilot"
(BRD BO-003). Nothing is validated: no payer conversation, no user willingness-to-pay signal.

### Why now
The BRD had to be reconciled with the release plan before the finals, and the pitch and canvas must not
contradict each other. The build also must not stall on release paperwork (no code exists, the feature freeze is
2026-11-13).

### Options considered
1. **Stay silent about the subscription** (the earlier BRD wording). Pros: nothing to defend. Cons: the release plan
   then contradicts "free to users in all three options", and the finals Q&A will find it.
2. **Present freemium as the model.** Pros: simple story. Cons: leads with an untested consumer claim and skips
   the path to pilot that the criterion scores.
3. **One product, two unvalidated revenue paths, the payer pilot first.** Pros: honest, matches what the
   challenge scores, keeps the release option visible. Cons: two stories to explain.

### Decision
1. In the challenge, Lilt is free to users and nothing is billed. No billing, price or paywall is built or drawn
   for the challenge.
2. The BRD states two revenue hypotheses, neither validated: payer-funded pilots (lead) and an optional user
   subscription in the later store release. What a subscription includes and costs is undecided.
3. The core comeback loop (suggest, reflect, come back, pause, export, delete) is not a paywall candidate.
4. The BRD and the pitch claim no price, willingness to pay, conversion, market size or store-fee split, and make
   no claim about aggregate outcomes for payers (no reporting mechanism exists; BR-015, BR-025). Cloud backup is
   not part of the pitch.
5. Evidence is gathered before the finals (2026-12-07): payer conversations with a graded outcome, an unprompted
   willingness-to-pay question in the user sessions, Firebase cost per active user, and an owner-set decision rule.
6. Store-release work (a single `docs/release-plan.md`, release-only screens on a separate Figma page, a
   store-compliance pass, a payments `adapt-project` step) is capped at 8 owner-days and mostly runs after the
   challenge submission, with only a small, gated amount before the feature freeze.

### Why this option
It protects the build (14 working days to the freeze, no code yet) and answers the criterion that is judged,
while keeping the main goal, shipping, visible. The release documents cannot be honestly final until the payer
and user evidence exists.

### Overrides
- **Prior ADRs:** none superseded. Consistent with ADR-004 (privacy baseline) and ADR-013 (what leaves the
  device). A cloud backup, a funnel analytics tool or any payment provider each need their own ADR.
- **Docs to reconcile (done):** BRD §5, `docs/pitch/business-model-canvas.md`.
- **Out of scope:** price, tiers, trial, which features are paid, the billing provider, paywall placement, legal
  entity and tax, iOS timing, store fee shares.

### Consequences
- **Easier:** one consistent business story for the finals; no claim to defend that has no evidence.
- **Harder / owed:** the evidence work (payer talks, sessions); the release plan after the submission; a payments
  ADR when the provider is chosen.
- **Follow-up:** `docs/release-plan.md` (11-21 to 12-04); the store-compliance re-verification; the developer
  account decision by 2026-11-06.
