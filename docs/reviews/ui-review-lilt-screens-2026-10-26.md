# UI/UX review of Lilt · Screens (Figma 142:3838)

Reviewer: the ui-reviewer agent (read-only). Date: 2026-10-26.
Figma file key: QEdjcVZJUBX6jpRxOVblCa.

These are the reviewer's three reports in its own words, in the order they were written:

1. **Review 1:** the first full review of all 99 frames.
2. **Review 2:** the reviewer's answer when asked to challenge the sheet-fix plan. This is the one that changed the plan.
3. **Review 3:** the re-check after the fixes.

`[V]` means the reviewer checked it in a screenshot or in metadata. `[J]` means it is the reviewer's judgement.
Between the reviews the Figma file changed, so node ids and states in Review 1 describe the file before the fixes.

---

## Review 1: first full review

### How I reviewed it
- I screenshotted all 99 frames and read `docs/DESIGN.md`.
- The tool returned screenshots at 1x (360 px wide), so very small details were judged at 1x.
- I checked positions and sizes with `get_metadata` on the frames behind the clipping, snackbar, nav and tap-target findings.
- Contrast ratios come from the token hex values (via `get_variable_defs`) computed against canvas `#F3F4F2`. They are not measured from pixels.
- I did not edit Figma or code.

### BLOCKERS

#### B1. Bottom sheets run off the 800 px frame, so primary actions are cut off or have no bottom padding
- Clipped actions (sheet node ids in parentheses). Visible height is measured from the sheet's own y position plus the button's y offset:

| Screen (id) | What is cut | Visible |
|---|---|---|
| 3.2 Edit (152:4000) | Save button runs y785–833 | about 15 of 48 px |
| 3.3 Not today (152:4172) | "Pause for 1 week" runs y770–818 | about 30 of 48 px |
| 3.13 Share card (152:5234) | Share button runs y796–844 | about 4 px. The "Show my grid" toggle also sits at the bottom edge. |
| 3.12 Achievement (152:5092) | "Not now" runs y781–829 | about 19 of 48 px |
| 3.8 Add (152:4723) | Second row "Plan a one-off" is half cut | about 32 of 71 px |
| 3.11 How did it go? (152:4928) | Save runs y757–805 | clipped by 5 px, no bottom margin |
| 3.1 (152:3838), 1.2 (142:3865), 3.9 (152:4882) | Button bottoms | clipped by 10–15 px |

- Buttons sit flush with the bottom edge (about 1 px margin) on 6.5 (163:4813), 9.1 (163:5264) and 9.11 (163:5720). 10.3 (163:5882) has 7 px.
- 11.12 Report (163:6409) goes the other way. The sheet ends at y771, so it floats 29 px above the bottom. A dark chunk of the backdrop "I'm going" button shows underneath it.
- Why it matters:
  - A user cannot reach Save, Pause or Share when the button is off-screen.
  - The Pause path is the most affected, and it is the one with the strongest accessibility story.
  - A frame with a clipped button also cannot be used as an approved prototype or a hand-off reference.
- Fix:
  - Cap sheet height at 800 minus the status bar.
  - Put 24 dp of bottom padding under the last button, plus the gesture inset.
  - Make the primary button sticky and let the content above it scroll.
  - 3.11 is the worst case. It has a required question and two optional chip groups, so give it a scrolling body with a sticky Save.
  - Anchor every sheet to y = 800 minus its height.

#### B2. 11.11 Event posted (163:6359) has the nav bar in the wrong place
- The nav bar sits at y672–752 and the snackbar at y752–800, so the snackbar is below the nav bar.
- The nav bar should end at 800 (y720). The "My clubs" card is also cut under the displaced nav.
- Why it matters: it breaks the app's bottom structure on a screen changed this session. Material places a snackbar above the nav bar.
- Fix:
  - Put the nav bar back at y720.
  - Float the snackbar at y ≈ 648–696 (16 px above the nav).
  - Make the body 628 tall like 11.4.

### SHOULD FIX

