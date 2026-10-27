# Demo script — Rhythm

> Rana moved house, lost her walking routine, and finds a manageable way back without guilt.
> Walks the PRD happy path (UJ-003 within UJ-002) using the seeded data in
> [`seed/README.md`](../seed/README.md), so every beat is something the audience can actually watch.
> **Length:** 3:00 · **Presenter:** Shieryl (TBD) · **URL:** web demo from [Ops](ops.md) (TBD)

## Before the demo (setup checklist)
1. Fresh browser profile → open the URL → consent → Settings → "Load demo data (synthetic)" →
   persona **Rana**. Start from a known state.
2. Open the public URL in a **clean browser** (no cached data) and run TC-040.
3. Warm up the AI: open Today once so the first AI rewording call is done a minute before.
4. Rehearse every live input below against the **deployed** app at least once. Know that if AI
   fails, options show library text with no label, and the demo still works.
5. Have the recorded backup video ready (APK screen recording on Android).

## The walkthrough
| Time | Beat | Screen | Do | Say (one line) | Proves |
|---|---|---|---|---|---|
| 0:00 | Problem | — | Slide: job statement + evidence boundary | "Staying healthy isn't a knowledge problem. Life changes, and routines stop fitting." | PRD §1 |
| 0:25 | Welcome back | S-005 | Open the app as Rana after her lapse | "No lost streak. Rhythm just says welcome back." | F-005, BR-007 |
| 0:50 | What changed | S-005 | Pick "environment" → "previous approach" | "She tells it what changed; it never assumes why." | BR-008 |
| 1:15 | Today's options | S-004 | Set time 10 min, energy low → one hero option with its reason; tap "Something else" once; open "Why this suggestion?" | "Every option says why it's here. AI only rewords, and it's labelled." | F-002, BR-004, BR-019 |
| 1:45 | Reflect | S-101 | Accept → Completed, enjoyed, with company | "Three taps. That's what Rhythm learns from." | F-003 |
| 2:05 | What works | S-006 | Confirm the "walks with company" observation | "She stays in control of what it learns." | F-004, BR-010 |
| 2:25 | Progress | S-006 | Show the grid: the calm gap (lapse and pause look the same, nothing red), today's tile lit, returns +1 | "Coming back is progress. Pauses aren't failures." | F-006, BR-006 |
| 2:45 | Trust | S-008 | Show export, delete-all | "Data stays on the phone. Off by default, deletable in one tap." | F-007, BR-015..017 |

### 1. Welcome back
Open the app (demo data loaded). Point at "Welcome back" and the absence of any lapse length.
Say: "Rana walked for three weeks, then she moved. Most apps would show a broken streak. Rhythm
asks what changed."

## Live vs. seeded
| What the audience sees | Live or seeded? | Note |
|---|---|---|
| Rana's 45-day history, lapse, pause | Seeded | Synthetic, "Demo data" banner visible |
| Option ranking and reasons | Live | Computed on-device (EQ-003, EQ-004) |
| AI-worded option text | Not in P0 (ADR-006) | Gemini call through Firebase AI Logic; labelled |
| Reflection, observation confirmation, grid update | Live | Written to the local DB during the demo |

Anything cached or scripted is labelled as such on screen, never presented as live.

## If something breaks
| Failure | Fallback |
|---|---|
| AI timeout (dormant in P0, ADR-006) | Nothing to do: library text appears (BR-020). Say "and if AI is unavailable, it still works." |
| Web URL down | Switch to the Android APK on a phone via screen mirroring; else the backup video |
| Demo data not loaded | Settings → Load demo data (takes a few seconds) |
