# Senior review before TASK-005 — 2026-10-27

Written by the senior reviewer (the ui-reviewer agent, read-only). Kept as written, apart from this header. The
owner agreed with it on 2026-10-27 ("agree with senior reviewer"). The three questions were put by Claude:
(1) the "nothing fits today" state on Today S-004, (2) the build order for TASK-005, (3) the build and review
process. Claude had wrongly said the design had no frame for question 1; the reviewer corrected that.

**Frames the reviewer looked at:** 9.3 Today · nothing fits (163:5310, plus its layer tree), 2.3 Today (142:4592),
2.4 Something else 2 of 3 (142:4741), 2.7 (142:5157), 3.3 Not today (152:4172), 2.8 Paused (142:5317), 9.2 Support
message (163:5288), 1.13 Why it matters (142:4229), 1.14 Anything to leave out? (142:4259), 1.16 Today day 1
(142:4295).

---

## Question 1: "Nothing fits today" on Today S-004

**Does a frame exist? Yes, partly. The premise "the design has no frame" is wrong.**
- Frame **9.3 Today · nothing fits (163:5310)** exists. It is in build-scope §2 (Tier A), in sitemap S-004 required
  states ("empty (all excluded or nothing fits)"), and in UF-002 and EV-003.
- docs/methods.md EQ-003 still says "the design has no frame for it yet". That line is stale and should be
  corrected.
- What 9.3 shows: header and grid card, date, chips "10 min" and "Low energy", title "Nothing fits these filters",
  body "Try a lighter option, or change what you leave out.", filled button "Show a lighter option", text button
  "Change what I leave out", the nav bar.

**What 9.3 gets wrong or leaves out:**
1. **High: the primary button is a dead end in the exact case drawn.** Lighter mode means at most 10 minutes and low
   energy (`ranking.dart`, EQ-003, UF-005). That is the same as the 10 min and Low energy chips on the frame. It
   returns the same empty list.
2. **High: there is no pause on it.** BR-006 says pause is available on every suggestion screen, within 2 taps. 9.3
   has no "Not today".
3. **Med: it only covers one cause.** "All left out" and "library empty" need different words and a different
   primary. The sitemap lists both.
4. **Med: "Change what I leave out" has no agreed destination.** user-flow EV-003 says S-003. build-scope says
   S-018, which is not drawn. Ruling: open `/setup?edit=1` on the leave-out step (frame 1.14), with "Save" instead
   of "Show me today". That screen exists after TASK-005(a).
5. **Low: the title style is off.** It is bold Geist. Screen titles on 2.3 and 2.8 are Instrument Serif italic.
6. **Low: there is no add-your-own path.** The person has nothing to do. BR-005 allows a plan they made themselves.

**How often does it happen? Much less than you think.** This is from reading the library JSON (v2026-10-27.2). The
reviewer did not run the ranker.
- The example (10 min plus low energy) leaves something. `act_other_seated_moves`, `act_yoga_stretch_10` and
  `act_walk_10` all qualify.
- Several of the 10-minute-or-less, low-energy actions are solo, indoor, free and have no `needs_*` tag:
  `act_other_stretch_break`, `act_other_seated_breathing`, `act_other_seated_moves` and `act_yoga_stretch_10`. None
  carries a tag that any of the four leave-out chips on 1.14 removes (after dark, team sports, high impact,
  swimming).
- "Leaves out everything they follow" does not empty the list. Candidates come from the whole library.
- So **"none" is not reachable from the UI as drawn.** It can only happen if S-018 lets people leave out arbitrary
  activities, or if the library changes.
- **"Fewer than 3" is reachable.** For example, access = none, dark hours and "after dark" left out gives about 2
  options.
- Build the empty state anyway. It is required, cheap, and tested with a fake ranker. The state you can actually
  show in a demo is "fewer than 3".

**Spec (the builder can follow this; no new frame needed).** Detection is two pure calls: run `rankOptions` with the
person's chips; if the result is non-empty, show the options. If it is empty, run it again with the time and energy
chips removed: non-empty means state **N2** (the chips are the cause); still empty means state **N3** (leave-outs,
access or library). Layout is frame 9.3's slots: header, grid card, date, serif-italic title, body, one filled
primary, text buttons. Rules for all states:
- BR-005: nothing is auto-planned. The relax button only shows options. The person still taps "I'll try this".
- BR-004: any option shown afterwards gets its normal reason.
- BR-011: never relax leave-outs or access automatically. Only today's time and energy chips may change.
- BR-006: "Not today" stays. S-103 must hide its "Something lighter" row when lighter would be empty.
- BR-007 and DESIGN.md Do/Don't: no red or warning icon; nothing is written onto today's grid tile; no "ran out"
  wording.
- Remove "Show a lighter option" from this state. It cannot help.
- Hide the chips in N3. They cannot fix it, so tapping them is a trap.
- 200% text: the buttons stack at full width and the title wraps. Mark the title as a live region.
- Day 1 (1.16) uses the same states, with the state title replacing "Your first ideas".