1. **Snackbars (7.5, 11.6, 11.11)**
   - **7.5 Export done (163:5161):**
     - The snackbar is at x=0, width 328. That is flush left with a 32 px gap on the right, while elsewhere it is x16 and 328 wide.
     - It touches the bottom edge and covers the "Delete everything" row.
   - **11.6 You're going (163:6200):** the snackbar is at y752–800, flush to the bottom, and 16 px under "Can't make it? Cancel". It is centred now, but it needs 16 dp bottom margin plus the gesture inset.
   - Fix: use one rule for all of them. Snackbars are x16, 328 wide, 16 above the nav bar (or 16 from the bottom when there is no nav bar), and never over a destructive row.

2. **"Delete everything" subtitle is clipped on 7.1 (163:5041), 7.4 (163:5132), 7.5 and 9.10 (163:5691)**
   - The text reads "…and your Together a" with no ellipsis. The text box is 341 px wide inside a 298 px column.
   - Fix: let it wrap to two lines, or shorten it to "Removes all data from this phone and Together".

3. **9.15 Large text (200%) (163:6474) does not show 200%**
   - Only the title, the card title and the reason line are scaled.
   - The date line, tag, "Suggested…" line, button labels and nav labels keep their 100% size. The tag stays 24 px high and the "Suggested" line 20 px.
   - Why it matters: it would pass a TC-044 check without proving anything.
   - Fix:
     - Scale every text style 2x. Body 28 sp, labels 24–28 sp, tag and nav labels about 24 sp.
     - Rebuild the frame. The nav bar will need to grow or drop labels.
     - Add a second frame for a screen with chips (for example 1.12), because chip wrapping is the likely failure.

4. **Single-choice questions use ✓ chips, which look like multi-select**
   - Affected: 10.2 Type, Goal and Who can join (163:5859); 11.10 Activity, When, Time, Level and Spots (163:6314); and the "Pick one" onboarding chips (1.5, 1.8, 1.9, 9.12, 9.13).
   - DESIGN.md reserves ✓ chips for multi-select.
   - Fix: use a segmented button for 2–3 options. Use radio cards for 4 or fewer long options.

5. **Chip tap targets cannot meet the 48 dp rule**
   - Chips are 32 px high on a 40 px pitch (8 px gap), measured in the 1.5 metadata.
   - 48 dp hit areas would overlap their neighbours by 8 px, which breaks the "8 dp between targets" rule (TC-045).
   - Chips as narrow as 36 px also exist, for example "6" in 11.10.
   - Fix: raise the pitch to 56 px (32 visual + 24 invisible padding), or accept hit areas that extend only vertically into the gap and write that into the spec. Pick one.

6. **Stale brand name "rhythm"**
   - 8.1 notification app name (163:5256), 10.11 widget label (163:6031), and the 10.4 app-bar URL "rhythm.app/join" (163:5933).
   - Fix: "Lilt" and a Lilt URL.

