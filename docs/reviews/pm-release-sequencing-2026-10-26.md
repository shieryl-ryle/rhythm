# Decision memo: hackathon BRD stance and the store-release track — 2026-10-26

Written by the senior project manager role (a general agent following `.claude/agents/senior-project-manager.md`,
read-only). Kept as written. The owner agreed with the recommendation (build first, capped release track, the
hackathon BRD stance below). Facts from outside the repo carry the memo's own source tags and have not been
independently checked.

## 1. Recommendation

**Build the hackathon first. Do not finalize the store-release documents and screens before the build. Run a
capped release track (hard cap 8 owner-days): at most 1.5 days before the freeze, and the rest in the
evaluation window 2026-11-21 to 12-04.**

**Verdict: GO WITH CONDITIONS** on "build first, capped release track". **HOLD** on option (a), "finalize
everything before the build".

- **Q1, BRD stance.**
  - Say that the challenge build is free to users and bills nothing.
  - Show two revenue hypotheses, both unvalidated: a payer-funded pilot, and an optional user subscription in
    the store release.
  - Lead with the pilot path, which is what "Commercial viability and path to pilot" scores.
  - Do not claim price, willingness to pay, conversion, market size or store-fee splits.
- **Q2, sequencing.** The scarce resource is the 14 working days before the freeze, and no code exists. The gate
  on shipping is calendar lead time (store accounts, Google's closed test, legal and trademark review), not
  document completeness. So protect the build and start the lead-time clocks early.
- **Q3, scope.** One release-scope document plus one ADR, not a forked PRD and BRD. Eight to ten new frames on a
  separate Figma page. A store-compliance re-verification pass. Price, tiers, what is gated, billing provider and
  cloud backup stay undecided.

## 2. Schedule check

Today is Monday 2026-10-26. Working days are Mon-Fri, from today, exclusive of the target date. Team size and
capacity are not in the docs, so this is a calendar view.

| Milestone | Calendar days left | Working days left | Source |
|---|---|---|---|
| Walking skeleton target 10-30 | 4 | 4 | brd.md:115 |
| Q9 calendar-sync decision 11-06 (Fri) | 11 | 9 | prd.md:438 |
| Registration closes 11-10 (plan to the earlier date) | 15 | 11 | brd.md:116 |
| Feature freeze 11-13 (Fri) | 18 | 14 | brd.md:117, prd.md:420 |
| Deck and backup video due 11-18 | 23 | 17 | pitch/visual-direction.md:62-63 |
| Submission 11-20 (Fri) | 25 | 19 | brd.md:118 |
| Evaluation 11-20 to 11-30 | | | brd.md:119 |
| Finals 12-07 to 12-11 (GITEX) | 42 to 46 | | brd.md:120 |

**Premises you gave, checked:**
- No code exists. Glob finds no `app/`, `pubspec.yaml` or `firebase.json`.
- TASK-001 is `ready` and unassigned (implementation-plan.md:22).
- The BRD keeps the payer as three hypotheses (brd.md:91-95).
- Billing is out of scope for the challenge (brd.md:66-68, prd.md:411).
- The PRD flags scope growth as a risk and says P0 is 10 features including a backend with no code
  (prd.md:420).
- Payments is a capability that needs an ADR, store billing rules and restore/refund tests (capabilities.md:27).
  It is not yet in §1.
- All store-compliance rows are unchecked. The file says "Last full verification: not yet"
  (store-compliance.md:6, :17, :26, :32).
- The paid cloud backup is deferred to "about to ship, after the challenge" (brd.md:62, ADR-013:61-62).
- BO-003 and RK-004 are confirmed (brd.md:43, :150).

**Critical path and what does not fit:**
- Seven live tasks are unassigned: TASK-001, 002, 003, 005, 006, 014, 015.
- The chain is 001 → 002/003/004 → 005/006, and 013 → 014 → 015. Reading the dependencies, Together (014 and
  015) is not buildable until TASK-001 exists.
- Not yet ledgered: Settings, Discover, notifications, the demo seed loader, user sessions, technical
  documentation, and the deck and video (implementation-plan.md:40-42).
- ADR-009 sized Together alone at "about a week" (ADR-009:79). I cannot test fit without builder count. The
  PRD's own build order and cut list (prd.md:420) is the protection.
- Four of the five accepted ADRs from the last two days (ADR-013 to ADR-016) refined P1 and P0 share-card design
  while TASK-001 sat unassigned. The pattern in RK-008 is already happening.
- Doc debt on the hackathon track: TASK-009 (rename to Lilt, 58 mentions in 25 docs per ADR-011:54), TASK-010
  (rules page, PRD Q5), and TASK-013 (`adapt-project` for accounts, backend, location and UGC).
  `capabilities.md` §1 still lists AI/LLM as active (stale vs ADR-006) and omits accounts and backend.
- Stale lines in `sitemap.md`: it still says "Accounts and sign-in (P1 only)" at :102, and "no accounts" at
  :81-88, against S-010 at :33.

**Release-track lead times (the real gate):**
- **Google Play, personal account.**
  - A closed test is required, with at least 12 testers opted in for at least 14 consecutive days.
  - Google usually reviews the production application in seven days or less.
  - `[verified: Google Play Help, support.google.com/googleplay/android-developer/answer/14151465, fetched
    2026-10-26; the page shows no last-updated date; re-verify in Play Console]`
- **Apple organization account.** A D-U-N-S number takes up to 5 business days, plus up to 2 business days to
  sync to Apple. `[verified, secondary: Apple D-U-N-S support page via search summary, 2026-10-26; one
  third-party guide says up to 14 business days; re-verify]`
- **iOS build.** It needs a Mac or a cloud build service, and the dev machine is Windows (ADR-002:57).
- **Legal review** is an open gate for any launch beyond the challenge (ADR-004:39).
- **Trademark search** is owed before the store launch (ADR-011:63).
- **Shipaton.** ADR-011 and your brand notes treat the RevenueCat Shipaton Design Award as the store-release
  goal. RevenueCat's announcement page, fetched 2026-10-26, says apps must be released between 1 August and
  30 September. A third-party summary (theapplaunchpad.com, 2026-10) gives a 30 September submission deadline
  and winners on 21 October. It requires a RevenueCat SDK integration for core awards. If that is right, the
  2026 window has closed and no external deadline pulls the store release forward. Confirm this, because it
  changes the urgency of everything below. `[verified: official page for the window; secondary for the deadline
  and winners dates]`

## 3. Options

### Q2 sequencing options (owner-days are `[assumption]`, since team size is unknown)

| Option | Cost | Protects | Risks and what it displaces |
|---|---|---|---|
| **(a) Finalize all release docs and screens, then build** | 10 to 12 owner-days (release PRD 2, BRD 1.5, sitemap and stories 1.5, 8 to 10 frames and review 2, store pass 1.5, pricing 1, reviews 1) | Release clarity | Build starts around 11-09/10, leaving about 3 working days to the freeze. TASK-001 slips about 10 days past 10-30. Sessions, Q9 and TASK-009/013 are displaced. Effectively the submission is displaced, and prd.md:420 already names that outcome. The documents would also be written before the evidence (sessions, payer talks) that decides the primary revenue model, so they would be rewritten. **Reject.** |
| **(b) Time-box 3 days of release work first** | 3 owner-days (21% of the 14 pre-freeze days) | A thin release baseline | Skeleton moves 10-30 to about 11-02. The cut falls on the end of the build order (F-015, F-008, F-004; prd.md:420). 3 days cannot deliver "finalized", so it produces drafts to redo. **Reject.** |
| **(c) Build first, write release docs "in the gaps" or after the challenge** | 0 up front, plus about 2 to 3 days leaking into build time `[assumption]` | The build | Gaps do not exist at this stage. Doing nothing until after 12-11 loses the Google 14-day clock plus review, about 3 weeks, and leaves the finals Q&A without a coherent business answer. |
| **(d) Recommended: build first; ≤1.5 owner-days before freeze; capped track 11-21 to 12-04** | ≤8 owner-days total | The build, the lead-time clocks, and fresh evidence for the release docs | The 1.5 days sit around the freeze, so gate them (below). Finals prep must win any clash from 12-05. |

**Gates for (d):**
- **By 11-06 (Q9 checkpoint),** only release-side work: the BRD edit and ADR below (≤0.5 day). This is a scope
  checkpoint: if TASK-001, 002, 003 are not merged and Together has no working backend, apply the cut list and
  skip the spike.
- **11-09 to 11-13,** only if the core loop is demoable: the logistics spike, ≤1 day. Create the developer
  account(s), choose the app ID, upload an `.aab` to an internal/closed track, and recruit at least 12 testers,
  planning for 15 or more `[assumption]` for dropouts. These testers can double as the BO-002 user sessions.
- **If the spike is skipped,** the Play clock starts after 11-21 instead. A 14-day test plus review then ends
  around 12-05 to 12-12 `[assumption]`, which lands in finals week. That is a cost, not a disaster.
- **From 12-05,** finalist preparation takes priority over the release track.

### Q1 stance options for the hackathon BRD

| Stance | Verdict |
|---|---|
| Stay silent on freemium (current BRD wording) | Weak. The release plan then contradicts "End users free to them in all three options" (brd.md:98) and "Users (free)" (pitch/business-model-canvas.md:14), and the finals Q&A will find it. |
| Present freemium as the model | Reject. It leads with an untested consumer story and skips the path to pilot the criterion scores. |
| **One product, two unvalidated revenue paths, pilot path leads** | **Recommended.** |

**Suggested text for BRD §5 (replace the free-to-users row and add a row):**

> *Business model (hypotheses, none validated). In the challenge Lilt is free to users and nothing is billed. Two
> revenue paths are under test. (1) Payer-funded pilots: an employer, insurer or health fund, or public health
> body funds access for its members. This is what we are testing in conversations before the finals. (2) An
> optional user subscription in the later store release. What it would include and what it would cost are not
> decided, and nothing is built for it. The core comeback loop (suggest, reflect, come back, pause, export,
> delete) is not a paywall candidate. We will report what we learn, including a "no".*

**Evidence to gather before the finals (by 12-07):**
- **Payers (E1).** Run at least one conversation per payer option (the BRD target, brd.md:107). Sharpen the
  outcome: record who owns the budget, what outcome they would fund, a pilot size and length they would
  consider, what data they would need, and their procurement blockers. Grade each as none, interest, named
  contact or LOI. A count of conversations alone is a vanity metric.
- **Consumers (E2).** In the sessions (at least 5, brd.md:105), ask unprompted: "If part of this cost money,
  which part?" and "What would you never accept paying for?" Record counts. This is stated preference from a
  convenience sample, so never convert it to a conversion rate.
- **Cost to serve (E3).** Measure Firebase usage per active user from the sessions. Any subscription needs it.
  Spark limits are unverified (ADR-009 says Spark, ops.md:60 assumes Blaze).
- **Decision rule (E4).** The owner sets it beforehand `[assumption: for example, no named contact across three
  payer conversations by 12-07 and no feature named by session participants means the release BRD leads with
  direct-to-user only]`.

**What to avoid claiming:**
- Market size or TAM (the canvas already says do not quote until sourced, business-model-canvas.md:9-10).
- Willingness to pay, conversion, revenue, price points, trial or tier structure.
- Platform fee splits. Search results on 2026-10-26 conflict on Google's 2026 subscription rate (10% vs 15%,
  with a possible 5% billing fee), so any fee is unusable until verified.
