# Review: where Group Challenges (P1, F-012) lives — 2026-10-26

Two reviewers were asked about the same question. Both reports are kept as written. The owner trusts the UI
reviewer ("senior reviewer") on layout and navigation and used the design reviewer for goals, rules and flow
coverage. Neither review is an approval by the owner.

**Question.** In `Lilt · Screens` (Figma `QEdjcVZJUBX6jpRxOVblCa`, page `142:3838`), frame 10.1 "Challenges (in
Together)" had no way in from Together. Its only inbound link was 10.4, the join page for an invited outsider.
11.9 "Together · mine" had Going, Hosting and My clubs only. Nav order in every frame is Today, Discover,
Together, My rhythm.

Options put to both reviewers: (1) a section in Mine; (2) a fourth Together segment; (3) leave 10.1 reachable
by invite only; (4) anything better.

## 1. UI reviewer (senior reviewer)

**Pick: option 1.** Put Challenges in Together > Mine, as a pushed screen. Friends moves with it.

[V] means verified in the frames or docs listed. [J] is judgement.

**(a) Why**
- Mine is "my stuff": what I'm going to, hosting and a member of. Challenges and friends are personal and
  ongoing, so they belong there. Events is discovery and would bury them. [J]
- Option 2 breaks DESIGN.md's rule that Tabs has 2 or 3 tabs. A fourth tab labelled "Challenges" also won't
  fit a 90 dp tab at 200% text. [V]
- Option 3 leaves a signed-in user with no way in. That is the current defect. [V]
- ADR-009 already says challenges "will live in Together" [V]. Option 1 honours that. It changes PRD wording
  from "a Challenges tab" to "Challenges in Together > Mine".

**(b) Spec**
- **11.9 Mine.**
  - Add a "With friends" section with two list rows, using the existing row and card styles. No new tokens.
  - "Challenges" shows a summary such as "2 active", and opens 10.1.
  - "Friends" shows the together-days summary, for example "12 days with Mia", and opens 10.7.
  - Put the section between Hosting and My clubs. Let the frame grow to about 960–1000 px as scroll content,
    like 11.4, with a fade at the bottom.
- **10.1.**
  - Make it a pushed screen: a back arrow, the title "Challenges", no bottom nav. This matches 11.5 and 11.7.
  - It shows the challenge list and "+ Create a challenge". Remove the Friends row, because the entry now
    lives on 11.9.
  - Back returns to Mine with the Mine tab selected.
  - 10.4 (the invite landing) still leads in. Its back goes to Mine as well.
- **Tap path from the Together tab:** Challenges is 3 taps (Together, Mine, Challenges). Creating a challenge
  is 4 taps. Friends is 3 taps.
- **200% and dark.** Rows already stack at 200%, so nothing new breaks. The new rows use existing tokens, so
  no new dark risk. Add 11.9 to the dark evidence only if you extend that set.

**(c) Friends:** yes, move it with Challenges. It is the same "people I know" idea. Two entries for one
concept (Friends on 10.1 and a new row on 11.9) would be confusing. [J]

**(d) Order:** docs first, in the same change set as the frames. [J]
- Record the decision in ADR-009 or the sitemap, and update PRD F-012 to say "Together > Mine".
- Fix the sitemap while you're there. It says three tabs, but the frames show four bottom tabs (Today,
  Discover, Together, My rhythm). [V per the report]
- Do not describe the flow as reachable until the frames have the link.

**(e) Verdict on the current frames for this flow: NOT APPROVED.**
- **True blockers:**
  1. A signed-in user cannot reach 10.1. The only inbound link is 10.4, which serves invited outsiders. [V]
  2. 10.1 is drawn as a Together screen (nav highlighted, no tab strip) without being a Together tab
     destination. It is neither a tab nor a pushed page. [V]
- **Polish:** the Friends row sits on a challenge screen; the sitemap and PRD wording.
- The frames after the entry point are fine: 10.2 (create), 10.3 (invite), 10.4 (join) and 10.7 (friends).
  Nothing there needs changing.
- This is P1 (F-012). It does not block the P0 hand-off. It blocks any claim that the P1 flow is complete in
  design. [J]

## 2. Design reviewer (product and rules)

**Verdict: APPROVE WITH CONDITIONS.** Option 1 is the right place on product grounds. ADR-009:56 says
challenges "will live in Together", Mine is already the "things I'm part of" tab, and 10.1 is not a tab or a
4th segment. [V] The conditions below are needed to avoid a rules breach. Legend: [V] verified in a frame or
doc, [J] judgement. Read-only, nothing edited.