7. **7.6 Delete everything? (163:5187): the destructive button is neutral**
   - DESIGN.md says the destructive button uses the `danger` token. Here it is a grey outline.
   - The safe choice "Keep my data" is correctly the filled default.
   - "Export a copy first" is a text button indented 12 px from the body text (x60 vs x48).
   - Fix:
     - Make the "Delete everything" label and border `danger` (#B3261E on white is about 6:1).
     - Align the text button with the body text.
     - Keep the filled "Keep my data" as the default.

8. **9.2 Support message (163:5288): the help options do not look like buttons**
   - DESIGN.md calls for buttons to call help. The three rows are icon plus text with no chevron or container.
   - "Call emergency services" has the same weight as "Talk to your doctor".
   - Fix: make "Call emergency services" a filled or tonal 48 px button and the other two outlined rows, each with a visible phone icon.

9. **6.5 Day detail (163:4813): one "Change my answer" for two entries**
   - The sheet lists a Running entry (Partly) and a Gym entry (Not shared) but has a single primary button, so it is unclear which entry it changes.
   - The primary button is also a heavy filled button on what is mostly a read-only sheet.
   - Fix: put an Edit text button on each entry card and drop the filled button.

10. **Join code (10.3 Invite people, 163:5882)**
    - The code "RHY-4KP2" is in Fraunces italic serif. Italic serif letters are easy to confuse when read aloud or typed, for example 1/I/l and 0/O.
    - The invite avatars (Mia, Sam, Ana, Leo) have no selected state, so you cannot tell who has been invited.
    - The solid cobalt 96 px square (the known QR placeholder) has no label.
    - Fix: set the code in an upright sans with letter-spacing, add a ✓ ring on selected avatars, and label the QR "QR code".

11. **Avatar stacks (10.1, 10.6, 11.4, 11.9, 11.11)**
    - These are blank tinted dots with no initials.
    - On 11.11 the "Just posted" event shows three dots with 0 going. That implies attendees who do not exist.
    - The warm and neutral dots have about 1.1:1 contrast against the card, so they read as radio buttons or placeholders.
    - Fix: drop the dots when there are no attendees, and show initials for 1–3 attendees plus a "+N" count.

12. **11.4 Together · events (163:6107)**
    - The "This weekend" filter shows "Wed 29 Oct · Intro to bouldering night", which is not a weekend event.
    - "Any activity", "This weekend" and "Any level" behave as menus but have no chevron.
    - Fix: correct the sample data, and add a ▾ to menu chips.

13. **Segmented tabs (5.1, 5.2, 9.5, 9.6, 11.4, 11.8, 11.9): selected tab has no visible container**
    - I could not see a distinct fill on the selected tab at 1x.
    - Selection is carried by font weight alone, inside a white pill.
    - Verify this in Figma. If confirmed, add a filled indicator in `action-selected` plus a 1 px cobalt outline.

14. **Radio selection style is inconsistent**
    - 4.2 (152:5485) shows a cobalt-filled radio with a white dot.
    - 3.9, 3.11, 10.12 and 11.12 show a white radio with a cobalt ring and an ink-black dot.
    - Fix: pick one and apply it everywhere.

15. **Outlined buttons squeeze the text beside them**
    - 5.2 Saved "Plan" (152:5588): the meta line wraps as "45–60 min · with / others".
    - 11.8 Clubs "Join" (163:6246): titles and meta wrap to two lines.
    - 10.7 Friends "Cheer" (163:5972): the Sam row wraps and the row heights are uneven.
    - Why it matters: it looks ragged now and will break at larger text sizes.
    - Fix: use a text button, or stack the button under the text at larger sizes.
    - 5.2 also has no way to remove an item from Saved. The bookmark is gone, so offer an unsave action.

16. **3.3 Not today (152:4172): pausing is the dominant action**
    - A filled dark "Pause for 1 week" sits under three equal list paths, with "1 week" pre-selected.
    - The visual weight pushes people to pause.
    - Fix: make it an outlined button, and have it appear only after a duration chip is chosen, or leave no duration pre-selected.

17. **11.10 Host an event (163:6314)**
    - "I've read the community guidelines" is not a link, so users cannot read the guidelines.
    - Fix: underline it as an external link.

18. **White boxes behind icons (the known "more" issue is wider than listed)**
    - Seen on: 9.15 (kebab and info), 11.5, 11.6, 11.7 header, 11.9 and 11.11 club rows, and the 11.12 backdrop.
    - In 2.3 the same icon button renders fine.
    - Fix: remove the fill from the IconButton icon frame in the component, so every instance is fixed at once.

19. **11.5 and 11.6 event detail, plus the other event details**
    - Content shifts between the two states. "When" sits at y260 on 11.5 and y254 on 11.6. "Host" sits at 460 and 446. It will jump in a dissolve.
    - Event detail screens use four different hero sizes: 3.10 about 104 px, 10.6 and 11.7 96 px, and 11.5 and 11.6 56 px.
    - At 56 px the art reads as a thumbnail and the "Pickleball" tag repeats next to it.
    - 11.5 "Riverside Pickleball Club" (the host) looks like plain bold text but is a link, and it is indented 12 px.
    - Fix: lock one spacing rhythm across 11.5 and 11.6, pick one hero size for detail screens, and style the host as a visible link.

### POLISH

- **Empty/error illustrations are left-aligned over centred text** on 9.5 (163:5434), 9.6 (163:5450), 9.9 (163:5681) and 11.13 (163:6454). This adds to the known 10.8 issue. 1.15 and 7.7 are centred correctly. Fix the equalizer's internal offset once.
- **Left alignment of the brand mark**: the equalizer sits about 14 px in from the 16 px margin on 1.1 (142:3839) and 10.4.
- **3.12 title is off-centre**: "Back at it" is centred at x152 while the bars and body text are centred at x180, with an orphan "it." on the last line. Centre the title box on the full sheet width.
- **Text buttons indented 12 px from the content edge** (1.1 "See exactly what we store", 2.5 "Change", 2.6, 6.1 "Edit", 9.14, 11.9). Optical alignment would line them up with the 16 px margin.
- **Grid legend**:
  - "Not shared", "Ahead" and "Paused" use near-identical swatches on 6.1 (163:4091), 6.4 (163:4602) and 9.8 (163:5490). On 6.4, days 2, 3 and 6 look the same as 24–31.
  - Merge them, or label "No check-in (pauses count)".
  - Grid contrast, computed from the tokens: `grid-1` #B5BCFF is 1.6:1 against canvas and 1.45:1 against `grid-0`; `grid-0` is 1.13:1; `grid-2` #6C78FF is 3.3:1.
  - Meaning therefore rests on the text summary ("Active on 31 days…") and the semantics labels. That is acceptable only if those stay; keep them.
- **DESIGN.md says grid tiles are never outlines**, but the today tile and the "Ahead" tiles are outlined on 2.3, 9.3, 9.7 and 9.8. Update the doc or the tiles.
- **6.2 Achievements (163:4321)**: earned badges are plain grey discs, which look disabled or like placeholders. Locked ones are dashed outlines. Give earned badges brand colour or art. The copy "Any amount counts" repeats on several cards.
- **Activity art**:
  - The Running art (bars plus an orange dot) reads like a list or menu icon, on 5.1 (152:5542) and 4.3 (152:5510).
  - Social uses a peach tile while the others use lavender.
  - Mark the art as decorative for screen readers.
  - Radius 16 has no token (the known issue).
- **Onboarding**:
  - The primary button moves between steps: y736 on 1.3/1.4, y676 on 1.5–1.11, y680 on 1.12.
  - 1.3 (142:3911) shows an enabled-looking Next while the hint says "Pick at least one".
  - The unselected "Start being active for the first time" card does not look disabled when other options are ticked (1.4).
  - Progress segments are light lavender on canvas, so low contrast but decorative.
  - 1.1 "No streaks to lose" is not on the never-list, but it raises the idea of losing something. "Rest counts too" alone may be calmer.
- **Search**: 1.6 (142:4015) and 9.14 (163:5825) have no back or cancel arrow. 9.1 (163:5264) pre-fills "Ultimate frisbee" while the backdrop says "pil", and the sheet needs to lift above the keyboard.
- **10.8 milestone (163:5999)**: the Display/M title uses the full 328 px on its first line, so it has no slack. The hero is left-aligned (known).
- **2.9 After a break (142:5426)**: "Not now" and "Find my way back" have the same weight, and "back" appears twice.
- **3.10 (152:4911)**: the title "Pickleball" appears twice, in the app bar and the heading. 3.6 (152:4667) has the "Suggested for you" heading 16 px under the chips, tighter than the gap above "Popular".
- **10.1 (163:5835)**: Together is highlighted in the nav bar, but there is no Events/Clubs/Mine control and I found no entry to Challenges from the 11.x frames. Check the prototype wiring.
- **8.1 notification actions** are about 30 px high. That is system-rendered, but be aware.
- **11.7 club blurb**: it wraps to a line starting with "· Sample".
- **10.2 spacing**: the Name label sits 22 px under the Type chips, against about 34 px between other sections.

### Clean or near-clean
1.8–1.11, 1.13, 1.15, 2.1, 2.2, 2.4, 2.6, 2.8, 4.1, 4.4, 5.3, 6.3, 7.2, 7.4, 7.7, 7.8, 9.3, 9.4, 9.10, 9.12, 9.13, 10.5, 10.9, 10.10, 10.12, 11.3. I found nothing beyond the cross-cutting items above.

### Checks that passed
- `text-secondary` #5A6168 on canvas is about 5.7:1, and about 5.0:1 on the grey `action-selected` fill (#E5E7EF).
- Ink #111418 on the Done tile #6C78FF is about 5.2:1.
- The chip border #8A9096 on canvas is about 3.0:1, which is borderline but passes.
- The 11.2 avatar edit button and the 11.2 checkbox row are both 48 px.
- The Discover bookmark buttons are 48 px.

### Top 5 fixes
1. **Re-anchor every bottom sheet** (B1). Cap its height, add 24 dp bottom padding, make the primary button sticky, and fix 11.12 so it reaches the bottom.
2. **Fix 11.11 and the snackbar rules** (B2, S1). Nav at y720, snackbar above it, x16 and 328 wide everywhere (7.5 and 11.6 included).
3. **Make 9.15 a true 200% frame and settle the chip hit-area maths** (S3, S5). This is the evidence for TC-044 and TC-045, and it decides how chip rows are spaced everywhere.
4. **Make the high-stakes screens look like what they are** (S7, S8). Use `danger` on the 7.6 delete button, and turn the 9.2 help options into real buttons.
5. **Do one component sweep to clear many frames at once**:
   - Remove the white fill on icon buttons.
   - Fix the equalizer's internal offset in empty states.
   - Fix the clipped "Delete everything" subtitle.
   - Swap the stale "rhythm" brand text.
   - Make single-choice questions segmented or radio.

---

## Review 2: the reviewer's answer when asked to challenge the sheet-fix plan

This is the "senior reviewer" insight the owner asked for before agreeing to the plan.
It was written in reply to a proposal to anchor sheets to the bottom, cap their height, and give the five tallest sheets a scrolling body with a sticky primary button.

Your plan treats a positioning error as a content-height problem. I'd change step 3 before anyone edits. [V] = verified from frames or metadata, [J] = my judgement.

**1. Scrolling is mostly unnecessary at 100% text. Moving the sheets up fixes B1.**
- [V] Every sheet is shorter than 772 px: 3.8 is 292, 3.12 about 400, 3.2 448, 3.3 541, 3.13 554, 3.11 654, 11.12 562.
- [V] They clip only because their y positions are too low. Bottom edges land at 816–867 px, with no common constant.
- [V] The sheets already carry about 28 px of bottom padding. In 3.2 the button ends at 420 in a 448 sheet.
- So re-anchoring to y = 800 minus height fits all of them. Your steps 1 and 4 are right, but "extend" in step 4 is wrong. 11.12 should move down 29 px (to y238), not stretch.
- Scrolling plus a sticky button is only needed at 200% text and on short phones, for example a 640 dp device against 3.11's 654. [J] That belongs in a spec and a stress-test frame, not in all five frames.

**2. Where I'd choose differently**
- **3.3 (Not today): no sticky Pause button.** [J]
  - A pinned filled "Pause for 1 week" would stay on screen the whole time the user reads the three list paths. That makes pausing the permanent primary, which is the hierarchy problem in my S16.
  - Let the body scroll and keep Pause inline as a secondary section.
  - At 541 px the sheet fits unscrolled, so nothing needs to change at 100%.
- **3.12 and 3.8:** just move them up. [J] Scrolling a celebration or a two-row menu is wrong.
- **3.13:**
  - Shorten the preview card (302 px tall now).
  - DESIGN.md says sharing goes through the system sheet, so this is a preview with one button. It does not need to scroll.
- **11.12:**
  - Five radio cards break the "cards for 4 or fewer" rule in DESIGN.md.
  - [V] Rows of 48 px would save about 100 px.
- **9.1 (type your activity):** the sticky button must sit above the keyboard. [J] Your plan doesn't cover this.

**3. 3.11 (How did it go?)**
- Don't cut the groups. [V] 2.6 shows "Tomorrow's run will be a bit shorter, since energy was low". The "harder" chips feed visible value.
- Don't split it into two steps, because that adds taps to a frequent action. [J]
- Collapse both optional groups under one "Add details (optional)" row. The default sheet is then three radios plus Save, about 400 px. [J]
- A softer option is to show "What made it harder?" only when the answer is Partly or Didn't get to it. [J] That is a product call, so route it to design-reviewer.

**4. How a static frame should show scrolling** [J]
- Draw the sheet at its natural height, fully inside the frame, wherever it fits.
- For the stress cases (3.11, 3.3, 3.13 at 200% or on a 640 px phone):
  - Make a separate frame.
  - Name the layers `scroll-body` and `sticky-footer`.
  - Show one row cut at the fold with a fade, a 1 px divider above the footer, and a text annotation.
- Never leave content clipped at the frame edge without that.

**5. Did I overcall?** [J]
- Yes on severity.
- Genuinely broken, because over half the button is hidden: 3.2 (15 of 48 visible), 3.3 (30), 3.13 (4) and 3.12's "Not now" (19).
- 3.8, 3.1, 1.2, 3.9 and the 5–15 px cases (3.11, 6.5, 9.1, 9.11, 10.3) are layout slop. One position fix clears them, and they are not a UX blocker.
- B1 is really "one production error across about 14 frames", not 14 problems.

**6. Sticky button and padding on 3.3**
- 24 px padding plus a gesture inset fits. [V] The sheet already has about 28 px, and 541 px leaves 259 px of backdrop.
- [J] Add 24–48 dp for 3-button navigation on Android, which brings the sheet to about 565–590 px. It still fits.

**7. Risks to DESIGN.md and 9.15**
- A cap of "800 minus status bar" hides the whole screen behind the sheet. That breaks "the screen behind stays visible" in DESIGN.md. [J] Cap at about 85–90% of the screen height instead.
- The 48 dp close (×) must stay pinned in a sticky header while the body scrolls. Otherwise it breaks the WCAG 2.5.7 requirement in DESIGN.md.
- 9.15 shows only the Today card. Every sheet at 200% exceeds the screen. Add a 200% sheet frame, with 3.3 as the stress test.
- Not checked: whether these sheets are instances of the Sheet component (135:1149). If they are, fix it once there.

**8. Sign-off** [J]
- I'd require:
  - Every sheet inside the frame, which is a metadata check that y + height ≤ 800.
  - One written Sheet spec covering max height, pinned close, scroll body, sticky footer and keyboard behaviour.
  - Stress-test frames at 200% for 3.11, 3.3 and 3.13.
  - A decision on the 3.3 hierarchy.
- I'd refuse:
  - A sticky Pause button on 3.3.
  - Scrolling used to fix the short sheets.
  - A stretched 11.12.
  - Frames that silently clip.

---

## Review 3: re-verification after the fixes

[V] means I checked it in a fresh screenshot or in metadata. [J] is my judgement. Screenshots are 1x.

| # | Item | Result | Evidence |
|---|---|---|---|
| A1 | Sheets end at y800 | PASS [V] | Every `sheet` frame has y+height = 800, including 1.2, 3.1–3.5, 3.8, 3.9, 3.11, 3.12, 3.13, 6.3, 6.5, 7.3, 9.1, 9.11, 10.3, 11.12 (321+479), 3.11b (189:3524, 146+654) and the three 200% frames (80+720). |
| A2 | Close button 8px below sheet top | PASS [V] | All sheets, for example 3.3 is 259 / 267 and 11.12 is 321 / 329. |
| A3 | No primary button clipped | PASS [V] | Every primary button ends at y772, 28px above the frame bottom. |
| A4 | 3.11 collapsed sheet and 3.11b | PASS, wiring unverified | The collapsed sheet shows three radios, "Add details (optional)" and Save. 3.11b has both optional groups and Save visible. Metadata cannot show the prototype link from 3.11 to 3.11b. |
| A5 | 11.12 five 48px rows | PASS [V] | Rows are 49px (48 plus a 1px divider) with the radio style matching 3.9. Meets the "cards for 4 or fewer" rule. |
| A6 | 3.13 smaller hero | PASS [V] | The button now reads "Share…", which fits the system-sheet rule. |
| A7 | 11.11 nav and snackbar | PASS [V] | Nav bar at y720. Snackbar at y656–704, 16px above the nav. |
| A8 | 200% stress frames | PARTIAL | See new issues 1 and 3. |
| B | Snackbars | PASS, one note | 11.6 is x16, 328 wide, y736–784. 7.5 is the same. 2.7 sits about 14–16px above the nav, estimated from a scaled screenshot. On 7.5 the Delete row text ends at y722 and its row box ends at y737, so it overlaps the snackbar by 1px. The snackbar hides the footer line, which is fine. |
| C1 | White icon boxes | PASS | Gone on 11.5, 11.6, 11.7, 11.9, 9.15 and the 11.12 backdrop. On 11.11 the club row is covered by the snackbar, so I cannot see it. |
| C2 | "Lilt" text | PASS [V] | 8.1 "Lilt", 10.11 "Lilt", 10.4 "Join on Lilt". |
| C3 | Delete subtitle | PARTIAL | Verified on 7.1, 7.4 and 7.5 (text box now 298 wide, fits), and 7.6 backdrop. It is not visible on 7.3, 9.10 or 9.11 because sheets or the scroll cut hide it. |
| C4 | Centred illustrations | PASS [V] | 9.5, 9.6, 9.9, 11.13, 10.8. |
| D1 | 11.5 and 11.6 spacing | PASS [V] | When, Where and Host sit at the same y positions in both. |
| D2 | 56px heroes | PASS [V] | 11.5, 11.6, 11.7, 10.6, and the 11.12 backdrop. 3.10 still uses the larger hero. |
| D3 | Avatar stacks | PARTIAL | They overlap with a ring, and "Just posted" has none. But the peach dot is nearly invisible (about 1.1:1 on the card), so three dots read as two on 10.1, 11.4, 11.9 and 11.11. |
| D4 | Runner art | PASS [V] | Reads as a runner on 4.3 and 5.1. The `radius-thumb` 16 token now exists, so the old gap is closed. |
| D5 | Orange #D55900 | PARTIAL [V] | Applies only to the art tokens (`art-comeback`). On 9.5 and 11.8 the `color/eq/comeback` variable is still #FF7A1A. Computed against canvas, that is about 2.4:1 for the bars and about 3.7:1 for the runner dot. |

### New issues, ranked

1. **Stress-frame button labels are left-aligned.**
   - Frames: 3.3 (191:3478), 3.11b (191:3698), 3.13 (191:3898).
   - "Pause for 1 week" spans x44–285 in a button spanning x20–340. "Save" sits at x45–115 and "Share…" at x45–148.
   - At 100% the labels are centred, so this misleads about the 200% behaviour.
   - Fix: centre the labels in those three buttons.
2. **11.6 (163:6200) has only 8px between the content and the primary button.**
   - The "Why it might suit you" block ends at y602 and the "You're going ✓" button starts at y610.
   - Cancel ends at y714, then there are 22px before the snackbar.
   - The cause is the snackbar budget.
   - Fix: reduce the row pitch from 48 to 44 on both 11.5 and 11.6, which saves about 20px and keeps the two matched. Alternatively drop the 8px gap rule on this one screen. I prefer the pitch change. [J]
3. **The stress frames have no on-canvas note saying which scroll state they show.**
   - 3.3 is scrolled to the end, with a half-cut row visible under a 32px fade at the top.
   - A reader can take that cut row for clipping.
   - Fix: add a small label outside each frame, such as "scrolled to end · sticky footer". 3.3 has no sticky footer, as agreed. [J]
4. **The 3.13 preview card is scaled to 200%.**
   - An exported share image should not follow the system text size. [J]
   - "Add details (optional)" on 3.11 has no chevron or expander icon, so it looks like a plain label. [J]
5. **The orange tokens are split across two values** (see D5). Decide whether the brand bars move to #D55900, or whether they are decorative and exempt. [J]

### Sign-off
I would sign off the sheets and the snackbars. The geometry is verified, except 11.6's 8px gap (item 2), which I'd fix first. The stress frames need the label fix in item 1 before they go into the TC-044 evidence.

---

## Status of the reviewer's items (added when this file was saved)

Review 1 and Review 2 findings are tracked in `.claude/figma-state.json`. Since Review 3, new issues 1 and 3 were fixed (labels centred, scroll state written in each stress frame's annotation).
Still open from Review 3: issue 2 (11.6 gap), issue 4 (3.13 preview scaling, the expander chevron), issue 5 (orange split), and the avatar dot tint.