| | N2: time or energy is the cause | N3: nothing even without the chips |
|---|---|---|
| Title (Instrument Serif italic) | Nothing fits those choices | Nothing to suggest right now |
| Body | Change the time or energy, or add something of your own. | Your leave-out and access choices cover everything we have. You can change them any time. |
| Primary (filled) | "Show options up to {n} min" (raise time first: 20, 30, 45). If energy is the blocker: "Show {medium or high}-energy options". If both: "Show options for any time and energy". | Review my choices (opens `/setup?edit=1` at the leave-out step) |
| Text button 1 | Add an activity (opens S-109, same label as Today) | Add an activity |
| Text button 2 | Not today (opens S-103) | Not today |

Tapping the N2 primary sets the chip for today only, as the PRD says chips do. The person can see and undo it.

**Fewer than 3 (a proposal; owner to confirm; the owner agreed on 2026-10-27):**
- Show the counter "1 of k" only when k is 2 or more.
- With k = 1, hide the counter and "Something else".
- On the last option, hide "Something else" instead of cycling back. Reason: EQ-010 counts every "Something else" as
  a not-accepted offer, so cycling inflates the decline rate.
- Keep "Not today" in the same position so nothing jumps.

**A blocker for TASK-005(b), outside the question.** Frames 2.3 and 2.4 swap "1 of 3" to "2 of 3" inside one
activity (Running both times). But `rankOptions` and EQ-003 return at most one option per activity, so "3" means
three different activities. PRD F-002 also describes one card per followed activity, and `rankOptions` has no
per-activity mode. A builder cannot resolve this from the docs. design-reviewer or the owner must decide before (b)
starts. Suggestion: the hero cycles the ranker's top 3, and the compact cards stay as the other followed activities.
Also, the titles on frames 2.3, 2.4 and 2.7 are sample copy that differs from the library ("Run-walk around the
park" versus "Run-walk in your neighbourhood"). The builder must use the library text.

**Could not verify:** 9.3's prototype links (reaction data is not readable); any dark or 200% version of 9.3 (none
exists); the actual ranker output; how S-018 will limit leave-outs.

**New frame before build? No.** A written spec is enough. Put it in sitemap S-004 / UF-002 EV-003, fix the stale
EQ-003 line, and update Figma 9.3 after the build (primary label, second text button, serif title).

**Verdict Q1: APPROVE WITH CHANGES.** The changes are the written spec, replacing the dead-end "lighter" button,
adding pause and add-an-activity, and fixing the stale EQ-003 sentence.

---

## Question 2: Build order for TASK-005

**The proposed order (a setup, b Today, c Reflection, d support message) is mostly right, with four changes.**

1. **S-090 cannot be last.** PRD F-001 puts free text in setup ("Can't find it? Type it", frames 1.6 and 9.1). BR-003
   says red-flag text gets the fixed support message and no suggestion. The detector is already merged, and S-090 is
   a static three-button screen. Rule: S-090, the guard and its tests ship in the same PR as the first free-text
   field. Do it as the first commit of that PR. It is also a cheap, visible safety proof for judges.
   - Open item: 9.2 says "call your local emergency number" but has call buttons. Someone must decide what each
     button dials, by locale. The reviewer did not verify any numbers. Do not hard-code one without the owner
     choosing.
2. **Add a small PR 0 first (about a day): fonts, text styles and shared widgets.**
   - Instrument Serif is not bundled. `pubspec.yaml` declares only Geist, so every screen title would differ from
     Figma. Unbounded is also missing.
   - `theme.dart` only styles a filled button and a card. One-screen-per-invocation builders would each reinvent
     chips, sheets and text buttons.
   - Build once, against Figma components (Button 102:1048, Chip 102:1055, Sheet 135:1149, Nav bar 103:1121, Header
     135:1176, Segmented 216:3823): primary, secondary and text buttons, the 32/48 dp chip, segmented control, sheet
     scaffold (32% scrim, 48 dp ×), the 4-tab nav shell and header. TC-045 is then tested once per component.
3. **Split (a) and (b), and add the profile redirect.**
   - (a) is about 16 steps, with 4 paths. If time is tight, ship the shared spine first (1.3/1.4, then 1.12 to 1.15)
     and the path follow-ups after. "Pick up again" is the primary persona's path (UJ-003), so only the owner can cut
     it.
   - `router.dart` currently sends consent straight to /today. It needs a "no profile, go to /setup" redirect.
   - (b1) is options, reasons, chips, "I'll try this", "Something else", the nothing-fits states, the week strip and
     "Not today" to pause. Pause must be in b1 (BR-006, TC-014).
   - (b2) is Edit S-102, why-this S-107, "Move it to later" S-114, "My plan fell through" S-115 and the under-way
     states. Hide the 3.3 rows that are not built. No dead rows.
4. **Move the demo seed loader up, right after (c).** It is listed last in build-scope §4. Without history, the "You
   managed this before" reasons (EQ-004) and a filled grid never show in a fresh demo.

