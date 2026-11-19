# Submission pack, Future Health Challenge (early screening, 2026-11-16)

Everything below is text to paste into the challenge form and the slide template, plus the video plan. Items in [square brackets] are for the owner to fill in: they are facts the repo does not hold.

## 1. Form fields

| Field | Answer |
|---|---|
| Challenge | [Wellness] Sustaining Healthy Behaviors |
| Solution stage | **Prototype** (not "Pilot-ready": no user has used it yet) |
| Technology type | **Software application** only. Do not tick AI agent, Machine learning or Analytics: the prototype has no AI or learned model, and the ranking is a written formula |
| Prototype / deployment link | https://lilt-app-2026.web.app |
| Software, hardware or both | **Software** |
| Solution deck | `C:Users	endililt-submissionLilt-solution-deck.pdf` (filled template, 0.5 MB; fill in team name, size and members, and the conflict-of-interest slide) |
| Conflict of interest | [owner answers each box for every team member; the repo cannot know] |
| Demo video link | [upload `C:Users	endililt-submissionLilt-demo-video.mp4` to YouTube (unlisted), Vimeo or Drive, viewable by anyone with the link, and paste the link] |

### Solution summary

**Limit: 2000 characters**

```text
Lilt helps adults start, keep up, or come back to physical activity when life gets in the way. It is for the moment after a disruption (a move, a demanding job, a new baby, an illness) when "start again" feels like one overwhelming task and a missed day feels like erased progress.

Lilt does three things differently.

1. One idea at a time, always with the reason. Each suggestion comes from a curated library of 48 activities and is ranked by a transparent, rules-based formula that uses only what the person told us or did: what they finished, what felt good, their free times, their access (gym, pool, courts), their energy, and anything they want left out for personal, cultural or religious reasons. "Why this?" lists every reason, and "Edit" lets them adjust the length and time before anything is planned. Nothing is ever planned without a tap.

2. Progress that only goes up. There are no streaks. A pause (two taps) or a quiet week never reduces anything, and a day with no check-in is stored as "unknown", never as "skipped".

3. A gentle way back. After three quiet days Lilt offers three optional steps (what changed, what to try, one small first step). It never assumes why, and "prefer not to say" is always there. Each return is counted, and totals never go down.

Privacy by design: personal data stays on the device with no account, consent comes first, and the person can export or delete everything. There is no AI model in this prototype; a rules-based approach keeps every reason true and every behaviour testable. Lilt is wellness support, not medical advice, and free text that mentions self-harm, disordered eating or a medical emergency gets a support message instead of a suggestion.

Status: a working web prototype (Flutter) with 624 automated tests. The activity library is a team-written draft, not yet reviewed by a health professional, and we have not yet tested with target users. The demo video uses the Figma design prototype of the same flow.
```

### What has been built during the challenge

**Limit: 1500 characters.** This text says Edit and "Why this?" are live: that is true once the demo build from the merged PR #25 is deployed.

```text
A working, deployed web prototype (Flutter and Dart; runs in a modern browser and is designed for Android and iPhone). Built during the challenge:
- Consent screen, then My starting point: what the person does or used to do, free times, access, what to leave out, what would help.
- Today: up to three ranked options, each with its reason; time and energy chips; "Something else"; "Not today" with a two-tap pause; a plan with Undo; "Why this?"; "Edit" (length and time); and "How did it go?" with a sentence on what will change next.
- My rhythm: a calendar grid of active days, totals (active days, returns after a break), day detail, and observations the person must confirm before they affect anything.
- My Way Back: a welcome-back banner after three quiet days, then three optional steps.
- Discover: browse and filter the library, save ideas, "Plan it", follow or stop following an activity.
- Settings: export all data, delete everything, and three invented demo people.
- A support message reachable before consent.
Engineering: a rules-based ranking with documented formulas; on-device SQLite (Drift); 624 automated tests (ranking, reasons, lapse and return, pause, delete-all, accessibility at 200% text); every change reviewed against written business rules.
Not built: Together (events, clubs, accounts), reminders, adding your own activity from Today, store apps. Not yet done: review of the activity library by a health professional, and sessions with target users.
```

