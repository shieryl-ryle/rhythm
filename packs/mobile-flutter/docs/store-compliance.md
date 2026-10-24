# Store compliance — {{PROJECT_NAME}}

> **Owns:** the store rules this app must satisfy before submission. Each rule has a source and a
> verified date. **Store rules change every year — re-verify every row before each major release**
> and update the date; do not trust this list from memory.
> Checked by the `store-reviewer` agent. Last full verification: {{YYYY-MM-DD}}.

## Apple App Store
| Rule | Applies if | Status | Source | Verified |
|---|---|---|---|---|
| Build with the currently required Xcode / SDK (e.g. from 2026-04-28: Xcode 26 / 26-series SDKs) | Always | {{☐}} | [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) | {{date}} |
| App Privacy details ("nutrition labels") completed and accurate | Always | {{☐}} | App Store Connect → App Privacy | {{date}} |
| Privacy manifest (`PrivacyInfo.xcprivacy`) for the app and included SDKs that require one | Uses required-reason APIs / listed SDKs | {{☐}} | Apple privacy manifest docs | {{date}} |
| In-app **account deletion** offered | App supports account creation | {{☐}} | App Review Guidelines §5.1.1 | {{date}} |
| Permission purpose strings (`NS…UsageDescription`) explain *why*, in plain language | Uses camera, mic, location, photos, etc. | {{☐}} | App Review Guidelines §5.1.1 | {{date}} |
| Sign in with Apple offered when other third-party/social logins are offered (check current exceptions) | Uses social login | {{☐}} | App Review Guidelines §4.8 | {{date}} |
| In-app purchases for digital goods use Apple IAP (check current regional rules) | Sells digital content/features | {{☐}} | App Review Guidelines §3.1 | {{date}} |
| Age rating questionnaire answered (new age-rating system) | Always | {{☐}} | [Apple upcoming requirements](https://developer.apple.com/news/upcoming-requirements/) | {{date}} |
| Demo account + review notes supplied | Login required | {{☐}} | Store listing §6 | {{date}} |
| Not a thin web wrapper; works fully; no placeholder content | Always | {{☐}} | App Review Guidelines §2.1, §4.2 | {{date}} |

## Google Play
| Rule | Applies if | Status | Source | Verified |
|---|---|---|---|---|
| Target API level meets the current requirement (from 2026-08-31: new apps and updates target Android 16 / API 36) | Always | {{☐}} | [Android target SDK requirements](https://developer.android.com/google/play/requirements/target-sdk) | {{date}} |
| **Closed test** with the required number of opted-in testers for the required consecutive days before production (currently reported as 12 testers / 14 days) | New **personal** developer account | {{☐}} | Play Console Help → app testing requirements | {{date}} |
| Data safety form completed and matches actual behaviour (incl. SDKs) | Always | {{☐}} | Play Console → App content | {{date}} |
| Privacy policy URL live and linked | Always (and required for most data collection) | {{☐}} | Play Console → App content | {{date}} |
| Account deletion: in-app path **and** a web link to request deletion | App supports account creation | {{☐}} | Play Console → Data safety / account deletion policy | {{date}} |
| Sensitive permissions declared and justified (location, SMS, contacts, etc.) | Uses them | {{☐}} | Play permissions policy | {{date}} |
| Content rating questionnaire completed | Always | {{☐}} | Play Console → App content | {{date}} |
| Google Play Billing for digital goods (check current regional rules) | Sells digital content/features | {{☐}} | Play payments policy | {{date}} |
| Uploaded as Android App Bundle (`.aab`) with Play App Signing | Always | {{☐}} | Release §3 | {{date}} |

## Both stores
| Rule | Status |
|---|---|
| Privacy policy states exactly what is collected, why, retention, and how to delete | {{☐}} |
| No secrets in the app bundle (keys that grant server access live server-side) | {{☐}} |
| Children / health / finance data — extra rules checked if applicable ({{which}}) | {{☐}} |
| Listing screenshots show the real current app | {{☐}} |
| Local law: {{e.g. Philippines Data Privacy Act RA 10173, GDPR}} | {{☐}} |

## Rejection log
| Date | Store | Reason (quote) | Fix | Rule row added? |
|---|---|---|---|---|
| {{…}} | {{…}} | {{…}} | {{…}} | {{yes}} |
