# Pitch kit — Rhythm

> Pitch-facing material for the Future Health Challenge judges. Facts come from the owning docs.
> Link, don't restate: business case → [BRD](../brd.md), product → [PRD](../prd.md),
> numbers → [Methods](../methods.md), demo → [Demo script](../demo-script.md).

| File | Purpose |
|---|---|
| [business-model-canvas.md](business-model-canvas.md) | One-page business model |
| [visual-direction.md](visual-direction.md) | Visual north star for slides and screens |
| `deck.pdf` (to be added) | Exported deck (submission copy) |

## Naming
**Rhythm** is a working name. It suggests a routine that flexes with life rather than a rigid
streak. Pronounced as the English word. No earlier names. A rename needs an ADR.

## Pitch one-liners
- **What:** a mobile app that helps people find a manageable way to start, continue, or return to
  a healthy routine, learning from what actually fit their days.
- **For whom:** people whose routines were disrupted by life changes (moving, exams, caregiving,
  new jobs), and anyone who keeps restarting.
- **Why now:** the Future Health Wellbeing track asks how technology can help people "sustain
  healthier behaviours … over time". Tracking apps measure; they don't adapt when life changes.

## Map to the judging criteria
| Criterion (challenge page, 2026-10-23) | Where we show it |
|---|---|
| Health impact and clinical relevance | Job statement, evidence boundary, behaviour stages ([PRD](../prd.md) §1, §4); wellness positioning ([ADR-004](../adr/ADR-004-wellness-positioning-and-privacy-baseline.md)) |
| Technical depth and architecture | Glass-box ranking ([Methods](../methods.md)), on-device architecture ([System Design](../system-design.md)) |
| Working solution and demo quality | [Demo script](../demo-script.md), deployed web build + APK |
| Responsible AI, safety, data governance | BR-001..BR-003, BR-014..BR-020; AI only rewords; safety check EQ-007; free tier never sees real data (ADR-003) |
| Scalability and deployment readiness | No backend cost per user; Flutter → iOS later; [Ops](../ops.md) |
| Commercial viability and path to pilot | [Business model canvas](business-model-canvas.md); three payer hypotheses ([BRD](../brd.md) §5) |

## Claims checklist
Every claim in the deck is one of: **[validated]** with a source, **[hypothesis]**, or a measured
result with its `EQ-###`. No unsourced statistics. The friends' responses are described as a
convenience sample of six people plus the founder, never as research results.
