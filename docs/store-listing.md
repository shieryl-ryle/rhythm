# Store listing — Lilt

> **Owns:** everything users see on the store pages. Product facts come from the [PRD](prd.md);
> visuals from [DESIGN.md](DESIGN.md). Check current character limits and asset sizes in App Store
> Connect / Play Console when filling — they change. Draft written 2026-11-21 for the first TestFlight and App Store
> submission (iOS only; Play comes later, ADR-018). Wording is wellness and fitness only, with no medical claims
> (guidelines 1.4.1 and 5.1.1(ix)).

## 1. Identity
| Field | App Store | Google Play |
|---|---|---|
| App name | **Lilt** (30 characters max). App Store names must be unique: if "Lilt" is taken, use `Lilt: Easy Movement Planner` (26) | TBD after the hackathon |
| Subtitle / short description | `A gentle way back to moving` (27 of 30) | TBD |
| Category | Primary: Health & Fitness. Secondary: Lifestyle | TBD |
| Support URL | https://github.com/shieryl-ryle/rhythm/issues (public; owner to replace if a nicer page exists) | TBD |
| Privacy policy URL | https://lilt-app-2026.web.app/privacy.html (source: `app/web/privacy.html`; **live only after the next web deploy**) | TBD |
| Marketing URL (optional) | https://lilt-app-2026.web.app | TBD |
| Price | Free, no in-app purchases (ADR-017's subscription is not built) | TBD |
| Age rating | Answer the questionnaire honestly in App Store Connect: no user-generated content, no web access, no medical treatment advice; health and wellness topics are covered, so read the result rather than assuming 4+ | TBD |

## 2. Description
**Promotional text (170 max, editable without a new build):**
`No streaks, no guilt. Lilt helps you find a small way back to moving when life gets busy, and it shows you why it suggests what it does.`

**First line (shown before "more"):** Find an easy way back to moving, without guilt or streaks.

**Full description (4,000 max):**
```text
Busy weeks happen. A new job, a move, a hard season, or just a few quiet days, and starting again feels like a lot.

Lilt is a calm planner for coming back to movement. It looks at the time and energy you have today and suggests one small thing that fits, with the reasons in plain words, so you can decide whether it is right for you.

WHAT IT DOES
• Suggests what fits today, sized to your time and your energy. You choose; nothing is planned without your tap.
• Shows its reasons for every suggestion. No black box: the ranking follows written rules you can read.
• Asks how it went, then adjusts tomorrow. A low-energy day means a shorter idea next time.
• Counts the days you were active, and the times you came back. Rest counts too. Pausing never takes anything away, and there are no streaks to lose.
• Offers a gentle way back after a few quiet days, in three optional steps.
• Lets you leave out anything that doesn't suit your culture, your body, your beliefs or your day. Lilt never offers it.

YOUR INFORMATION STAYS WITH YOU
Lilt has no account, no ads and no tracking. What you tell it is stored only on your phone. Export or delete everything any time in Settings.

IMPORTANT
Lilt is a planner for physical activity, not a medical device. It does not diagnose, treat or give medical advice. If you are unwell, talk to a health professional.
```

## 3. Keywords / search
- App Store keywords field (100 max, comma-separated, no spaces, none repeating the app name): `walking,exercise,comeback,routine,gentle,wellness,fitness,habit,planner,rest,energy,restart`
- Play: keywords live naturally in the description.

## 4. Visual assets
| Asset | Spec source | File | Done |
|---|---|---|---|
| App icon (1024 × 1024, no alpha) | Generated from the brand spec (DESIGN.md "Brand motion: the equalizer"): cobalt, bars 44 / 33 / 38 | `app/ios/Runner/Assets.xcassets/AppIcon.appiconset/` | ☑ (owner to approve the look) |
| iPhone screenshots | App Store Connect: 6.9-inch (1320 × 2868) is the required size; others scale | `TBD: assets/store/iphone-*.png` | ☐ (needs a real iPhone or the simulator on a Mac) |
| iPad screenshots | Not needed: the app is iPhone-only for v1 | — | n/a |
| Android phone screenshots | Play Console | TBD after the hackathon | ☐ |
| Play feature graphic | Play Console | TBD after the hackathon | ☐ |
| Preview video (optional) | App Store Connect: up to 30 seconds, real app footage only | `TBD` | ☐ |

**Screenshot storyboard** (each frame = one benefit, real app UI, short caption; no unverifiable claims):
| # | Screen (S-###) | Caption |
|---|---|---|
| 1 | Today with ranked options | "What fits today" |
| 2 | Why this suggestion | "Always with the reasons" |
| 3 | Reflection: how did it go | "Then it adjusts tomorrow" |
| 4 | My rhythm grid | "Rest counts too" |
| 5 | My Way Back | "A gentle way back" |
| 6 | Consent / Settings | "Stays on your phone" |

## 5. Localization
| Language | Listing translated | App translated |
|---|---|---|
| en | ☑ draft above | ☑ |
| TBD: fil | ☐ | ☐ |

## 6. Review information (for store reviewers)
- **Demo account:** none needed. Lilt has no account or login. Every feature works after the first (consent) screen.
- **Notes (draft):** "Lilt has no account. Open the app and tap Agree on the first screen; nothing is stored before that. Then answer the starting-point questions to reach Today. Everything stays on the device: there are no network calls that carry personal data, no analytics, and no permissions are requested. Lilt is a wellness and fitness planner and makes no medical claims."
- **Contact:** TBD: owner's name, phone and email (Apple requires a reachable contact; not stored in this repo).
- **Export compliance:** the app uses no encryption beyond what iOS provides (`ITSAppUsesNonExemptEncryption = false` in Info.plist).
