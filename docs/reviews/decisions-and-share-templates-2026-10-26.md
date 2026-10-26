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
- Known gaps: the Together template, the toggle-on state of the preview (grid shown on Milestone and Activity),
  and 6.2 links for the other earned tiles are not drawn. Not yet re-reviewed by the UI reviewer.