## 2. Slide template, section by section

Template: https://docs.google.com/presentation/d/1esYKP7jdFF1KXzhBR3mjFx5pxv0ECzzZrOWiRmc6pvE (make your own copy, fill it in, File > Download > PDF, check it is 5 MB or less).

**Team Name / Team Size:** [fill in]

**Problem Statement:** [Wellness] Sustaining Healthy Behaviors. When everyday demands or life changes make healthy behaviours hard to sustain, people need a manageable way to start, continue or return, without guilt.

**Team members:** [name, country, role, organization, age confirmation for each]

**Team Capability Summary (max 1,000 characters):**

```text
Flutter and Dart engineering: the prototype was built, tested and deployed by the team within the challenge window, with 624 automated tests and a written set of business rules that each change is reviewed against. Product and UX design: a full design system and about 100 screens drawn in Figma before the build, then reviewed for usability and accessibility (tap targets, text at 200%, contrast). Domain approach: behaviour-change reasoning for people who lapse, an explainable rules-based ranking, and privacy by design (on-device data, consent first, export and delete). Gaps we know about: no exercise-science or clinical reviewer yet, and no user sessions completed; both are planned next.
```

**Architecture or workflow diagram:** draw this as boxes and arrows (I can produce it as an image if you want).
- Person, in a browser or phone, uses the **Flutter app**: Today, Discover, My rhythm, My Way Back, Settings.
- The app calls the **rules layer** (all on device): ranking (EQ-003), reasons (EQ-004), lapse and return (EQ-001, EQ-011), grid (EQ-002), pause.
- The rules layer reads and writes **on-device storage** (SQLite via Drift; WebAssembly in the browser): setup answers, plan, reflections, observations.
- The rules layer reads **bundled content** (JSON): activity library of 48 ideas, red-flag phrases, support text.
- **Firebase Hosting** serves the static files only. No server, no account, no personal data crosses this line.
- Workflow, one loop: starting point, then Today (ranked options with reasons), then accept or edit (a tap), then reflection, then "what changes next", then the grid; a lapse leads to My Way Back.

**Target users and intended outcome:** Adults whose routine was disrupted (a move, a demanding job, new responsibilities, illness) and who find "start again" overwhelming. Outcome: they pick a small step that fits their time, energy, access and preferences, do it, and come back after a break instead of giving up.

**How will success be measured?**
- Return after a lapse: of people who go three quiet days, how many record a return, and how soon (docs/methods.md EQ-001, EQ-011).
- Do the options feel feasible: weekly acceptance = (accepted + light edits) / (accepted + edited + replaced + declined), compared between the first and last week (EQ-010).
- In sessions with target users: how many say the prototype helped them pick a step they could actually do today, reported as a count out of the sessions, with no target set in advance.
- Guardrails: totals never decrease, no guilt or loss wording, nothing planned without a tap (all covered by tests).

**Evidence supporting the approach:** be clear this is design rationale, not proof that Lilt works.
- Some activity is better than none; adults are advised 150 to 300 minutes of moderate activity a week. Bull FC et al. World Health Organization 2020 guidelines on physical activity and sedentary behaviour. *British Journal of Sports Medicine* 2020;54(24).
- Plans that tie an action to a situation (if it is lunchtime, then I walk) help people act on intentions. Gollwitzer PM. Implementation intentions: strong effects of simple plans. *American Psychologist* 1999;54(7):493-503. Lilt ties each idea to one of the person's own free times.
- A single lapse can spiral when the person blames themselves (the "abstinence violation effect"). Marlatt GA, Gordon JR. *Relapse Prevention*. Guilford Press, 1985. This comes from addiction research; we use it as an analogy for designing a no-blame return, not as evidence that Lilt works.
- Our own evidence is small: written responses from six friends (four students, two working people), the founder's experience and one teammate's review. A convenience sample, not representative, not validated in Abu Dhabi.
- Prior testing: automated tests only. No sessions with target users have been completed.

