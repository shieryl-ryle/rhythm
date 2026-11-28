# User sessions — Lilt web build

> **Owns:** how to run and report short sessions with target users on the live web build. The hypotheses and success
> signals come from [BRD](brd.md) §11 and the metrics from [PRD](prd.md) §10; this doc only says how to test them.
> **For:** the facilitator (the owner). **Status:** Draft, 2026-11-28. **Nothing here has been run yet.**
> **Build under test:** `https://lilt-app-2026.web.app` (a demo build: Settings can load the invented people).

## 1. What this is, and is not
- 5 to 6 sessions of about 30 minutes, one person at a time, on a phone, with the facilitator watching.
- It tests whether the app is understandable and whether the core idea lands. It does **not** show that Lilt works,
  changes behaviour, or is safe. Five people cannot show that, so never report a percentage.
- Everything is self-report and observation. Report disconfirming results as plainly as supporting ones (BRD BO-002).
- The sample is whoever you can recruit. Say so in the write-up. Friends and family are allowed but must be labelled
  as such, because they may be kind.

## 2. Who to recruit
Aim for at least 3 of 6 from the primary group: adults who **lost an exercise routine in the last year** because
of a move, a job, caring, illness or exams. The rest can be anyone who wants to move more.

| Recruit | Why |
|---|---|
| 3 or more recent routine-losers | Tests the return path and "several disrupted routines feel like one big thing" |
| 1 who has never kept a routine | Tests "start" instead of "come back" |
| 1 using large system text (optional) | Spot-check against TC-044 and TC-045 |

Not for these sessions: anyone currently in treatment for an eating disorder, or advised by a clinician not to
exercise. Lilt is wellness only (BR-001), and a session is not the place to find out.

## 3. Before each session (5 minutes)
1. Open the URL in a **fresh private window** on the phone you will use. Confirm the consent screen appears, and
   that Today's "Edit" and "Why this suggestion?" exist (they came with PR #25, so an old cached build would lack
   them).
2. Have a second private window ready for Part B (see section 5).
3. Know what is **not built** so you can say "not built yet" and note the request: reminders, share cards,
   Together, "edit my starting point". Do not apologise or explain.
4. Open the notes sheet (section 8). Use a participant code (P1, P2, ...), never a name.
5. Do not screen-record unless they agree out loud first. Notes are enough.

## 4. Opening (read this out)
> "Thanks for helping. I'm testing an app, not you. Nothing you do can be wrong, and if something confuses you,
> that's the app's fault and exactly what I need to hear. Please think out loud as you go. I'll mostly stay quiet
> and won't help unless you're stuck for a while, because I want to see what happens when I'm not there.
> You can stop any time. I'll take notes under a code, not your name. The app keeps everything on this phone.
> Is it OK to start?"

Wait for a yes. Then hand over the phone with the app open on the first screen.

## 5. Tasks
Give each task as the line in quotes. Do not name screens or buttons. Note time to start, wrong turns, and
anything said aloud. If they have not started after about 60 seconds, ask "what are you thinking?" once. After about
2 minutes of being stuck, give the smallest hint and mark the task **helped**.

### Part A: their own use (about 15 minutes)
Use real answers if they are comfortable, and invented ones if not. Both are fine. "Prefer not to say" is always
fine.

| # | Say | Watch for | Maps to |
|---|---|---|---|
| A1 | "You've just opened this. Look around the first screen. What do you think it will do with what you tell it?" | Do they understand it stays on the phone? Do they read the consent screen? | F-007, BR-014 |
| A2 | "Set it up the way you would if you were starting today." | Which path they pick and why; where they hesitate; any question they cannot answer | F-001 |
| A3 | "You've got about [their usual free time] today. Pick something you'd actually do." | Do they find the suggestion believable? Do they use Something else, Edit, Why this? | F-002, BR-004 |
| A4 | "Why do you think it suggested that?" (only if they did not already open Why this) | Can they explain the reason in their words? | F-002 |
| A5 | "Pretend it's tonight and you did it. Tell the app how it went." | Is How did it go clear? Do they feel judged by any wording? | F-003, BR-007 |
| A6 | "Now pretend you didn't get to it. Tell it that." | Whether "didn't get to it" feels guilt-free | BR-007, BR-009 |
| A7 | "What does My rhythm tell you? What do the empty days mean to you?" | Whether they read an empty day as failure; whether the grid motivates | F-006, ADR-012 |
| A8 | "Find something you haven't tried that you might like, and keep it for later." | Discover and Saved; whether a suggested new activity is one they would try | F-004, hypothesis 4 |

### Part B: the way back (about 7 minutes)
Loading a person **wipes everything in that browser**, so move to the second private window first.
> "Now I'd like you to pretend to be someone else, Noor. She walked for two weeks, then had five quiet days. I'll set
> her up. Open the app as if you were her."