**Blockers (must be true before Option 1 is shown)**
- **B1. BR-025 contradicts the P1 features, and Option 1 puts them in the same place as P0 content.**
  - BR-025 (prd.md:182) and ADR-009:44 say the grid and activity never leave the device. 11.1 repeats this:
    "Your activity history and answers stay on this phone." [V]
  - But "42 of 60 together" (10.1), "12 days active together" and "Run-walk, 20 min · today" (10.7) need the
    server to know each person's active days. [V]
  - BR-018 (prd.md:179) allows opt-in sharing, "by default grid brightness only". 10.7 shows activity name and
    duration, which is more than that default. [V]
  - Fix:
    - Add a P1 clause to BR-025: "except the daily active flag, shared only with people the user invites
      (BR-018)".
    - Add a one-time line before the first challenge or friend: "Challenges and friends share which days you
      were active, only with people you choose. What you did and wrote stays on this phone."
    - Show activity name and duration on 10.7 only if the friend opted in.
- **B2. The P1 label (question 3).**
  - PRD:395 and BRD:56 say challenges, friends and together days are "designed and pitched, not built".
  - Keep the P0 11.9 unchanged. Add a separate frame "11.9 Together · mine (P1)" with the "With friends"
    section, and put "(P1)" in the frame name and an off-device annotation.
  - Do not add an in-app "P1" chip. Docs labels alone are not enough, because judges see the frames.

**Conditions (smaller, each with a source)**
1. **Question 1, signed-out state.**
   - No new state is needed on the two rows. 11.1 gates the whole Together tab, and PRD:310 and UJ-005:237
     agree. [V]
   - The premise that Together browsing is open to signed-out users is not in the docs or the frames. BR-025
     says only that everything outside Together works without an account. If the owner wants open browsing,
     that is a docs gap.
   - The rows inherit 11.1. Add the sharing line from B1 at first use.
2. **Question 2, row summaries (BR-021, BR-018, owner "no score-like counters").**
   - "2 active" can go down when a challenge ends. "12 days with Mia" picks one friend, which implies a
     ranking, and it disappears if that friend leaves. [J]
   - Use "Challenges" with the summary line "60 active days in November" (or "Nothing yet" when empty).
   - Use "Friends" with the existing 10.1 subtitle "See how your friends are doing".
3. **Wording scan of 10.1, 10.2, 10.3, 10.4, 10.7.**
   - No never-list words. [V] 10.5 "cancelled" and 10.8 "It only goes up from here" are fine. "Ana ·
     Resting this week" is neutral (BR-018). [V]
   - 10.7 "This week: 3 of 4 days together" reads as one day not together, against BR-021 ("no missed" copy).
     Use "3 days together this week" (ADR-010:34). [J]
   - A monthly goal ("60 active days in November") has no defined end state. ADR-010 covers only the weekly
     goal. Add a neutral ending, for example "November: 51 days together. Thanks, all.", to the docs. [J]
   - The 10.2 goal "Show up to events" invites attendance-based guilt. Consider "Join events". [J]
4. **Question 4, BR-024 and BR-027.**
   - 10.4 shows only the inviter's name, the challenge name and "6 people", which satisfies BR-024. [V]
   - 10.2 selects "Only people I invite", yet 10.3 offers a QR code, join code and link under "Anyone else".
     [V] For a private challenge the code or link must be invite-bound (single-use or expiring), or hidden.
     Otherwise anyone can join, against BR-024.
   - The "I'm 18 or older" checkbox exists in the file as a layer name, but I did not confirm which frame
     holds it. The path 10.4 → "Get Lilt to join" → account and 18+ is not drawn. Add it to the flow stub
     (BR-027).
   - BR-028 names events, clubs and profiles only. Open-link challenges need report and block too (docs gap).
     Reuse 11.12 and add a report route to 10.7.
   - 10.3 still shows the code "RHY-4KP2" (the old name). Polish.
