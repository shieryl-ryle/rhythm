# Decision memo: logistics spike and lead-time work — 2026-10-27

Written by the senior project manager role (a general agent following `.claude/agents/senior-project-manager.md`,
read-only). Kept as written. The platform facts come from pages the agent fetched on 2026-10-27; none showed a
last-updated date except Flutter's iOS page (2026-07-31). Anything it could not verify is tagged `[assumption]`
or `STALE`. Claude has not independently checked them.

## Recommendation and verdict

**Verdict: GO WITH CONDITIONS.** Run about 3.5 hours of near-free lead-time work now, outside the gate. That
covers the employer-policy check, a name search, the account-type decision and creating the Google Play
account. Keep the rest of the spike gated on the 2026-11-06 checkpoint, with a pre-committed rule so 11-06 is a
lookup, not a debate.

Sharper framing: Shipaton is gone, so no external date pulls a store release forward. The spike is worth its
cost for two reasons only:
- The tester pool is also the BO-002 user-session pool (brd.md:128, ≥5 sessions).
- It starts Google's 14-day clock about two weeks earlier.

Neither justifies putting the freeze at risk, so the gate stays strict.

## 1. Decision rule for 2026-11-06 (Friday)

"Merged" means on `main` with CI green. The "walkable loop" test is: on a physical Android phone, a person who is
not the builder completes consent, My Starting Point, Today, pick a step, reflect, then sees what changed (F-001
to F-003). It runs from the web or APK build with no help, in about 3 minutes, and My rhythm and the grid are
reachable. The loop's source is prd.md:420 (core loop F-001..F-003, F-006, F-007).

| Outcome | Must all be true on 11-06 | Owner action |
|---|---|---|
| **GO** (full spike, ≤1 day, 11-09 to 11-13) | TASK-001 live (web build on Firebase Hosting, release APK installs, `flutter analyze` and the widget test green, per implementation-plan.md:22). TASK-002 and TASK-003 merged. TASK-005 merged and the loop is walkable. No P0 task on the critical path is blocked. If Together (TASK-014 and 015) is behind, the cut-list decision is already written down (prd.md:420: cut from F-015, F-008, F-004). | Run section 3 in full. Cap it at 1 owner-day, of which ≤0.5 day is gated. |
| **GO PARTIALLY** (≤0.25 day, "pipe only") | TASK-001 live and TASK-002 and 003 merged, but TASK-005 not yet walkable. | Do only steps 1 to 4 of section 3: lock the app ID, create the app record, upload the signed `.aab` to **Internal** testing with you plus one teammate. No recruitment. Trigger recruitment and the Closed track the day TASK-005 becomes walkable, and no later than Mon 11-16 `[assumption]`. After that, apply the SKIP path. |
| **SKIP** | TASK-001 not live, or TASK-002 or 003 not merged, or TASK-005 not started. | Apply the prd.md:420 cut list. Do no logistics work. The Play clock starts after 11-21. The ungated items (below) stay done, and nothing is wasted. |

Early warning: if TASK-001 is not live by Mon 11-02, tell the team that day. Do not wait for 11-06.

Record the outcome as one line in implementation-plan.md on 11-06, with the date and which row applied.

## 2. Start now, before the checkpoint