**Data sources and legal right to use them:**
- The person's own answers (setup, plan, reflections, observations): personal and health-related; owner is the person; collected only after consent; stored on their device only; never sent anywhere; can be exported or deleted.
- Activity library (48 ideas): written by the team; owned by the team; not personal data. Draft, not yet reviewed by a professional.
- Red-flag phrase list (115 phrases): written by the team from public crisis-line and eating-disorder guidance; the draft does not yet cite its sources, and we will before any wider use. Used on free text on the device only.
- Support numbers: none listed yet. The support message tells the person to call their local emergency number; no number is added until sourced and verified.
- Demo people: invented, generated with a fixed seed; contain no real person's data.
- Personal data is used: yes, on the device only.

**Risks and safeguards:**
- Privacy: no account, no analytics, no network call that carries personal data; consent first; export and delete-all. Browser storage is not encrypted, so someone with access to the device could read it.
- Security: nothing server-side to breach; the web build is static files; no secrets in the app.
- Bias: the activity library is written by us and has had no cultural or clinical review; leave-outs (including by activity and "outdoors after dark") are never overridden, so people can exclude what does not fit their culture, religion or circumstances. The evidence sample is small and not representative.
- Explainability: every suggestion shows its reasons; the ranking is a written formula, not a model, and the same inputs always give the same answer.
- Misuse: wellness framing only; no diagnosis, treatment, weight or calorie targets, or medication or supplement advice; no streaks or social comparison.
- Human oversight: the person decides; nothing is planned without a tap; a clinical or exercise reviewer is the next step before wider use.
- Failure modes: if no idea fits (everything left out, or too little time) the app says so and plans nothing; a missing check-in is "unknown", not "skipped"; red-flag text gets a support message instead of a suggestion.

**Hardware requirements:** None. Software only.

**Login / access:** No login. Every feature works without an account. Open https://lilt-app-2026.web.app, agree to the consent screen, then either answer the starting-point questions or open Settings (the avatar at the top right) and load an invented person.

**Path to pilot and scale:** the payers and dates below are assumptions.
- Stakeholders: employers' wellbeing programmes, health funds or insurers, public-health bodies, community and workplace activity groups. Who pays is an open hypothesis.
- Next steps: library reviewed by an exercise or health professional; three to five sessions with the target group; a small pilot with one workplace or community group.
- Integration (later): opt-in calendar, wearables, native Android and iPhone apps.
- Regulatory: wellness positioning, not a medical device; consent and data-protection rules of the pilot country; app-store policies for any store release.
- Sustainability: free for people during the challenge; any later funding model is untested.

**Pre-existing IP and third-party materials:** All code, designs and content were created by the team during the challenge window; the repository's first commit is dated 2026-10-24.
- Flutter and Dart (BSD-3, Google), go_router (BSD-3), path_provider (BSD-3).
- flutter_riverpod and riverpod (MIT), drift and drift_flutter (MIT), sqlite3 (MIT), cupertino_icons (MIT).
- Fonts: Geist, Instrument Serif and Unbounded (SIL Open Font License 1.1; the licence files ship in the repo).
- Flutter's bundled Material icons (Apache 2.0).
- Hosting: Firebase Hosting (Google terms of service).
- The name "Lilt" has not been searched for trademark conflicts.

**Conflict of interest declaration:** [owner answers; the form lists six options including "None"]

## 3. Demo video (2 minutes 53 seconds, "Come With Me": an animated family story with a voice-over, then the Figma screens as the mobile app)

