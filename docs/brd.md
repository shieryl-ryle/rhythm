# BRD — Business Requirements Document — Rhythm (working name)

> **Purpose:** the WHY, for the Future Health Digital Innovation Challenge judges. Owns business
> objectives, the business model hypothesis, and business risks. Scope details live in the [PRD](prd.md).
> **Status:** Draft v0.5 (v0.5: community events and clubs are a P0 highlight with a Firebase backend, health data stays on the device; ADR-009. v0.4: share cards, widget and calendar in the prototype; iPhone, Watch and invites as the next phase and a growth channel; ADR-008. v0.3: physical-activity focus, no LLM, social next, differentiation; ADR-005..007) · **Date:** 2026-10-25 · **Owner:** Shieryl
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
manageable decisions. A teammate's review added two more barriers: not every activity suits every
person, and activity rarely fits the schedule people actually have. **None of this is a confirmed
cause.** We will build a working prototype for the Wellbeing track that helps people find ways to
be **physically active** that fit their likes, access, time and energy, and to come back after a
break. The proposed concept, **Rhythm**, is a mobile app built on a loop: one suggested activity →
try it → share what happened → better-fitting suggestions next time. It adapts through a
transparent, rules-based personalisation engine, so every suggestion shows its reason. The
prototype uses no LLM, has no chatbot, and keeps all data on the device. Social features (friends,
circles, challenges, events) are the planned next phase. The concept itself is a hypothesis for
user sessions to test; the [PRD](prd.md) owns what we build. Value is created for users (sustained
physical activity)
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
  above and focused on physical activity; features are defined in the [PRD](prd.md) (`F-###`).
  Includes an explainable personalisation engine, explicit consent, data minimisation, and
  user-controlled data.
- **Highlight in the prototype: community (Together).**
  - Find local events and clubs (Reclub-style), RSVP, join and host.
  - It uses a small Firebase backend, and only the community profile and RSVPs go to the server;
    health data stays on the phone.
  - It is the first growth channel: hosts bring their groups in.
- **Also in the prototype (Android):** sharing achievement cards to social media.
- **Next phase (designed and pitched, not built for the challenge):**
  - calendar sync and a home-screen widget;
  - friends and circles, with shared "together days" (no streaks; ADR-010);
  - group challenges inside Together (Mine), with invites by link, QR code or join code;
  - iPhone, Apple Watch and iOS widgets;
  - activity data from phones and watches;
  - paid options (for example extra cloud backup), decided when the app is about to ship, after the challenge. The payer is still open (§5), so nothing is built or priced for the challenge.

  Invites to people who don't use Rhythm yet are a planned **growth channel**: every shared
  challenge or achievement brings new users in.
- **Out of scope:** diagnosis, treatment, or any medical claims; clinical risk scoring; integration
  with clinical records; LLM features in the prototype; a production-scale launch; monetisation
  features (billing) during the challenge.

## 3a. Alternatives and differentiation
| Alternative | What people get | Where it falls short for our users |
|---|---|---|
| Social fitness apps (e.g. Strava) | Effort seen and celebrated by others, which is a strong motivator | Built around people who already have an activity and a routine. Little help finding what fits, or coming back after a break |
| Habit trackers | Add a habit, tick it off, keep a streak | The same task every day; a broken streak feels like lost progress, and many people stop there |
| Wearables and health platforms | Automatic tracking | Records activity, but doesn't help decide what to do today or when |

**Rhythm's position:** it suggests activities that fit the person (likes, access, time and
energy), learns from their answers in ways they can see, and makes coming back after a break
easy. The next phase adds Strava-style social recognition in a cooperative form.

## 4. Stakeholders
| Stakeholder | Role | Interest | Influence |
|---|---|---|---|
| Challenge judges (Future Health; co-creators Microsoft, Inception, MBZUAI) | Decides | Health impact, technical depth, working demo, responsible AI, scalability, commercial path | High |
| Target users (people struggling to start, sustain, or return to healthy routines) | Uses / validates | Fits their real circumstances; low effort; respects their priorities | High |
| Team (2–4 people, Flutter experience) | Builds | Ships a working prototype by 2026-11-20 | High |
| Possible payers (employers, insurers/health funds, public health bodies) | Could fund a pilot | Measurable engagement and prevention value | Medium |
| Privacy regulators, platform stores | Could block | Lawful data handling, store policies | Medium |

## 5. Business model hypothesis
In the challenge, Lilt is free to users and nothing is billed. Two revenue paths are under test, and
**neither is validated** (§11): (1) **payer-funded pilots**, where an employer, insurer or health fund, or
public health body funds access for its members, which is what the conversations before the finals test; and
(2) an **optional user subscription** in the later Apple and Google Play release. What a subscription would
include and cost is not decided, and nothing is built or priced for it in the challenge. The core comeback loop
(suggest, reflect, come back, pause, export, delete) is not a paywall candidate. We will report what we learn,
including a "no" ([ADR-017](adr/ADR-017-release-model-two-revenue-hypotheses.md)).

All three payer options stay open as **hypotheses** to test.

