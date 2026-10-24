# ADR-006 — No LLM in the P0 prototype

- **Date:** 2026-10-24
- **Status:** Accepted
- **Owners:** Shieryl (owner)
- **Related:** [PRD](../prd.md) F-002, F-004, F-007, BR-002, BR-010, BR-016, BR-019, BR-020 · [ADR-003](ADR-003-gemini-via-firebase-ai-logic.md) · TASK-007, TASK-008

### Context
ADR-003 added Gemini only to reword library actions and draft observations. The adapting itself
(ranking, reasons, observations) is deterministic Dart (EQ-003, EQ-004, EQ-009) and never needed the
LLM. In wireframe review on 2026-10-24, the owner found that the AI choice step during setup (S-002)
asked people to decide about something with little value to them ("friendlier wording"), and removed
it. That left the question of whether AI should exist anywhere in the prototype.

### Why now
TASK-007 (AI adapter) and TASK-008 (paid Gemini tier) would take build time before the 2026-11-13
freeze. The consent and privacy copy (S-001, S-108, Settings) depends on whether anything leaves the
device.

### Options considered
1. **Remove the LLM from P0.** Pros: "nothing leaves your phone" becomes literally true; no App
   Check, paid tier or prompt-safety work; two tasks freed for the activity library and the new
   setup. Cons: weaker on the "technical depth / AI" judging criteria, which ADR-003 option 3 noted.
2. **Keep AI rewording, off by default in Settings.** Pros: the pitch can say "AI". Cons: still
   built, secured and explained, for a feature few people would turn on.

### Decision
1. The P0 prototype makes **no LLM calls**. Every suggestion and observation uses library or
   template text.
2. S-002 (AI choice) is cut. Setup goes S-001 → S-003.
3. The Settings AI toggle, the "Reworded by AI" tag, and the AI parts of S-107 and S-108 are
   removed from P0 designs.
4. BR-016, BR-019 and BR-020 stay in the PRD, marked dormant. They apply again if AI returns.
5. The adapting is presented as a **transparent personalisation engine**: a rules-based ranking
   that learns from each person's answers, with every reason shown. This is our "responsible AI"
   story for judges.
6. TASK-007 and TASK-008 are cut.

### Why this option
The learning never depended on the LLM. Removing it shrinks scope, simplifies privacy to one true
sentence, and frees time for what Dzelle's review showed was missing.

### Overrides
- **Prior ADRs:** supersedes ADR-003.
- **Docs to reconcile:** PRD (done in v0.3), BRD (done in v0.3), System Design §4 (integrations),
  Methods EQ-006/EQ-007 (dormant), Ops (Firebase AI Logic, App Check), Sitemap (S-002, S-008,
  S-107, S-108), User Flow UF-001, DESIGN.md (AI tag), capabilities.md §1, rules-reviewer checks
  BR-016/BR-019/BR-020, `AGENTS.md` architecture and stack-currency rows → TASK-009.
- **Out of scope:** whether AI returns after the challenge.

### Consequences
- **Easier:** no network calls in P0 at all; simpler consent; no Gemini cost or quota risk.
- **Harder / owed:** the technical documentation must explain the ranking's depth and
  explainability well enough to carry the AI and technical criteria (BRD RK-009).
- **Follow-up:** TASK-009.