- That "employers, insurers or governments want this".
- "Free forever" or "no paid features", which the release plan would break.
- "Privacy-preserving aggregate outcomes for payers" as an existing capability. No mechanism exists: BR-015
  allows no analytics with personal data (prd.md:176) and BR-025 keeps health data off the server (prd.md:182).
  Present it as "pilot reporting designed with the payer, opt-in".
- Cloud backup as part of the model. It would put health data on a server, which reverses the privacy story
  (ADR-004:31-32, ADR-009:44) and needs an ADR that amends those decisions.
- Any "validated" or clinical-effect language.

### Q3 release track, defined (the recommended option)

**Total cap: 8 owner-days. Exit: 12-04.** Drafting can be delegated to agents, but owner review is the
bottleneck.

| Step | When | Cap | Content |
|---|---|---|---|
| 0. Hackathon BRD edit plus ADR-017 | by 11-06 | 0.5 d | BRD §5 text above. ADR-017 "Release model: two revenue hypotheses; free core loop; nothing built in the challenge". Fix brd.md:98, canvas :14 and :34. No existing ADR is superseded. |
| 1. Logistics spike | 11-09 to 11-13, gated | 1 d | Developer account(s), app ID, first `.aab` to a test track, tester pool. |
| 2. `docs/release-plan.md` (single doc) | 11-21 to 12-04 | 2 d | Below. |
| 3. Release screens | 11-21 to 12-04 | 2 d | Below. |
| 4. Store listing and compliance pass | 11-21 to 12-04 | 1 d | Re-verify every row of `store-compliance.md` with a dated source. Fill the listing fields that do not depend on price (store-listing.md is all TBD). Privacy policy outline. Map data to the Apple App Privacy and Google Data safety forms. Review notes and a demo account (the account itself kept out of the repo). |
| 5. Payments `adapt-project` (docs only) | 11-21 to 12-04 | 1 d, with the assumptions table | Add payments to capabilities.md §1, TC placeholders for success, failure, cancel and restore, and a billing compliance row. The provider ADR stays "not decided". |