| Question | Answer | Validated? |
|---|---|---|
| Who pays? | Option A: **employers** (workplace wellbeing programs). Option B: **insurers / health funds** (a prevention benefit for members). Option C: **public health bodies** (population prevention programs). | Hypothesis (all three) |
| For what? | Sustained engagement in healthy behaviours across their population. Pilot reporting is designed with the payer and is opt-in; no reporting mechanism exists yet, and no individual data is shared without consent (BR-015, BR-025) | Hypothesis |
| Through which channel? | A: wellbeing platform / HR benefits. B: member app or benefit program. C: public program or pilot via a health authority | Hypothesis |
| Who benefits without paying? | End users. The challenge build is free. In the later store release the app may stay free with an optional subscription (what it includes is undecided) | Hypothesis |
| Pricing idea | Not set. Per-seat or per-member pricing for payers, and any user subscription price, are candidates to test, not decisions. No price, conversion or market-size figure is claimed | Not set |

**Evidence to gather before the finals (2026-12-07):**
- **Payers:** at least one conversation per payer option. Record who owns the budget, what outcome they would
  fund, a pilot size and length they would consider, what data they would need, and their procurement
  blockers. Grade each as none, interest, named contact or LOI.
- **Users:** in the sessions, ask unprompted "If part of this cost money, which part?" and "What would you
  never accept paying for?" Record counts. This is stated preference from a convenience sample, not a
  conversion rate.
- **Cost to serve:** Firebase usage per active user from the sessions.
- **Decision rule (set 2026-10-27, before the sessions start):** if there is no named payer contact across at
  least three payer conversations by 2026-12-07, and no session participant names a feature they would pay for,
  the store release leads with the optional user subscription only and the payer pilot becomes a secondary
  hypothesis. If at least one payer names a budget owner and a pilot they would consider, the release leads
  with the payer pilot. Anything in between is reported as "undecided", not rounded up. The thresholds are the
  recommended defaults and can change only before the sessions start.

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
| AI API usage | $0 | No LLM in the prototype ([ADR-006](adr/ADR-006-no-ai-in-p0.md)) |
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
- **Technical:** no mandatory platform, model, or device. Team experience is Flutter. Any
  personalisation must be explainable and safe ("Responsible AI, safety, and data governance" is
  judged); the prototype meets this with a transparent rules-based engine and no LLM.
- **Time / team:** 2–4 people; about 4 weeks to submission; team of up to 5 allowed.

## 10. Risks
| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| RK-001 | The prototype addresses the wrong barrier because the hypotheses are unvalidated | M | H | Run short target-user sessions before feature freeze; keep the concept open until then; report findings honestly in the technical documentation |
| RK-002 | The AI or the content drifts into medical advice or unsafe suggestions | M | H | Wellness-only scope; a curated step library; guardrails and refusal rules in the PRD (`BR-###`); safety tests in QA |
| RK-003 | Scope is too large for ~4 weeks | H | H | One core journey; deployed walking skeleton first; feature freeze 2026-11-13 |
| RK-004 | Weak commercial story ("Commercial viability and path to pilot" is judged) | M | M | Test all three payer options with at least one conversation each; present a pilot shape |
| RK-005 | Personal wellbeing data mishandled or over-collected | L | H | Data minimisation, explicit consent, user deletion, no third-party sharing; rules in the PRD; data-governance section in the technical documentation |
| RK-006 | ~~AI API cost or quota limits break the demo~~ Retired 2026-10-24: no LLM in the prototype (ADR-006) | — | — | — |
| RK-007 | Challenge dates or rules change | L | M | Re-check the challenge page weekly; plan to the earliest date |
| RK-008 | New ideas (social, calendar, health data) pull scope past the freeze | H | H | Those are next phase; only free-time timing is in the prototype; feature freeze 2026-11-13 |
| RK-010 | Community launches empty (no real events nearby) | H | H | Labelled seed events and clubs; outreach to 2–3 local clubs (pickleball, run clubs) before the finals; demo account pre-joined |
| RK-011 | Unsafe or abusive user-generated events | M | H | 18+, public venues, host guidelines, report/block, auto-hide after reports, manual review (PRD BR-027/028) |
| RK-012 | Adding a backend slips the freeze | M | H | Calendar sync and widget moved to P1; Firebase managed services only; build order in the PRD §12 |
| RK-009 | Without an LLM, judges score "AI" and "technical depth" lower | M | M | Present the ranking as an explainable personalisation engine with visible learning; document its design and limits; show the AI and social roadmap |

## 11. Validation plan
| Hypothesis | How we test it | When | Success signal |
|---|---|---|---|
| People stop when benefits feel less noticeable than the effort, and tracking satisfies only temporarily | Short interviews and prototype sessions with target users | Before 2026-11-13 | Participants describe this pattern unprompted, or the prototype's "noticing benefits" element changes their stated intent to continue |
| For people returning, several disrupted routines feel like one overwhelming whole | Sessions with people who recently lost a routine | Before 2026-11-13 | Breaking the return into small decisions feels more manageable to them (self-report) |
| A manageable, circumstance-fit step helps people start or continue | Prototype sessions | Before 2026-11-13 | Users choose a step they say they can do today |
| Suggesting activities similar to ones people like helps them find one worth continuing | Prototype sessions | Before 2026-11-13 | Users say they would try a suggested new activity |
| Being seen and celebrated by others motivates continuing (the Strava insight) | Show the social wireframes in sessions | Before 2026-11-13 | Users say the social features would make them more likely to keep going |
| People would share achievements and invite friends who don't use Rhythm (growth) | Ask in sessions after showing the share card and challenge invite | Before 2026-11-13 | Users say they would share or invite someone, and name who |
| An employer, insurer, or public health body would fund a pilot | One conversation per payer option | Before 2026-12-07 | Stated interest, a named contact, or an LOI |