Both files are built and saved outside the repo (they are large binaries) in `C:\Users\tendi\lilt-submission\`:
- `Lilt-demo-video.mp4`: the video, 1920x1080, about 19 MB, with a voice-over and captions. It is 2:53.5, under the 3-minute limit.
- `Lilt-solution-deck.pdf`: the filled slide template, about 0.5 MB.

**The story.** It opens with the owner's line: *In many families, health is a tradition. The evening walk after dinner. The Friday game. A grandmother's morning loop around the park.* It then speaks to the viewer as "you", with no named characters. Someone calls from the doorway, "Come with me." Then the shifts changed, dinner got later, and the walks stopped. Four animated scenes tell this with drawn people (a grandmother, you, a neighbour, three people passing a ball). Scene 4 ends with you standing at the door with your shoes on. Twelve app scenes follow: Lilt says welcome back, asks what changed (and lets you say "Prefer not to say"), remembers what helped before, offers ten minutes, waits for your tap, shows its reason, lets you move or shorten it, asks how it went ("Both count"), eases off after a low-energy day, counts rest, and keeps your data on your phone. The last scene is Together, labelled "Coming soon", with a doorway panel beside the phone: someone ties their shoes, the door opens, "Coming?". An end card shows the l·i·l bars, "Start with a little." and the live prototype link.

**What the app scenes show**, in order, all from the "Lilt · Screens" page of the Figma file, in a phone frame: welcome back (2.9), what changed (4.1), what to try (4.2), a smaller first step (4.3), one tap to plan (2.5), why this suggestion (3.1), adjust this (3.2), how did it go (3.11), what changes next (2.6), rest counts (2.3), your data stays on your phone (7.5), and Together (11.4). A spotlight points at one thing per scene, and a pointer taps "Prefer not to say", "I'll try this" and "Today after work".

**Voice.** The voice-over is Chatterbox (Resemble AI), an open-source text-to-speech model under the MIT licence, run locally on CPU. Each scene has its own emotion setting, and the script has "(pause)" and "(softly)" cues. Chatterbox adds an imperceptible watermark to its output. The end card credits it as an AI-generated voice. `make-voice-chatterbox.ps1` regenerates the audio; `node build.js` in `video-work` rebuilds the video. Add the same AI-voice disclosure to the video description when you upload it.

**Animation.** The people are drawn in code (`video-work/anim.js`, outside the repo): jointed figures with a walk cycle, a crouch to tie laces, waving and reaching. The phone scenes slide in over a slowly moving background with captions.

**Labels.** Every scene's footer reads "Lilt · Future Health Digital Innovation Challenge". Together is labelled "Together · Coming soon" and is not claimed as built anywhere. The video does not say "no account", because the Settings screen in Figma shows a Together account row.

**Known differences between the Figma screens and the built app.**
- The Figma "Why this suggestion?" screen says "a reviewed library of activities". That is false (the library is an unreviewed draft), so the video covers that line with a blank strip. The built app already says "a library of activities the Lilt team wrote". Fix the Figma text when you can.
- Its reasons list ("Lunch is one of your free times", "Lunch runs have worked well for you") is illustrative; the built app lists the reasons its rules produce (docs/methods.md EQ-004).
- The Figma Settings screen shows Together and Gentle reminders, which are not built; the video dims those rows and points only at Export and Delete.
- The Figma frames have no "after tap" versions, so taps show the pointer only. The Rest counts frame has no numeric total, so that scene points at the 12-week rhythm grid.

## 4. Before you submit, check

1. Deploy the demo build (PR #25 is merged), then open the live site in a private window at phone width and check: Settings, Demo build, load Noor; on Today open "Why this?" and "Edit", choose 10 min and "Save changes", see "Added to today's plan" and Undo; close Edit without saving and see that nothing was planned.
2. Fill in the brackets that only you can answer: team name and size, team members, the conflict-of-interest answers (the form and the slide), and the video link.
3. The statement that no target-user sessions have been completed is still true when you submit.