| Item | Earliest start | Owner time | Risk of waiting | Verified? |
|---|---|---|---|---|
| **Employer outside-work and IP policy check** | Today, 10-27. It gates everything below. | 0.5 h: read the policy, then email HR or your manager in writing. Do not use Incubeta's name, domain, payment method or D-U-N-S for these accounts without written approval. | A store seller name, listing and IP ownership are public and awkward to unwind. This is the one item that can invalidate the rest. | I have no access to the policy. `[assumption]` |
| **Account type decision** | By 10-30 | 0.5 h to read, then decide | A wrong choice means re-creating the account and losing clock days. | See conflict below |
| **Play "health app" classification** | Before creating the account | 0.25 h | Same as above | Official, undated page |
| **Name search for "Lilt"** | This week | 1.5 h, a free knockout search of public trademark databases. Not legal advice. | Brand surface grows daily: the deck is due 11-18, and ADR-011:54 shows a rename already cost 58 mentions in 25 docs. My search on 2026-10-27 found Lilt, an established AI translation software company (Wikipedia and VentureBeat results, page dates not retrieved). Same name, adjacent software class: this may be a real conflict. The search found no Lilt wellness app on either store. | Name overlap `[verified, secondary]`. Legal effect `[assumption]`. |
| **Google Play account creation** (the account only, not the app record) | 10-28 to 11-02, after the policy check | About 1 h, plus a verification wait. The fee is `[assumption]` about US$25, STALE: Google's pages did not show it. | The verification duration is not stated by Google's pages I fetched. If it takes days, it would eat the spike week. Create the app record only after the app ID is final. | Verification timing unverified |
| **Apple enrolment** | Not before 11-21 | Individual: no wait, US$99 per year (Apple enrolment page). Organization: D-U-N-S, up to 5 business days plus up to 2 for Apple sync, so about 7 business days. Free through D&B. Escalate after 2 weeks (Apple D-U-N-S page). | Low. iOS is out of scope for the submission (ADR-002:32) and is P1 (prd.md:407). Nothing dated needs Apple before 12-04. | Official, undated |
| **iOS build route on Windows** | 11-21, as a release-plan §5 decision | 1 h to choose | Low | Flutter's iOS page (updated 2026-07-31) says a Mac with Xcode is required. Codemagic CLI is its only named alternative. Pricing and free tier `[assumption]`, unchecked. |

**Account-type conflict (the main finding):**
- Google's official page says organization registration is **mandatory** for health apps, including medical and
  human-subjects-research apps (Google "Choosing a developer account type", answer/13634885, fetched
  2026-10-27). Play's Health apps policy (answer/12261419) is broad: any app with "health-related features or
  information". It does not say whether a wellness planner counts.
- The 12 testers for 14 consecutive days rule is documented on Google's page for **personal accounts created
  after 2023-11-13** (answer/14151465).
- Our docs assume organization accounts are exempt (release.md:20, store-compliance.md:26). I found that
  exemption only in third-party guides, not on Google's pages. **STALE: do not plan around it.**
- Organization accounts require a D-U-N-S number and a recognized legal entity. Apple says DBAs and trade names
  are rejected. The team likely has no such entity `[assumption]`.
- The trap: choosing personal to avoid D-U-N-S, then being classed as health and forced to an organization
  account.
- Mitigation: read Google's "Health app categories" article (about 15 minutes) before creating the account. If
  it is unclear, ask Play support in writing.
- Also decide who holds the account. A single personal holder is a single point of failure, so name a backup
  and use least-privilege roles for others.

## 3. Minimum viable spike (about 4.5 h gated, plus the 3.5 h ungated above)

| # | Step | Owner time `[assumption]` |
|---|---|---|
| 1 | Confirm the app ID in the build matches the choice. Use a neutral reverse-domain ID you control, not containing the brand name, since the name search is pending. | 0.25 h |
| 2 | Create the Play Console app record (free app, placeholder name). Note which declarations Play demands before it accepts a test build. This is an unknown the spike answers. | 0.5 h |
| 3 | Enable Play App Signing. Back up the upload keystore outside the repo (release.md:34). | 0.5 h |
| 4 | `flutter build appbundle --release`, upload to Closed testing, install from the Play link, smoke test (release.md:47-50). | 0.75 h |
| 5 | Create the tester list as a Google Group or Play Console email list. | 0.25 h |
| 6 | Recruit 20 testers, so 12 remain after dropouts (`[assumption]`; Google's page says only that early opt-outs reset a tester's days). | 1.5 h |
| 7 | Log the app ID, account type, clock start date and keystore location in the ops notes. Record names and secrets nowhere. | 0.25 h |

**What it proves:** the accounts work; a signed `.aab` reaches testers on the real app ID; the Play pipeline and
its blocking declarations are known; the 14-day clock is running.

**What it deliberately does not do:** Apple or iOS; production submission; store listing, screenshots or a final
privacy policy; billing, analytics or crash SDKs.

**Clock arithmetic.**

