# Review: three open decisions and the share card templates — 2026-10-26

The owner asked the UI reviewer ("senior reviewer") for its recommendation on three open decisions, and for a
spec for more share card templates (F-015). The owner agreed with the rulings below. The report is kept as
written.

## UI reviewer: rulings and share card spec

[V] means verified in a fresh screenshot. [J] is my judgement. I looked at 3.12, 3.13 and the 3.13 200% frame
for the verdict.

**Decision 1: retention — 30 days**
- Shorter is better for minimisation, and 7 days is too short for a phone left offline over a holiday.
- 90 days or "until the person stops sharing" keeps far more of someone's daily pattern than catch-up needs.
- A monthly goal like "60 active days in November" works at 30 days, because each phone keeps its own
  challenge count as a high-water mark, the same as the pair counts. [J]
- The trade-off is a new phone. A fresh install can only rebuild the last 30 days, so counts older than that
  start again. Say so honestly on the Sharing screen.
- The Sharing screen sentence: "Your daily active or resting marks are kept for 30 days so friends' phones can
  catch up, then deleted. Stopping removes them now."

**Decision 2: the "Stop sharing" button — neutral outline**
- I am changing my earlier call. I accepted the red outline because the action removes server data. On
  reflection, it is reversible: the person can opt in again, and their count of days together stays.
- Red should keep its meaning for the one irreversible action, delete everything. Used for both, it stops being
  a warning.
- The safe "Keep sharing" stays as the filled default. Keep the label "Stop sharing" explicit.
- Revert the DESIGN.md `danger` line to "delete-all only".

**Decision 3: Export includes the counts — yes**
- Export says "everything on this phone", so the local counts belong in it. It is also fairer for the person's
  own data.
- It does not promise a restore, because nothing verifies that an import exists.
- Suggested row subtitle: "Saves a file with everything on this phone, including your days together."
- On the Sharing screen, say "On a new phone your count of days together starts again." until an import exists.

**New request: share templates (F-015)**

**(a) Templates**
- Cut the Info/insight card. "What works for me" carries times of day and patterns, and F-015 says cards never
  show times, places or notes.
- **Milestone** (the existing layout). Equalizer bars, a title and one line.
  - It is fed by 10, 30 and 100 active days, Bounced back, Explorer, Back at it and Found your rhythm.
- **Activity.** Art-led. The Activity art tile, enlarged, with the activity name and one line.
  - It is fed by Something new, Explorer and Back at it when an activity is named.
- **Rhythm.** Grid-led, with "My rhythm" and "Active on N days so far".
  - Use the all-time count, never a rolling 12-week count, because a rolling count can fall and BR-023 says
    milestones only increase.
- **Together (P1).** "Better together" and "12 days together", with no friend names by default.
- A daily "Ran today" moment is a P1 idea, with its own entry point from the check-in screen.

**(b) The picker**
- Use a segmented control for 2 or 3 templates, in the sheet above the preview. The templates offered are only
  those that fit the achievement.
- Taps: 3.12 "Share" (1) → optionally a template (2) → "Share…" (system sheet). That is 2 taps by default.
- From 6.2: tapping an earned tile opens 3.13 directly, then "Share…". That is 2 taps.

**(c) Aspect ratio**
- One image, 9:16 (1080×1920), with all content inside a centred 4:5 region (1080×1350). That keeps it clear of
  Instagram's top 250 px and bottom 340 px overlays, and it crops cleanly to a feed post.
- Show the 4:5 core in the preview. Offer no choice in P0.

**(d) Colour, art and the QR code**
- The card follows the app theme, uses existing tokens, and meets 4.5:1.
- Replace the solid square with a QR-like pattern, as on 10.3, in the bottom corner. It points to the store page
  only, and contains nothing personal.
- The grid toggle is OFF by default (see the verdict). The Rhythm template includes the grid by choice.

**(e) Copy**
- Milestone: "30 active days" / "Any amount counts."
- Back at it: "Back at it" / "Came back to running."
- Something new: "Something new" / "Tried pickleball for the first time."
- Explorer: "Explorer" / "Tried 3 new activities."
- Rhythm: "My rhythm" / "Active on 31 days so far."
- Together: "Better together" / "12 days together."
- No streak or loss words anywhere.

**(f) Frames**
- The revised 3.13 with the segmented control, plus 3 card frames at card size.
- One dark card as evidence, and an updated 3.13 200% frame with the segments stacked.
- Existing frames that change: 3.13 (toggle OFF, real QR pattern, segmented control) and 6.2 (earned tiles
  tappable). 3.12 doesn't change.

**(g) Docs to amend**
- PRD F-015 (the templates and the default OFF).
- BR-023 (the all-time count wording).
- DESIGN.md: a "Share card" component row and the safe zone.
- A short ADR for the templates and the safe zone, noting that cards are generated on the device.

**Verdict on the current frames: APPROVE WITH CONDITIONS.**
- **One true blocker:** 3.13 and its 200% frame show "Show my grid" ON, but F-015 says the grid is OFF by
  default. [V] It is a privacy default. Flip it to OFF.
- **Conditions:** replace the solid-blue QR square with a QR pattern [V]; 6.2 has no link into 3.13.
- **Polish:** at 200% the toggle sits against the right edge; add the template picker.
- 3.12 is clean [V].

## Status notes (added by Claude, not the reviewer)

- Owner decisions, 2026-10-26: agreed with decisions 1 to 3 as ruled, and with keeping the daily "Ran today"
  card for P1. The owner's "info" template was not defined; it is left out (see the Info card ruling).
- Applied: ADR-015 (30-day retention), ADR-016 (templates and safe area); PRD Q12 closed, BR-018, BR-023, F-015;
  DESIGN.md (`danger` is delete-all only again, Share card row); QA TC-047.