**Recommended order:** PR 0, then (a) with S-090, then (b1), then (c), then the seed loader, then (b2), then the rest
of (a) if split.

**Reflection (c):**
- Build the 5 states (Done, Partly, Didn't get to it, nothing chosen, details open) and the one-sentence "what
  changes next" (F-003).
- Skip S-110 achievement sheets; they belong to F-015, which is on the cut path.
- There is no effort control in any frame. EQ-003 retired the effort term. Check with design-reviewer.

**Cut list (build-scope §3).** Nothing in TASK-005 is on it. Together stage B, share templates, dark theme and
F-015/F-008/F-004 are all outside it. Two instructions follow:
- Do not let the builder spend time on dark theme or the notification prompt (Q1 in user-flow §7) in these PRs.
- Three new cut candidates inside TASK-005 for the owner's 2026-11-06 list. They are not in the document today:
  - the "I'm starting", under-way and after-window states (2.5b, 2.5c; ADR-014, labelled optional in the sitemap).
    The planned card's primary would be "How did it go?", which UF-003 step 0 allows. This deviates from frame 2.5,
    so the owner must decide.
  - S-114 and S-115.
  - S-107, keeping the inline reason.

**Checkpoint risk.** The 2026-11-06 walkable loop (implementation-plan §2) includes "can reach My rhythm and the
grid". S-006 is TASK-006, not TASK-005. Either the owner accepts the Today grid strip as "the grid", or a minimal
S-006 must be scheduled alongside PR (c).

**Could not verify:** the effort on each PR, and the current date-to-date capacity.

**Verdict Q2: APPROVE WITH CHANGES.**

---

## Question 3: Build and review process

**One builder screen, then the reviewer's review, is not enough.** Two gaps in the tooling:
- flutter-ui-builder cannot read Figma. Its tools line is `Read, Grep, Glob, Edit, Write, Bash`, with no Figma MCP,
  although its Inputs section mentions the Figma MCP. The caller must pass frame ids, exported PNGs and a text spec.
- The reviewer cannot see the built app either. Its tools are Read, Grep, Glob and Figma read-only. Without PNGs of
  the built screens it is reviewing code, not pixels.
- "One screen per invocation" is too coarse for S-003 and S-004. Use one invocation per PR piece, as in Q2.

**Checks wanted, by step:**

| Step | Who | Check |
|---|---|---|
| 0. Brief | Caller | Frame ids including state frames; which doc rule overrides a frame (the nothing-fits spec); library text, not Figma sample copy; a "do not build" list (S-110, dark, reminders). |
| 1. Before hand-off | Builder, automated | `flutter analyze` and tests. TC-045: `androidTapTargetGuideline` and `labeledTapTargetGuideline`, plus `textContrastGuideline`, per state. TC-044: each state at text scale 1.0 and 2.0 on 360×800 and a small phone, asserting no overflow exception; sheets keep the pinned-footer, scroll-body rule. TC-014 pause in at most 2 taps. TC-012 non-empty reason. BR-003: flagged text is not stored and no suggestion is shown. The guilt-word scan extended to the ARB strings. No raw hex outside `theme.dart`. Fonts bundled, and `no_network_test` still passing. Verify the Flutter guideline names against current docs. |
| 2. Evidence | Builder | PNG per state at 360×800 and 412×915, at 1.0 and 2.0 text scale, saved to a named folder. Use goldens as evidence rather than pixel-asserted, since Windows and CI fonts differ. |
| 3. Review | Senior reviewer | Built PNG next to the Figma frame: hierarchy, spacing rhythm, type and colour tokens, 48 dp targets and 8 dp gaps, copy against the wording list, every required state present, setup primary at y736–784, sheet anchoring and scrim. High findings are fixed in the same PR. |
| 4. Rules | design-reviewer and rules-reviewer | design-reviewer on (a) and (b1) for flow and the hero/swap model. rules-reviewer on the PR that contains S-090 and the copy. |
| 5. Device | Owner | Android phone with TalkBack on, 200% font and large display size, for the 11-06 walkable test. Flutter web does not give a full screen-reader check. |

**Not worth doing:** automated pixel diff against Figma (too many false positives), and any dark-mode checks (cut
item 3).

**Could not verify:** that the CI runs these tests today, and the Flutter guideline APIs against current docs.

**Verdict Q3: APPROVE WITH CHANGES.**

---

## Summary

| Question | Verdict |
|---|---|
| 1. Nothing-fits state | Approve with changes (written spec, no new frame) |
| 2. Build order | Approve with changes (PR 0, S-090 with first free text, split a and b, seed loader earlier) |
| 3. Process | Approve with changes (Figma access for the builder, PNG evidence for me, test gates) |

Next step to unblock (b): decide the hero swap model (one activity cycling versus the ranker's three activities).
Otherwise the builder will guess. **Decided by the owner on 2026-10-27: the hero cycles the ranker's top options; the
compact cards are the other followed activities.**