5. **Question 5, coverage.**
   - docs/user-flow.md has UF-001..009 only. F-018 and UJ-005 have no UF, so the P0 flow is already missing
     and Option 1's stub would not close it. [V]
   - The sitemap has no S-010 and still says 3 tabs. Its self-check at line 106 claims every P0 F-### is
     served, but F-018 is absent. [V]
   - Add UF-010 (P0): Together → browse → event → "I'm going" → Today's plan. Its edge cases are 11.1 (signed
     out), 11.13 (nothing near you), 10.5 (cancelled) and 11.12 (report).
   - Add UF-011 (P1): Mine › Challenges → 10.1 → 10.2 → 10.3. Add the invitee path 10.4 → account and 18+ →
     joined.
   - No frame exists for these [V from frame names]: a challenge detail, leave a challenge, join with a code
     (10.3 only shows the code), add a friend, an invalid or expired code, and the 10.1 empty state. Add them
     to the stub as "not drawn".
6. **Question 6, other contradictions.**
   - F-012 events overlap F-018 events. The same pickleball event could show in Going, Hosting and
     Challenges. State that they are one entity, and that BR-027 (public venue, guidelines) applies to the
     10.2 Event type. [J]
   - Leave the PRD:16 changelog as history. Reword only F-012 (:128) and BRD:59.
   - sitemap.md:9-10 ("three tabs") conflicts with ADR-009:29 and every frame. This is pre-existing, but it
     must be fixed in the same edit.

**Working well:** ADR-009:56 and Option 1 agree. 10.7 and 10.8 follow ADR-010 ("never resets", "only goes
up", "Not now"). 10.5 is a calm cancellation.

**Not verified:** the frame that holds the 18+ checkbox, and the prototype wiring.

## Status notes (added by Claude, not the reviewers)

- The design reviewer read an old copy of the sitemap: S-010 and the four-tab wording were already merged in
  PR #3, and the tab order was corrected in PR #4.
- Where the reviewers differ, the owner's rule is "follow the senior reviewer", but the row copy and the P1
  frame are rules questions. Claude followed the design reviewer on those two points: no "2 active" or "12
  days with Mia" summaries, and a separate P1 frame instead of editing 11.9. Owner to confirm.
- Docs done on branch `docs/challenges-in-together-mine`: PRD F-012, BR-025 P1 clause, F-018 Mine criterion;
  BRD next-phase line; sitemap S-010 and tree; user-flow UF-010, UF-011, EV-011..EV-014.
- Owner decisions, 2026-10-26: Option 1 accepted; Q2 answered: signed-out people can browse public Together
  events, and the sign-in screen shows when they RSVP, join or host.
- Figma done: new frame "11.9 Together · mine (P1)" (268:4569, P0 11.9 untouched); 10.1 as a pushed screen
  with a back arrow and no tab bar, Friends row removed; 10.4 back goes to the P1 Mine frame; copy fixes
  ("Join events", "LILT-4KP2", "3 days together this week"); a one-time sharing note on 10.1 and 10.7.
  These frames have not been re-reviewed by either reviewer.
- Second round: the UI reviewer approved the changed frames with conditions and no blockers, and ruled that
  11.1 becomes the sign-in step. The owner chose the narrower gate: only "I'm going" (11.5) goes to 11.1;
  Host and Join stay direct because the demo account is pre-signed-in. Applied: 11.1 renamed and made a pushed
  screen, 1.16 Together tab goes to 11.4, annotation added, duplicate heading removed from 10.1.
- The design reviewer (privacy wording) returned APPROVE WITH CONDITIONS with three blockers, not yet applied
  and awaiting the owner: (1) 10.7 rows show activity name and duration, contradicting the caption; (2) BR-018
  ("grid brightness") and the BR-025 P1 clause ("active flag, nothing else") disagree and omit the paused flag;
  (3) the captions say "only if you choose" but no opt-in control is drawn (proposed: one-time sheet "Share my
  active days" / "Not now"). It also asked for: 11.1 sentence "Your display name, an optional photo, your
  approximate area, and the events and clubs you join are shared. The activities you do, and anything you
  write, stay on this phone."; captions "Members of this challenge see which days you were active. The
  activities you do and anything you write stay on this phone. You can stop sharing any time." (10.1) and
  "Friends you choose see which days you were active. ..." (10.7); signed-out 11.4 shows counts, not names
  (BR-029). Its notes that PRD:310 / UJ-005 and the 10.3 code were stale were wrong: both were already fixed.
- Not done yet: the monthly-goal ending line; the "one entity" statement for events across F-012 and F-018; the
  private-challenge code rule in the PRD; showing a friend's activity name on 10.7 only if they opted in.
