# Business Model Canvas — Rhythm (pitch-facing)

> One-page business model derived from [BRD](../brd.md) §5. Every claim is a hypothesis unless
> marked **[validated]**; unvalidated ones carry `[need: …]` saying what would validate them.

## 0. Target market
People who want healthier routines but struggle to follow through amid competing demands,
limited energy, or life disruptions: students, workers, commuters, people adjusting to life
changes. Global. Size: `[need: a cited source for the share of adults who start and abandon health
routines; do not quote a number until sourced]`.

## 1. Customer Segments
- **Users (free):** returners and stretched starters. They care because the routine matters to
  them but no longer fits their life.
- **Payers (one of three, hypothesis):** employers' wellbeing programs; insurers / health funds;
  public health bodies. They care about sustained healthy behaviour across a population.

## 2. Value Propositions
- **For users:** a small step that fits today; coming back without guilt; seeing what actually
  works for *them*.
- **For payers:** sustained participation (not app opens) reported as privacy-preserving
  aggregates, with no individual data shared without consent `[need: payer interviews]`.

## 3. Channels
- Employer: HR benefits / wellbeing platform `[need: 1 employer conversation]`.
- Insurer: member benefit app or prevention program `[need: 1 insurer conversation]`.
- Public health: pilot via a health authority or the challenge's post-award pathway
  `[need: 1 conversation]`.

## 4. Customer Relationships
Self-serve for users; partner-led for payers (pilot → program).

## 5. Revenue Streams
- Per-seat (employer) or per-member (insurer) licence, or a funded public pilot. Pricing not set.
  `[need: willingness-to-pay signal from any payer]`

## 6. Key Activities
Curating and safety-reviewing the action library; improving the ranking from study data; privacy
and safety governance; partner pilots.

## 7. Key Resources
The curated action library (DS-001); the glass-box ranking (Methods); the Flutter app; safety
lists (DS-002, DS-003); the team.

## 8. Key Partnerships
Firebase / Gemini (AI rewording); behaviour-change or clinical advisors to review the library
`[need: an advisor]`; a pilot payer.

## 9. Cost Structure
Near-zero per-user infrastructure (on-device data, static hosting); Gemini paid-tier usage
(low-cost model, capped by EQ-006); content curation and review; team time. `[need: cost per
active user once paid-tier usage is measured]`

## Validation status
| Hypothesis | Status | Next step |
|---|---|---|
| Benefits feel less noticeable than effort; tracking satisfaction fades | hypothesis | User sessions before 2026-11-13 ([BRD](../brd.md) §11) |
| Returners find small decisions more manageable than a full restart | hypothesis | Sessions with recent returners |
| An employer / insurer / public body would fund a pilot | hypothesis | One conversation each before 2026-12-07 |

## Pitch one-liners
- "Rhythm doesn't count your streak. It helps you find your way back."
- "Data stays on your phone. AI only rewords. Every suggestion says why."
