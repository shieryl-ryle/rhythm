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
| Solution deck | PDF of the slide template, 5 MB or less (section 2) |
| Conflict of interest | [owner answers each box for every team member; the repo cannot know] |
| Demo video link | [YouTube, Vimeo or Drive link, viewable by anyone with it; under 3 minutes] (script in section 3) |

### Solution summary

**Limit: 2000 characters**

```text
Lilt helps adults start, keep up, or come back to physical activity when life gets in the way. It is for the moment after a disruption (a move, a demanding job, a new baby, an illness) when "start again" feels like one overwhelming task and a missed day feels like erased progress.

Lilt does three things differently.

1. One idea at a time, always with the reason. Each suggestion comes from a curated library of 48 activities and is ranked by a transparent, rules-based formula that uses only what the person told us or did: what they finished, what felt good, their free times, their access (gym, pool, courts), their energy, and anything they want left out for personal, cultural or religious reasons. "Why this?" lists every reason, and "Edit" lets them adjust the length and time before anything is planned. Nothing is ever planned without a tap.

2. Progress that only goes up. There are no streaks. A pause (two taps) or a quiet week never reduces anything, and a day with no check-in is stored as "unknown", never as "skipped".

3. A gentle way back. After three quiet days Lilt offers three optional steps (what changed, what to try, one small first step). It never assumes why, and "prefer not to say" is always there. Each return is counted, and totals never go down.

Privacy by design: personal data stays on the device with no account, consent comes first, and the person can export or delete everything. There is no AI model in this prototype; a rules-based approach keeps every reason true and every behaviour testable. Lilt is wellness support, not medical advice, and free text that mentions self-harm, disordered eating or a medical emergency gets a support message instead of a suggestion.

Status: a working web prototype (Flutter) with 624 automated tests. The activity library is a team-written draft, not yet reviewed by a health professional, and we have not yet tested with target users.
```

### What has been built during the challenge

**Limit: 1500 characters.** This text says Edit and "Why this?" are live: it is only true once PR #25 is merged and the demo build is deployed.

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

**Team Capability Summary (max 1,000 characters):** edit to match the real people.

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
- Prior testing: automated tests only. No sessions with target users have been completed. [Update this if any happen before you submit.]

**Data sources and legal right to use them:**
- The person's own answers (setup, plan, reflections, observations): personal and health-related; owner is the person; collected only after consent; stored on their device only; never sent anywhere; can be exported or deleted.
- Activity library (48 ideas): written by the team; owned by the team; not personal data. Draft, not yet reviewed by a professional.
- Red-flag phrase list (115 phrases): written by the team from public crisis-line and eating-disorder guidance; [add the sources before final]. Used on free text on the device only.
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

**Pre-existing IP and third-party materials:** All code, designs and content were created by the team during the challenge window. [Confirm.]
- Flutter and Dart (BSD-3, Google), go_router (BSD-3), path_provider (BSD-3).
- flutter_riverpod and riverpod (MIT), drift and drift_flutter (MIT), sqlite3 (MIT), cupertino_icons (MIT).
- Fonts: Geist, Instrument Serif and Unbounded (SIL Open Font License 1.1; the licence files ship in the repo).
- Flutter's bundled Material icons (Apache 2.0).
- Hosting: Firebase Hosting (Google terms of service).
- The name "Lilt" has not been searched for trademark conflicts.

**Conflict of interest declaration:** [owner answers; the form lists six options including "None"]

## 3. Demo video (under 3 minutes, a story)

**Record the real app, not Figma.** The form asks for a working prototype and for a video that shows "what your solution does and how it works". The live web app is that, and it has the 624 tests behind it; a Figma-only video would hide it. Use the Figma frames for one thing only: the closing "what comes next" beat (Together, reminders), with a caption "Designed, not built yet". Do not show a Figma frame as if it were the app.

**Story: Noor.** Noor walked every day for two weeks. Then work got busy, and five days went quiet. Most apps would now tell Noor the streak is broken. Lilt does not.

**Setup:** open https://lilt-app-2026.web.app in a private window, browser window about 480 px wide so it looks like a phone, Settings, "Demo build", load Noor. Do a dry run first and fix anything that looks off. Record with any screen recorder and a voice-over; upload to YouTube (unlisted) or Drive (anyone with the link).

| Time | Show | Say |
|---|---|---|
| 0:00 to 0:15 | Title card, then the Lilt wordmark | "Noor walked for two weeks. Then life got busy and five days went quiet. Most apps would say the streak is broken. Lilt says welcome back." |
| 0:15 to 0:40 | Today with the welcome-back banner; tap "Find my way back" | "No guilt, no streak. Just: want help picking a gentle first step? And Noor can skip it." |
| 0:40 to 1:10 | The three steps: what changed (pick "busier" or "prefer not to say"), what to try, a small first step | "It never assumes why. Prefer not to say is always there. Then one small step that fits." |
| 1:10 to 1:45 | Today: the idea and its reason; tap "Why this?"; close; tap "Edit", pick 10 min, "Save changes"; the "Added to today's plan" message | "Every idea says why it is here. Noor can change the length and time. Nothing is planned until Noor taps." |
| 1:45 to 2:10 | "How did it go?", answer "Partly", the "What changes next" sentence; then My rhythm: "Came back 1 time after a break" | "Partly counts. Rest counts. Totals only go up. Coming back is something Lilt celebrates." |
| 2:10 to 2:25 | Discover: the list with reasons, one filter chip | "Discover shows ideas for Noor, with reasons, never anything Noor has left out." |
| 2:25 to 2:40 | Settings: "Export my data", "Delete everything" | "Noor's data stays on the phone. No account. No AI guessing. Export or delete in one tap." |
| 2:40 to 2:55 | Figma frames for Together and reminders, captioned "Designed, not built yet"; then the wordmark and the URL | "Next: gentle reminders and doing it together. Lilt: no streaks, rest counts too." |

Keep it under 3:00; trim the Discover beat first if you run over.

## 4. Before you submit, check

1. PR #25 merged and the demo build deployed, so the live site matches section 1. If you skip #25, delete Edit and "Why this?" from the texts and the video.
2. Every [bracket] above is filled in, especially the conflict-of-interest answers, which only you and the team can give.
3. The statement that no target-user sessions have been completed is still true.
4. Open the live site in a private window and go through the Noor flow once before you record.
