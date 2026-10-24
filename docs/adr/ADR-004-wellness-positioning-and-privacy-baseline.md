# ADR-004 — Wellness positioning and global privacy baseline

- **Date:** 2026-10-23
- **Status:** Accepted
- **Owners:** Shieryl (team)
- **Related:** [PRD](../prd.md) BR-001, BR-003, BR-014..BR-018 · [BRD](../brd.md) §9, RK-002, RK-005 · [Capabilities](../capabilities.md)

### Context
Rhythm handles health-adjacent personal data (chosen behaviour, reasons, constraints, reflections,
barriers). Users are global, so no single jurisdiction applies. The challenge expects explicit
consent, data minimisation, user-controlled sharing, a clear line between screening and
diagnosis, and respect for cultural sensitivities. Responsible AI and data governance are judged.
The challenge rules page could not be read on 2026-10-23.

### Why now
The consent text, data model, and AI prompts all depend on which rules we follow.

### Options considered
1. **Position as a medical or clinical tool.** Pros: a stronger "clinical relevance" story. Cons:
   brings in medical-device regulation and clinical validation, which is impossible in 4 weeks
   and unsafe without clinicians.
2. **Wellness positioning with a strict global privacy baseline (GDPR-style principles).** Pros:
   safe, feasible, and judge-friendly. Cons: weaker clinical claims; not formal legal compliance
   for any one jurisdiction.
3. **Pick one jurisdiction's law only.** Pros: concrete. Cons: users are global; it doesn't fit.

### Decision
1. Rhythm is a **general wellness** app. It makes no diagnosis, treatment, or medical claims and
   promises no results (BR-001). Red-flag input routes to a fixed support message (BR-003).
2. The privacy baseline follows GDPR-style principles as a design standard (not a compliance
   claim): explicit consent before collection (BR-014), data minimisation and on-device storage
   (BR-015), AI opt-in with de-identified prompts (BR-016), and export and erasure (BR-017).
3. Cultural fit: users can exclude action categories (BR-011), and the action library is reviewed
   for cultural and religious sensitivity before release.
4. **Legal review is an open item** before any real-user study or launch beyond the challenge.

### Why this option
It is the only option that is both safe and buildable in 4 weeks, and it scores directly on the
"Responsible AI, safety, and data governance" judging criterion.

### Overrides
- **Prior ADRs:** none
- **Docs to reconcile:** none; the PRD already carries these rules
- **Out of scope:** formal legal compliance per jurisdiction; research ethics approval for studies

### Consequences
- **Easier:** clear rules for reviewers; a simple consent story.
- **Harder / owed:** the "clinical relevance" judging criterion must be argued through behaviour
  change and evidence boundaries, not clinical claims. A legal or ethics check is needed before
  real-user sessions grow beyond informal testing with friends.
- **Follow-up:** PRD §13 Q5 (challenge rules); legal review before scaling.
