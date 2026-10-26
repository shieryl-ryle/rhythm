# Review: the missing middle between "I'll try this" and "How did it go?" — 2026-10-26

The owner compared the flow with Strava and Apple Fitness and noticed that, after "I'll try this", the app
shows Today's plan with "Accepted" and "How did it go?", and nothing for the doing. The owner agreed to
(1) document that Lilt does not record activities (ADR-014) and (2) add a minimal optional state. The UI
reviewer ("senior reviewer") wrote the spec below; it is kept as written.

## UI reviewer: spec for a minimal "Under way" state

Nothing in this spec is verified in a frame yet, because the state doesn't exist. I did check 2.5 and 3.11
earlier. I'm following the owner's no-recording decision: Lilt marks moments the person chooses to mark, and
records nothing. The verdict is at the end.

**(a) The card states.** The state is optional, and nobody is ever required to tap Start.
- **Planned** (today's 2.5):
  - The status reads "Planned", not "Accepted".
  - The line "Today 12:30 · 20 min" stays.
  - The primary is "I'm starting". The text button "Change" stays.
- **Under way:**
  - The status reads "Under way". Don't use "Active", which collides with "active days".
  - The line reads "Started 12:31 · about 20 min".
  - **No ticking timer.** A counter reads as tracking and as pressure. A fixed start time is the person's
    own marker.
  - The primary is "I'm finished". The secondary text button is "Not started yet", an undo for a mis-tap.
    "Change" doesn't make sense once started.
- **After the planned window passes with no Start:** the primary becomes "How did it go?". The person may
  have done it without telling the app, and that is fine.
- **First-person voice throughout:** "I'll try this", "I'm starting", "I'm finished".

**(b) Finished goes straight to the reflection sheet.** There is no confirm step.
- Arrive with "Done" preselected, since the person said they finished. That saves a tap and still leaves the
  answer editable. It is not a guess about why anything happened (BR-008).
- Taps from "I'll try this": 4 with Start (I'll try this, I'm starting, I'm finished, Save). It stays at 4
  without Start (I'll try this, How did it go?, pick, Save). The F-003 reflection stays within 3 taps from
  the moment the sheet opens.
- Dismissing the sheet leaves the result unknown (BR-009). The card returns to "How did it go?", with no
  status line.

**(c) If they never tap Start or Finished.**
- The card stays as "Planned", then shows "How did it go?". It never turns red or shows "overdue" or
  "missed".
- "Under way" clears itself after about 3 hours and returns to "How did it go?".
- At day rollover the item leaves Today's plan. It is stored as unknown, and the day shows as level 0 ("Rest
  or not shared") in the grid.
- The only prompt is the existing gentle reminder, which already stays within its daily caps (BR-013).

**(d) The grid and the Today header.** Nothing changes until a reflection is saved (EQ-002). The today tile
ring and the header text stay as they are.

**(e) Frames**
- It is a variant of 2.5. Add one frame, "2.5b Today's plan · under way".
- Relabel the primary and the status on 2.5.
- 2.3, 1.16 and 2.7 don't change, because the hero card moves into the plan list after "I'll try this".
- 2.6 is unchanged. Reuse the existing 3.11 "Done" frame for the preselected arrival.
- 9.x needs no change.

**(f) Copy**
- Status: "Planned" and "Under way".
- Line: "Started 12:31 · about 20 min".
- Buttons: "I'm starting", "I'm finished", "Not started yet", "Change", "How did it go?".
- No pressure words anywhere. All of it is off the never-list.

**(g) Dark, 200% and taps**
- It uses existing buttons, text buttons and card tokens, so there is no new dark risk.
- At 200% the buttons already stack full width. The card pattern is covered by the 2.3 200% frame, so no new
  200% frame is needed. [J]
- Tap counts are as in (b).

**(h) Widget and notification**
- The widget's "Check in" opens the reflection directly, as today.
- The notification actions (Done, Partly, Open) are unchanged.
- Neither needs to know about Start. Starting is optional.

**(i) Together events**
- For an RSVP'd event, the card shows the event line, for example "Sat 24 Oct · 9:00 · Central Park
  courts". It offers "Can't make it? Cancel" until 1 hour before.
- From 1 hour before, "I'm starting" appears, with the same states afterwards.
- No location or check-in is sent to the host (BR-029). Event reflection uses the same sheet.
- A self-chosen activity offers Start at any time.

**Verdict on the current frames for this flow: APPROVE WITH CONDITIONS. No true blockers.**
- The frames are consistent and honest, and they record nothing.
- Conditions:
  1. Add the "Under way" state described above.
  2. Document "Lilt is not a recorder" in the PRD non-goals, in one line (no GPS, pace or live tracking, per
     BR-025).
- Polish:
  - "Accepted" should read "Planned".
  - "How did it go?" is offered before the activity has happened.

## Status notes (added by Claude, not the reviewer)

- Done 2026-10-26: ADR-014; PRD non-goal and F-003 criterion; UF-002 and UF-003; sitemap S-004; DESIGN.md
  "Plan card"; TC-046; Figma 2.5 relabelled ("Planned", "I'm starting") and new frame 2.5b (285:4791).
- Not drawn: the Together-event card variant ("I'm starting" from 1 hour before), the "How did it go?" state
  after the planned window passes, and the "Can't make it? Cancel" line on event cards.
- Small leftover: on 2.5b the "Under way" card still sits under the section heading "Planned".
- Not re-reviewed by the UI reviewer after the frames were built.