In the second window: consent, then **Settings, "Load demo data: Noor"**. The strip "Demo data · invented, not a
real person" should show. Then:

| # | Say | Watch for | Maps to |
|---|---|---|---|
| B1 | "What's the first thing you notice?" | Is the welcome-back banner noticed and read as kind? Any sign it feels like a broken streak? | F-005, BR-007 |
| B2 | "Go through it as Noor." | Do the three steps feel like small decisions? Do they use "prefer not to say"? Do they invent a reason the app never asked for? | F-005, BR-008, hypothesis 2 |
| B3 | "Pick Noor's first small step." | Is the step smaller than they expected? Would they do it? | hypothesis 3 |

### Part C: trust (about 2 minutes)
| # | Say | Watch for | Maps to |
|---|---|---|---|
| C1 | "Find out how you would see everything the app has stored about you." | Do they find Export? Do they know what it does (it copies the data, it does not download a file)? | F-007, BR-017 |
| C2 | "Now get rid of it all." | Do they find Delete everything? Is the confirmation clear? | BR-017 |

Finish by doing C2 together in the second window so no demo data is left behind. Close both private windows.

## 6. Questions at the end (ask in this order, then stop)
Ask open first, then the two ratings. Do not defend the app, and do not explain how it works.

1. "In your own words, what is this app for?"
2. "What was the most annoying or confusing moment?"
3. "What, if anything, did you like?"
4. "Think of the last time you stopped exercising. What got in the way? Would this have helped, or not?" *(tests
   BRD hypotheses 1 and 2; listen for the pattern unprompted, and write down their words)*
5. "How doable was the thing it suggested today?" 1 (not at all) to 5 (easily). *(hypothesis 3)*
6. "How likely are you to open it again next week?" 1 to 5. Then: "What would make that a number higher?"
7. "Anything it should never say or do?"

Optional, 3 minutes, only if time and energy allow. The social ideas (hypotheses 5 and 6) are **not built**, and
Together is deferred (ADR-019). Describe in one sentence "an app where friends could see you were active and cheer"
and ask "would that make you more or less likely to keep going?" Mark this clearly in notes as a concept reaction,
never as a test of the product.

## 7. Rules for the facilitator
- **Never lead.** Not "was that clear?" but "what do you think that means?" Not "do you like it?" but "tell me what
  you thought when you saw that."
- **Silence is data.** Count to five before you speak.
- **Do not fix or explain** during the session. Write it down. Fix it afterwards.
- **If someone becomes upset** or mentions self-harm, an eating disorder or a medical emergency: stop, say you are
  glad they told you, point them to a professional or a local helpline, and end the session. The app's own support
  message currently lists no helpline numbers, which is a known gap to report.
- **No health data leaves the phone.** Do not ask them to read out or photograph their real answers. Notes record
  what they did and said about the app, not their health history.
- **Thank them, and offer to share what you change.**

## 8. Notes sheet (one per participant)
```text
Code: P_   Date:   Device / browser:   Group: routine-loser | never-kept | other   Relation: stranger | friend | family
Part A path chosen:            Time in session:

TASK  Started?  Time   Helped?   Wrong turns / hesitation            Quote (verbatim)
A1
A2
A3
A4
A5
A6
A7
A8
B1
B2
B3
C1
C2

Q1 purpose in their words:
Q2 worst moment:
Q3 liked:
Q4 last stopped because / would this have helped:
Q5 doable (1-5):      Q6 open again (1-5):      what would raise it:
Q7 never say or do:
Optional concept reaction (social):

Bugs seen (steps, screen):
Wording that felt judging, even slightly:
```

## 9. Write-up (after the last session)
One page, added to the technical documentation. Facts only.

1. **Who:** number of people, how many were in the primary group, and how many were friends or family.
2. **What happened by task:** for each of A1 to C2, how many started alone, how many were helped, how many could not
   finish. Counts out of the number of people (for example "4 of 6"), never percentages.
3. **Hypotheses (BRD §11 1 to 4):** for each, "supported", "not supported", or "no signal", with two verbatim
   quotes, including at least one that goes against it if any exists.
4. **Ratings:** list the raw Q5 and Q6 numbers, not an average.
5. **Problems found:** a table with severity (blocks a task, slows a task, annoys), the screen, and the fix owner.
   Wording that felt judging goes at the top, because the product's promise is no guilt (BR-007).
6. **What changed because of this**, linked to a PR or an ADR, and what did not and why.
7. **Limits:** convenience sample, self-report only, one session each, a web build on one device each, the activity
   library is a team-written draft (DS-001), and nothing here shows that Lilt changes behaviour.

Do not claim efficacy, retention, or health benefit. Nothing in this study can support those claims.

## 10. What is not covered
- Notifications, share cards and Together, because they are not built.
- Whether people keep using it over weeks. That needs a diary study, which the PRD names as the alternative.
- Safety of the activity suggestions. That needs the library reviewed by an exercise or health professional.