| Scenario | Clock starts | Earliest to apply for production | Plausible live date |
|---|---|---|---|
| GO | 11-13 | about 11-27 | about 12-04 |
| SKIP | 11-21 | about 12-05 | about 12-12 |

- Both "live" dates assume review in about 7 days. That figure comes from the 10-26 memo and today's fetch of the
  Google page did not show it, so it is `[assumption]`.
- Closed-test **sessions** also need the web build. iPhone users cannot join a Play test.

**How recruitment doubles as the user sessions with no personal data in the repo:**
- Send the invite by 11-02, once the skeleton is live. It asks for two things: a 20-minute session between 11-09
  and 11-13, and a 14-day opt-in as a tester.
- Collect emails only in the Google Group or Play Console, never in the repo, docs, chat or agent prompts.
- The invite says in plain words that joining shares the person's Google account email with you, that notes are
  anonymous, and that they can leave at any time. On leaving you delete their notes and remove them from the
  list.
- The repo holds counts and pseudonyms only (P01, P02, ...). The wallet questions are in brd.md:113-114, and
  answers are recorded as counts.
- Sample bias: this is a convenience sample of Android users. Do not recruit from Incubeta client lists, and
  check the employer policy before recruiting colleagues. Label results as stated preference (brd.md:121-122).

## 4. Do NOT do before the freeze (11-13)

- Do not pay for Apple, buy a third-party D-U-N-S service (D&B is free), or set up any iOS cloud build.
- Do not buy testers. It defeats the evidence and may raise policy questions `[assumption]`.
- Do not write store listing copy, take screenshots, or build the release-only Figma screens. Those belong to
  11-21 to 12-04.
- Do not add billing, RevenueCat or IAP, or any analytics or crash SDK that handles personal data (BR-015).
- Do not change the app ID after the first upload.
- Do not submit to production or open testing.
- Do not write more ADRs refining P1. ADR-013 to ADR-016 were written while TASK-001 sat unassigned.
- Do not use Incubeta's identity for any account without written approval.

## 5. Risks

| # | Risk | Owner | Date |
|---|---|---|---|
| 1 | Employer policy blocks or limits accounts or sessions. | Shieryl | Check today. Accounts only after it clears. |
| 2 | TASK-001 slips past 10-30. This is the critical path for TASK-002 to 006 and 014. | Shieryl | Flag by 11-02. Checkpoint 11-06. |
| 3 | Wrong account type (health classification, no legal entity). | Shieryl | Decide by 10-30. |
| 4 | Play verification is slow, or declarations block the first test build. | Shieryl | Account by 11-02. The spike surfaces the declarations by 11-10. |
| 5 | Tester dropout below 12 before day 14 resets the count. | Shieryl (Dzelle helps) | Recruit 20 by 11-13. Check at day 7. |
| 6 | "Lilt" name conflict forces a rename after the deck and share cards are made. | Shieryl | Knockout search by 11-04. Decide before the 11-18 deck. |
| 7 | The spike eats freeze time. | Shieryl | Hard cap 1 day. The 11-06 rule decides. |
| 8 | Finals prep collides with the release track. | Shieryl | Release track stops 12-04. Finals prep wins from 12-05. |
| 9 | The Play production review runs longer than about 7 days. | Shieryl | Re-check on the clock-start date `[assumption]`. |

## Owner decisions needed

1. Accept the 11-06 rule table and its three outcomes.
2. Run the ungated items now: policy check, health classification, name search, account type, Play account.
3. Pick the account type and the account holder by 10-30.

## Status notes (added by Claude, not the memo)

- Owner decisions, 2026-10-27: (1) asked what the three-outcome rule means; it is written into
  `docs/implementation-plan.md` §2; (2) the ungated items are to be run, the owner is the person in charge of
  all of them; (3) the owner holds the developer account and Dzelle is the backup. The account type (personal or
  organization) is still undecided and must be decided by 2026-10-30, after reading Google's health-app
  articles. The employer-policy item was closed by the owner on 2026-10-27 (see the earlier memo's notes).
- The "Lilt" name conflict is the same risk ADR-011 already records (Lilt, Inc. holds LILT for software
  development services); the knockout search is owed by 2026-11-04.
