# BRD — Business Requirements Document — Rhythm (working name)

> **Purpose:** the WHY, for the Future Health Digital Innovation Challenge judges. Owns business
> objectives, the business model hypothesis, and business risks. Scope details live in the [PRD](prd.md).
> **Status:** Draft v0.2 (v0.1 → v0.2: Rhythm concept and evidence boundary added from the owner's brief) · **Date:** 2026-10-23 · **Owner:** Shieryl
> **Traces to:** [PRD](prd.md) · business-model ADR: none yet (payer left open on purpose — see §5)
> **Challenge:** [Future Health Digital Innovation Challenge](https://hack2skill.com/event/futurehealthchallenge/)
> — **Wellbeing** track: *"help people understand changes in their health and wellbeing, sustain
> healthier behaviours, and access more personalised support over time."* (checked 2026-10-23)

## 1. Executive summary
People who want healthier routines often struggle to start, sustain, or return to them when
everyday demands, low energy, stress, or life changes make those routines hard to fit. Even when
they value the benefits, they postpone acting or stop. Our exploratory responses (six friends, four students and two working people, plus the founder's
experience; a convenience sample, not validated in Abu Dhabi) describe several
barriers: busyness, fatigue, stress, competing activities, disrupted routines, and too few
noticeable rewards. These shape our **working hypothesis**: people stop when the benefits feel less
noticeable than the immediate effort, and tracking only satisfies for a while. For people
returning, several disrupted routines at once feel like one overwhelming whole rather than a set of
manageable decisions. **None of this is a confirmed cause.** We will build a working prototype
for the Wellbeing track that helps people find a manageable way to start or continue within their
current circumstances. It will use a bounded AI model under explicit safety and data-governance
guardrails. The proposed concept, **Rhythm**, is a mobile app built on a loop: choose an action → try it →
share what happened → better-fitting options next time. It has no chatbot, and data stays on the
device. The concept itself is a hypothesis for user sessions to test; the [PRD](prd.md) owns what
we build. Value is created for users (sustained healthy behaviour)
and potentially for organisations that fund prevention. **Who pays is an open hypothesis** with
three candidates (§5).

**Job statement:** *When everyday demands or life changes make healthy behaviours difficult to
sustain, I want to find a manageable way to start, continue, or return within my current circumstances, so
I can care for my health alongside my responsibilities and personal priorities.*

## 2. Business objectives
| ID | Objective (outcome) | Horizon | Measured by |
|---|---|---|---|
| BO-001 | Place top 3 in the Future Health Challenge with a working prototype plus technical documentation of assumptions and limitations | Submit 2026-11-20; finals 2026-12-07..11 | Shortlisted as a finalist; final placing |
| BO-002 | Test the core hypothesis: do manageable, circumstance-fit steps and noticeable benefits help people continue or return better than plain tracking? | Before submission, then ongoing | Evidence from target-user sessions (§11), reported honestly, including disconfirming results |
| BO-003 | Secure a path beyond the challenge: a pilot partner, grant, or the challenge's post-award readiness pathway | 3–12 months | One named pilot conversation or LOI; readiness assessment |

## 3. Scope
- **In scope:** one working prototype for the Wellbeing track, built around the job statement
  above; features are defined in the [PRD](prd.md) (`F-###`). Includes bounded AI assistance,
  explicit consent, data minimisation, and user-controlled data.
- **Out of scope:** diagnosis, treatment, or any medical claims; clinical risk scoring; integration
  with clinical records; a production-scale launch; monetisation features (billing) during the
  challenge.

## 4. Stakeholders
| Stakeholder | Role | Interest | Influence |
|---|---|---|---|
| Challenge judges (Future Health; co-creators Microsoft, Inception, MBZUAI) | Decides | Health impact, technical depth, working demo, responsible AI, scalability, commercial path | High |
| Target users (people struggling to start, sustain, or return to healthy routines) | Uses / validates | Fits their real circumstances; low effort; respects their priorities | High |
| Team (2–4 people, Flutter experience) | Builds | Ships a working prototype by 2026-11-20 | High |
| Possible payers (employers, insurers/health funds, public health bodies) | Could fund a pilot | Measurable engagement and prevention value | Medium |
| Privacy regulators, platform stores, AI provider | Could block | Lawful data handling, store policies, AI usage policies | Medium |

## 5. Business model hypothesis
All three payer options stay open as **hypotheses** to test (§11). No option is validated yet.

| Question | Answer | Validated? |
|---|---|---|
| Who pays? | Option A: **employers** (workplace wellbeing programs). Option B: **insurers / health funds** (a prevention benefit for members). Option C: **public health bodies** (population prevention programs). | Hypothesis (all three) |
| For what? | Sustained engagement in healthy behaviours across their population, with privacy-preserving aggregate outcomes (no individual data shared without consent) | Hypothesis |
| Through which channel? | A: wellbeing platform / HR benefits. B: member app or benefit program. C: public program or pilot via a health authority | Hypothesis |
| Who benefits without paying? | End users (free to them in all three options) | Hypothesis |
| Pricing idea | Not set. Per-seat or per-member pricing is a candidate to test, not a decision | Not set |

## 6. Success metrics
| Metric | Target | Why it matters |
|---|---|---|
| Prototype submitted with technical documentation | By 2026-11-20 | Required to be judged (BO-001) |
| Target-user sessions run on the prototype or concept | ≥ 5 people (assumption, adjust to capacity) | Evidence for or against the hypothesis (BO-002); supports the "health impact" criterion |
| Users who say the prototype helped them pick a step they could actually do today | Reported as a count out of sessions, no fixed target | Tests the core of the job statement |
| Payer conversations | ≥ 1 per payer option before finals (assumption) | "Commercial viability and path to pilot" criterion (BO-003) |

## 7. Timeline
Source: challenge page, checked 2026-10-23. The page says dates may change.

| Date | Milestone |
|---|---|
| 2026-10-23 | BRD/PRD drafted; stack chosen |
| 2026-10-30 (target) | Deployed walking skeleton; first user sessions scheduled |
| 2026-11-10 | Registration closes (a press release says 15 Nov; we plan to the earlier date) |
| 2026-11-13 (target) | Feature freeze; user sessions done |
| 2026-11-20 | **Prototype submission** (working prototype + technical documentation) |
| 2026-11-20..30 | Evaluation |
| 2026-12-07..11 | Finalist presentations and awards at GITEX 2026 |

## 8. Budget / cost-benefit
| Item | Cost | Notes (free tier, quota, assumption) |
|---|---|---|
| Cloud hosting | Target $0 | Free tiers only; limits checked in `choose-stack` and recorded in [System Design](system-design.md) |
| AI API usage | Target $0 to low | Free tier or credits; quota and per-call cost checked before use; usage capped in the prototype |
| Team time | TBD (2–4 people × ~4 weeks part-time) | Assumption |
| **Expected benefit** | Prize (USD 50k / 35k / 20k for places 1–3), the post-challenge readiness pathway, and validated learning about the problem | Hypothesis |

## 9. Constraints
- **Legal / regulatory:** users are global (no single jurisdiction). We assume privacy best
  practice: explicit consent, data minimisation, user-controlled sharing and deletion, and strong
  access controls. Wellness framing only, with no diagnosis, treatment, or medical claims, to stay
  outside medical-device regulation. **Assumption:** confirm against the challenge rules
  ([rules page](https://hack2skill.com/event/futurehealthchallenge/tnc) could not be read on
  2026-10-23).
- **Cultural:** respect religious, social, and cultural sensitivities (an expectation stated by the
  challenge).
- **Technical:** no mandatory platform, model, or device. Team experience is Flutter. The AI must
  be bounded, explainable, and safe ("Responsible AI, safety, and data governance" is judged).
- **Time / team:** 2–4 people; about 4 weeks to submission; team of up to 5 allowed.

## 10. Risks
| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| RK-001 | The prototype addresses the wrong barrier because the hypotheses are unvalidated | M | H | Run short target-user sessions before feature freeze; keep the concept open until then; report findings honestly in the technical documentation |
| RK-002 | The AI or the content drifts into medical advice or unsafe suggestions | M | H | Wellness-only scope; a curated step library; guardrails and refusal rules in the PRD (`BR-###`); safety tests in QA |
| RK-003 | Scope is too large for ~4 weeks | H | H | One core journey; deployed walking skeleton first; feature freeze 2026-11-13 |
| RK-004 | Weak commercial story ("Commercial viability and path to pilot" is judged) | M | M | Test all three payer options with at least one conversation each; present a pilot shape |
| RK-005 | Personal wellbeing data mishandled or over-collected | L | H | Data minimisation, explicit consent, user deletion, no third-party sharing; rules in the PRD; data-governance section in the technical documentation |
| RK-006 | AI API cost or quota limits break the demo | M | M | Free tier or credits with a usage cap; a rules-based fallback path; seeded demo data |
| RK-007 | Challenge dates or rules change | L | M | Re-check the challenge page weekly; plan to the earliest date |

## 11. Validation plan
| Hypothesis | How we test it | When | Success signal |
|---|---|---|---|
| People stop when benefits feel less noticeable than the effort, and tracking satisfies only temporarily | Short interviews and prototype sessions with target users | Before 2026-11-13 | Participants describe this pattern unprompted, or the prototype's "noticing benefits" element changes their stated intent to continue |
| For people returning, several disrupted routines feel like one overwhelming whole | Sessions with people who recently lost a routine | Before 2026-11-13 | Breaking the return into small decisions feels more manageable to them (self-report) |
| A manageable, circumstance-fit step helps people start or continue | Prototype sessions | Before 2026-11-13 | Users choose a step they say they can do today |
| An employer, insurer, or public health body would fund a pilot | One conversation per payer option | Before 2026-12-07 | Stated interest, a named contact, or an LOI |
