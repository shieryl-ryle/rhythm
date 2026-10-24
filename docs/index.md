# Documentation Index — Rhythm

**Maintained by:** Shieryl
**Last updated:** 2026-10-23

## 0. Source-of-truth map (one fact, one home)

Each concern has exactly one canonical owner. Other docs **link** to it instead of restating it.
When two docs disagree, the owner wins until the other is reconciled.

| Concern | Canonical owner | Tier |
|---|---|---|
| Decision *why* / pivots (**audit root**) | [ADRs](adr/) — append-only; newest Accepted wins | Core |
| Business objectives, business model, business risks | [BRD](brd.md) | Optional — needs a business case |
| What we build: features `F-###`, journeys `UJ-###`, rules `BR-###` | [PRD](prd.md) | Core |
| Screens · IA · routes · access (`S-###`) — static UX map | [Sitemap](sitemap.md) | Optional — has a UI |
| Journeys across screens (`UF-###`, edge cases `EV-###`) — dynamic UX map | [User Flow](user-flow.md) | Optional — has a UI |
| How it's built: architecture, integrations, security, stack currency | [System Design](system-design.md) | Core |
| Entities, tables, columns, enums | [Data Model](data-model.md) | Optional — stores data |
| Every computed number and threshold (`EQ-###`, `DS-###`) | [Methods](methods.md) | Optional — computes/scores/flags |
| Visual tokens and component rules | [DESIGN.md](DESIGN.md) | Optional — has a UI |
| Tests · cases · commands (`TC-###`) | [QA Test Plan](qa-test-plan.md) | Core |
| Deploy, config/secret names, incidents, backup | [Ops](ops.md) | Optional — deployed |
| Build crew (agent roster) → `.claude/agents/*.md` | [SAD](sad.md) | Core |
| External plugins / MCP servers: which, when, how they fit | [Toolbox](toolbox.md) | Core |
| Active capabilities + catalog of what each requires | [Capabilities](capabilities.md) | Core |
| Live work `TASK-###`, owners, status | [Implementation Plan](implementation-plan.md) | Core |
| Demo walkthrough | [Demo script](demo-script.md) | Optional — demo/pitch |
| Pitch: business model canvas, visual direction | [Pitch kit](pitch/README.md) | Optional — demo/pitch |
| Seed / fixture data | [`seed/README.md`](../seed/README.md) | Optional — has fixtures |
| Store release process, versioning, signing (names only) | [Release](release.md) | Mobile |
| Store listing copy and assets | [Store listing](store-listing.md) | Mobile |
| Store rules: privacy, permissions, account deletion, SDK targets | [Store compliance](store-compliance.md) | Mobile |
| Device matrix and mobile QA | [Mobile QA](mobile-qa.md) | Mobile |

**Optional docs:** all optional docs were kept at bootstrap (2026-10-23). Delete any that stop
applying (and their rows); empty templates are noise for agents.

## 1. ID conventions

| Prefix | Meaning | Home |
|---|---|---|
| `F-###` | Feature | PRD |
| `UJ-###` | User journey | PRD |
| `BR-###` | Business / safety rule (testable) | PRD |
| `BO-###` / `RK-###` | Business objective / business risk | BRD |
| `S-###` | Screen | Sitemap |
| `UF-###` / `EV-###` | User flow / edge case | User Flow |
| `EQ-###` / `DS-###` | Equation or threshold / dataset | Methods |
| `TC-###` | Test case | QA Test Plan |
| `TASK-###` | Unit of work | Implementation Plan |
| `ADR-###` | Decision record | `adr/` |

IDs are never reused or renumbered. Retired items are marked `(cut)` rather than deleted.
