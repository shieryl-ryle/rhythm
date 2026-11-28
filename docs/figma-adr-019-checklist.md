# Figma edits for ADR-019 — by-hand checklist (TASK-018, Figma half)

**For:** Shieryl, editing the Figma page **Lilt · Screens** by hand.
**Why by hand:** the Figma connector is on a View seat with 20 calls a month, already used up (2026-11-28), and the Dev
seat is cancelled. Scope narrowed on 2026-11-28 by the owner to the frames that make a privacy claim about Together.
**Safety:** a restore point named "before ADR-019 reconcile" is saved in Figma version history.

Rule for every edit: change the text only. Do not rename frames and do not delete frames, so prototype links keep working.
Frame names below are the numbers on the canvas (the labels in [Build scope](build-scope.md) §3). Use Figma's
search (Ctrl+F in the layers panel, or Ctrl+K on the canvas) to find them.

## A. Edits to make (10 frames and their variants)

| # | Frame | Find | Change to |
|---|---|---|---|
| 1 | 1.1 Welcome & consent | any line that mentions an account or "Together" | "No account needed. Nothing leaves this phone unless you export or share it." |
| 2 | 1.2 What we store | the whole "Together (optional)" block | delete the block; move the sheet's top edge down by the height you removed (about 76–80 dp) so the sheet still hugs its content |
| 3 | 1.2 What we store | "Where it's kept" body | "Only on this phone. No account, no tracking, no ads." |
| 4 | 7.1 Settings, and its 200% variant | the "Together" section label and the "Together account" row | delete both; keep 24 dp above the footer |
| 5 | 7.1 Settings, 7.3, 7.4, 7.5, 7.6, 7.6 dark, 9.10, 9.11 | the same "Together" label and "Together account" row, wherever they show, including in the underlay behind a sheet or dialog | delete both |
| 6 | 7.1 Settings family | delete row sub-line | "Removes all data from this phone" |
| 7 | 7.6 Delete everything? (and dark) | dialog body | "This removes your activities, answers and history from this phone. It can't be undone." |
| 8 | Main screens (header avatar) | blue circle with an "S" | a neutral person icon, as [DESIGN.md](DESIGN.md) already requires |
| 9 | Settings | "Signed in as Sam" | delete the line (there is no signed-in state) |
| 10 | 2.5 and its variants | the Together RSVP card | delete the card |
| 11 | 3.10 | "Find a session near you" | delete the line |

Items 8–11 were found by the ui-reviewer on 2026-11-28; they are not privacy claims but they contradict ADR-019, so do them
if you are in the file anyway. Items 1–7 are the priority.

## B. Left as known gaps (not done, on purpose)

These stay as they are. The docs say the Together frames are reference only.

- The tab bar still draws four tabs ("Nav bar" component set, 63 instances). The app and the docs say three.
- No "Deferred · ADR-019" or "P1 · not in first release" labels on the Together and P1 frames.
- The three older Figma gaps from the build scope, which sit on deferred frames.
- Text in the 10.x and 11.x frames and the signed-out frames that says "Together", "club", "event", "RSVP" or "friend".

## C. When you are done

Tell Claude which items you finished. Claude then updates [DESIGN.md](DESIGN.md), the line in [Sitemap](sitemap.md) about
Figma still drawing four tabs, the Figma ledger (`.claude/figma-state.json`), and closes TASK-018 in the
[implementation plan](implementation-plan.md) with the remaining known gaps listed.

A formal ui-reviewer verdict on this narrowed scope is not possible until Figma access is restored; the reviewer also reads
Figma through the same connector.