- Figma: "Stop sharing" is a neutral outline on 7.6b and its 200% frame; Export subtitle and the Sharing note on
  the Settings P1 frames; new cards 3.13m, 3.13a, 3.13r (9:16, 4:5 safe zone) and a dark Milestone card; 3.13
  rebuilt with the picker (Activity selected), 3.13 · Milestone, 3.13 · Rhythm; grid toggle off; QR pattern;
  6.2 "30 active days" opens the Milestone sheet; new 200% frame; the old 3.13 200% frame is renamed
  SUPERSEDED.
- Round 2 (UI reviewer: APPROVE WITH CONDITIONS, no blockers; its report is quoted below, summary
  here): the Milestone title wrapped to "30 active / days", so the number is now the hero (96 px) with "active
  days" below; the QR placeholder lacked finder squares and now has them (annotated as a runtime placeholder);
  the "Show my grid" toggle was redundant because Rhythm is the grid, so it is removed and F-015 says the grid
  appears only in Rhythm; every earned tile on 6.2 is linked (Back at it and Something new open Activity, 10 and
  30 active days open Milestone; locked tiles are not linked); the Sharing note is trimmed to "Marks are kept
  30 days so friends' phones can catch up, then deleted. Stopping removes them now. On a new phone your count
  starts again."; Explorer offers Milestone and Rhythm only (a rule, not drawn).
- Known gaps: the Together template and a Back at it card with a stronger hero or tint (polish) are not drawn;
  Explorer's two-template sheet is not drawn. The round 2 frames have not been re-reviewed.

## UI reviewer: round 2 on the share frames (verbatim)

**Verdict: APPROVE WITH CONDITIONS. No true blockers.**

[V] means verified in a fresh screenshot. [J] is my judgement. Prototype links are unverified. I compared the card
geometry against typical Instagram and TikTok overlays from memory, not from a source I could open.

**The share cards (292:4921, 292:5004, 292:5091, 292:5267)**
- **Safe zone [V].**
  - The 4:5 core is y95–545 on the 360×640 card. The footer's QR bottom is about y512, and the content starts
    at about y192, so everything sits inside it.
  - Against the story overlays (about 14% at the top and 18% at the bottom of the height), the usable band is
    roughly y83–527. The footer clears it.
  - The wordmark is small. At 1080 px export it is legible. The QR becomes about 168 px, which is scannable.
- **Contrast [V].** The light card (ink on #F3F4F2) and the dark card (white on near-black) both pass
  comfortably.
- **Rhythm card [V].** The 298 px grid is balanced, and the today ring and "so far" copy are right.
- **Activity art enlarged to a 140 px tile [V].** The runner scales cleanly, and the strokes stay consistent.
- **Is it good enough to share?** [J] It is on-brand and calm, but plain.
  - **The Milestone title wraps to "30 active / days".** That is a visible orphan. Split it: the number as the
    hero (about 96 px) and "active days" as a second line. Then 10, 30 and 100 days all break the same way.
  - Larger bars or a soft brand tint behind the card would raise it from plain to shareable.
- **QR pattern [V].** It is a pixel mosaic without the three corner finder squares, so it doesn't look like a QR
  code (the 10.3 QR does). It can't mislead anyone into scanning it. Add finder squares and annotate
  "placeholder — generated at runtime".
- **Other achievements [J].**
  - Explorer and Something new work in the Milestone template.
  - Something new also works in Activity ("Tried pickleball for the first time").
  - **Explorer has no single activity, so hide the Activity template for it.**
  - 100 active days works once the number is the hero.

**The 3.13 sheets (152:5234, 294:5028, 294:5345) [V]**
- The title reads "Share this". The segmented control has three short labels, and the 4:5 preview is clear.
- The sheet is 673 tall and ends at y800 (about y128 + 673). It is well under 720.
- "Share…" is the one primary.
- The toggle is OFF and visibly off. It is absent on Rhythm, which is correct.
- **The toggle is now redundant.** Rhythm is the grid. An ON state isn't drawn, and the screen doesn't say what
  it would add. I recommend removing it in P0 and amending F-015 to "the grid appears only in the Rhythm
  template". That also simplifies the privacy story. If you keep it, draw the ON state.

**3.13 at 200% (296:5057) [V]**
- The segments stack one per row, the body scrolls with a fade, and "Share…" is pinned. The preview isn't
  scaled. That is honest evidence.

**6.2 [V]**
- Earned tiles show their equalizer, and locked tiles are now clearly visible.
- **Link every earned tile to 3.13,** each with the default template that fits: Something new opens Activity,
  and 10 active days opens Milestone. Locked tiles stay unlinked.

**Settings and 7.6b**
- **7.6b (279:4801) and 281:5126:** "Stop sharing" is now a neutral outline with "Keep sharing" as the filled
  default. The 200% frame scrolls the body with the buttons pinned. [V]
- **7.1 P1:** the Export subtitle "Everything on this phone, including days together" fits one line [V].
- **The Sharing note is too long** [J]. It is four small lines, 43 words, sitting 12 px above the "Reminders"
  heading. Trim it to about 25 words: "Marks are kept 30 days so friends' phones can catch up, then deleted.
  Stopping removes them now. On a new phone your count starts again."

**True blockers:** none.

**Conditions:**
1. Fix the Milestone card's number layout, so there is no "days" orphan.
2. Add finder squares to the QR placeholder.
3. Decide on the toggle (I recommend removing it).
4. Link every earned tile on 6.2.
5. Trim the Sharing note.

**Polish:** a stronger hero or tint on the cards, and hiding the Activity template for Explorer.
