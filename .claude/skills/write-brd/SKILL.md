---
name: write-brd
description: Use when the user wants a BRD / business requirements document, a business case, business model, objectives, budget or cost-benefit, stakeholders, or business risks — e.g. for a hackathon, client, sponsor, or investor. Interviews the user and writes docs/brd.md. Run before or alongside write-prd; the BRD owns the WHY, the PRD owns the WHAT.
---

# Write a BRD

Goal: `docs/brd.md` that tells stakeholders or judges **why** this is worth building and how it
could make money or impact. Structure: [template.md](template.md).

## Ground rules
- **BRD = why. PRD = what.** Features, user stories, and BR-### rules belong in the PRD — link to
  it, don't restate it. If no PRD exists yet, keep scope to one paragraph and suggest `write-prd` next.
- **Interview, don't invent.** No market sizes, prices, or statistics unless the user supplies
  them or you cite a source. Unvalidated beliefs are labelled **hypothesis** and get a validation
  step in §11.
- **Max 4 questions per message.** Offer 2–3 options when the user is unsure.
- **Push back** on: revenue models with no named payer; objectives that are outputs ("launch the
  app") instead of outcomes; costs left at "free" without checking quotas and limits; risks without
  a mitigation.
- If `docs/brd.md` already has content, **revise** it and bump the version; never delete history
  silently.

## Interview rounds
1. **Context** — Who is this for (judges, client, sponsor, internal)? Deadline? What decision should
   the reader make after reading?
2. **Problem & objectives** — The business problem in one paragraph; 2–4 measurable objectives
   (short-term, e.g. "win the hackathon", and long-term).
3. **Model** — Who pays, for what, through which channel? Who benefits but doesn't pay? Is this
   validated or a hypothesis?
4. **Stakeholders** — Who decides, who builds, who uses, who could block (regulator, partner)?
5. **Money & time** — Build cost, running cost (cloud, AI API quotas), team time, timeline
   milestones; expected benefit.
6. **Constraints & risks** — Legal/privacy/regulatory, technical, market, team. One mitigation each.

Show a one-screen summary (objectives, model, top 3 risks, cost) and ask for corrections **before**
writing.

## Writing the file
1. Fill [template.md](template.md) into `docs/brd.md`. Delete sections that truly don't apply.
2. Objectives get IDs `BO-###`; risks `RK-###`.
3. Link the PRD for scope (`F-###`), ADRs for decisions (e.g. the business model choice).
4. If `docs/index.md` §0 has no BRD row, add:
   `| Business objectives, business model, business risks | [BRD](brd.md) | |`

## After writing
- Offer `write-adr` for the business-model choice if alternatives were weighed.
- Offer `write-prd` if the PRD doesn't exist or disagrees with the BRD scope.
- Report: objectives, payer, biggest unvalidated hypothesis, top risk.