**One document, not a forked Release PRD and BRD.** The repo's rule is one owner per concern. A second PRD and
BRD invites drift, and the Rhythm to Lilt rename already shows the cost (58 mentions in 25 docs, ADR-011:54). If
you still want separate files, accept a "release delta" header on each and a rule that shared features reference
F-### instead of copying.

**`docs/release-plan.md` must contain:**
- **§1 Release objectives and revenue hypotheses.** A table with a "Validated?" column, all "no", and an
  evidence-needed column. Candidates: H-R1 optional user subscription; H-R2 payer-funded pilot; H-R3 hybrid.
  Add a kill criterion for each.
- **§2 Guardrails (proposed, owner to confirm).**
  - The core comeback loop, pause, export and delete are never paywalled.
  - A subscription ending shows neutral copy with no loss wording, and data and export stay intact (BR-007).
  - Deleting an account does not cancel a store subscription, and the app says so.
- **§3 Release-only features (R-###).** User stories with acceptance stubs, marked "to validate". Placeholder
  BR-030+ rules, marked proposed.
- **§4 Release sitemap delta.** New S-IDs and routes.
- **§5 Lead-time schedule.** Accounts, Play closed test, legal review, trademark search, iOS build route, App
  Review.
- **§6 Open decisions.**

**Must stay "to validate":** price, tiers, trial, annual vs monthly, regional pricing; which features are paid;
conversion and willingness-to-pay assumptions; payer pricing and pilot terms; reporting design for payers; store
fee share; refund handling.

**Must not be decided yet:** the billing provider (needs an ADR, capabilities.md:27); paywall placement; cloud
backup or sync; funnel analytics (a conversion funnel conflicts with BR-015, so it needs an ADR plus
privacy-policy and store-label changes); legal entity and tax; iOS timing and Watch; ads; localisation.

**Screens added beyond the current P0 and P1 frames** (8 to 10 frames on a separate Figma page "Release · not in
challenge", excluded from any submission export, so judges do not see a paywall that contradicts the "free in
the challenge" story):
1. **Upgrade sheet.** States: loading prices, offline or unavailable, purchase pending, success, cancelled
   (neutral), failed. Terms, privacy and restore links. A close ×.
2. **Restore purchases.** A Settings row, with results "restored" and "nothing found".
3. **Manage subscription.** A Settings row showing status and renewal from the store, with a deep link to the
   store's subscription page.
4. **Subscription-ended state.** Neutral wording, no loss language.
5. **Account deletion additions.** Extend 7.6/S-104 with the "this does not cancel your subscription" note.
   Google Play also needs a public web page to request deletion, in addition to the in-app path
   (store-compliance.md:29, unverified).
6. **Sign in with Apple** on the sign-in screen for iOS. The store-compliance row (:16, unverified) says it
   applies when other social logins are offered, and ADR-009 uses Google sign-in.
7. **Privacy, terms and subscription terms links** in Settings.
8. **Gated-feature teaser.** Do not draw it. It depends on what is gated, which is undecided.

## 4. Why

The decision turns on one fact: 14 working days to the freeze, no code, and a P0 the PRD itself calls
scope-heavy. Every day spent on release documents comes out of the end of the build order, which holds the demo
features judges see. The release documents also cannot be honestly final yet. Whether the primary revenue model
is user-paid or payer-funded is undecided, and the two pull the product in opposite directions: payers want
cohort reporting and are not users, consumers want individual features and privacy. The sessions and payer talks
(11-13 and 12-07) will inform that choice, so the documents written after them will be correct the first time.

What genuinely gates shipping is lead time. Starting the Google closed-test clock, creating accounts, and
booking legal and trademark checks early cost little and shorten the release by weeks. Finalized documents do
not. The tester pool built for the user sessions can double as the Google closed-test pool.

## 5. Risks and assumptions

| # | Risk or assumption | Owner | Date | Tag |
|---|---|---|---|---|
| 1 | No code 18 days before the freeze. TASK-001 is unassigned. | Shieryl | Assign 10-27; skeleton live 10-30 | `[verified: implementation-plan.md:22, brd.md:115]` |
| 2 | Scope still growing: ADR-013 to ADR-016 in two days while the build has not started. | Shieryl | Scope lock at 11-06 with the cut list in prd.md:420 | `[verified: ADR dates 2026-10-26]` |
| 3 | Two PRD/BRD documents drift. Hackathon docs are already stale (Rhythm/Lilt, S-002, capabilities §1). | Claude for Shieryl | TASK-009 and 013 before the freeze; release docs at 12-04 | `[verified: ADR-011:54, sitemap.md:102]` |
| 4 | The payer value proposition promises aggregate outcomes, but no reporting path exists and BR-015/BR-025 forbid one. | Shieryl | Reword before the deck, 11-18 | `[verified: prd.md:176, :182]` |
| 5 | Consumer subscription collides with the "free to users" claim, and cloud backup collides with "data stays on your phone". | Shieryl | ADR-017 by 11-06; backup ADR only if chosen, after 12-11 | `[verified: brd.md:98, ADR-004:31-32]` |
| 6 | Google Play lead time: 12 testers, 14 consecutive days, review in about 7 days. Row unverified in the repo. | Shieryl | Start by 11-13 if gated in, else 11-21 | `[verified: Google Play Help 2026-10-26, no page date; re-verify]` |
| 7 | Account type undecided. Apple organization needs D-U-N-S, with 5 to 7 business days of lead time. Personal vs organization also changes whether the Google test applies (release.md:20). | Shieryl | Decide by 11-06 | `[verified, secondary: 2026-10-26]` |
| 8 | Shipaton 2026 window may have closed on 30 September. | Shieryl | Confirm by 10-28 | `[verified: RevenueCat page 2026-10-26; deadline from secondary source]` |
| 9 | Legal review and trademark search are open gates before any launch. Lead times unknown. | Shieryl | Book by 11-21 | `[verified: ADR-004:39, ADR-011:63; lead time is an assumption]` |
| 10 | Store billing rules (IAP requirement, fees) are unverified. Sources on 2026 fees conflict. | Claude for Shieryl | In the 12-04 compliance pass | `[assumption] STALE — re-verify` |
| 11 | The owner is the review bottleneck for docs, Figma and decisions. Figma MCP call limits constrain screen work (design-process memory, 2026-10-24). | Shieryl | Count builders and hours by 10-28 | `[assumption]` |
| 12 | Employer outside-work or IP policy, since the owner is an Incubeta employee, should be confirmed before any commercial store account. Outside this memo. | Shieryl | Before creating a store account | `[assumption]` |
| 13 | Finals prep (12-07 to 12-11) collides with the release track. | Shieryl | Hard stop 12-04 | `[assumption]` |

## 6. Needs the owner

1. **Sequencing?** Recommended: option (d), with the gates in section 3.
2. **Hackathon BRD stance?** Recommended: the text in section 3, pilot path leading, consumer subscription as a
   labelled release hypothesis.
3. **One `docs/release-plan.md` plus ADR-017, or separate Release PRD and BRD?** Recommended: the single
   document.
4. **Is the Shipaton Design Award goal still live?** Recommended: confirm against the Devpost rules. If it
   closed, drop it as a driver in ADR-011 consequences, with a note rather than an edit.
5. **Developer account type and who holds it?** Recommended: decide by 11-06. Personal is cheaper but carries the
   14-day closed test. Organization needs a D-U-N-S number. Also confirm the Incubeta policy question (risk 12).
6. **App ID?** Recommended: pick a neutral reverse-domain ID you control when TASK-001 creates the app. Changing
   it after release means a new store listing (general platform behaviour, `[assumption: verify]`).
7. **Which kill criteria and thresholds for E4?** Recommended: set them before the sessions start, not after.
8. **Cloud backup?** Recommended: keep it out of the pitch and out of release 1.0 unless an ADR deliberately
   amends BR-015 and BR-025.
9. **Run the logistics spike before the freeze?** Recommended: yes, only if the core loop is demoable by 11-09.
   Decide at the 11-06 checkpoint.
10. **Who owns TASK-001 today?** Recommended: assign it now. It is the critical path for 7 other tasks.

## 7. Not in scope

- Price points, tiers, trial design, and what the subscription includes.
- The billing provider (RevenueCat vs native), which needs its own ADR.
- Which payer to pursue first.
- The legal review, trademark search and privacy-policy text.
- The Q9 calendar-sync decision, the cut list, and feature-level estimates.
- iOS and Apple Watch delivery plans.
- Any edit to an accepted ADR. This memo recommends adding ADR-017 and supersedes none.
- Any competitor comparison.

## Status notes (added by Claude, not the memo)

- Owner decisions, 2026-10-27, on section 6: (1) sequencing: option (d); (2) BRD stance and the single
  release-plan document: agreed; (4) Shipaton: no longer a goal ("so you have something to look forward"); it is
  dropped as a driver here, with ADR-011 left unedited; (5) developer accounts: the team will create its own,
  account type not yet stated; (6) app ID: chosen when TASK-001 creates the app; (7) kill criteria: the
  recommended defaults, now written into BRD §5; (8) cloud backup: stays out of the pitch and release 1.0;
  (9) logistics spike: decision rule requested from the project manager role (see its memo when saved);
  (10) TASK-001 is owned by Shieryl. Employer policy (memo risk 12): the owner states they own the project and
  has decided to proceed; Claude has not verified any employment terms and treats the item as closed by the
  owner. Still open: the developer account type.
- Owner decisions, 2026-10-26: agreed with option (d), the BRD stance and the single release-plan document.
- Done: BRD §5 and the business model canvas updated; ADR-017 written.
- Not yet decided by the owner: items 4 to 10 in section 6 (Shipaton, account type and the Incubeta policy check,
  app ID, kill criteria, cloud backup, the logistics spike, who owns TASK-001).
- Not done: `docs/release-plan.md`, the release screens, the store-compliance pass, the payments `adapt-project`
  step, TASK-009 and TASK-013, and the stale sitemap and capabilities lines the memo found.
