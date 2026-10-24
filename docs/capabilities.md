# Capabilities — Rhythm

> **Owns:** which product capabilities are active, and what each one requires the project to
> have. This is how the setup **grows while building**: when a task introduces a capability that
> isn't active yet, run `/adapt-project` *before* coding it.
> §1 is project-specific (keep it current). §2 is the catalog (generic; extend it when you learn
> something new).

## 1. Active capabilities
| Capability | Since | Added by | Requirements applied (BR / TC / docs / agents) |
|---|---|---|---|
| Mobile store distribution (Android APK now; store release later) | 2026-10-23 | bootstrap ([ADR-002](adr/ADR-002-flutter-android-web-on-device.md)) | `packs/mobile-flutter` installed: release, store-listing, store-compliance, mobile-qa docs; `flutter-ui-builder`, `store-reviewer` agents; `/ship-mobile-release` |
| Public deployment (Flutter web demo on Firebase Hosting) | 2026-10-23 | bootstrap | Ops deploy and runbook; TC-040 clean-browser check; Playwright MCP in Toolbox |
| Personal data, health-adjacent (regulated domain: wellness) | 2026-10-23 | bootstrap ([ADR-004](adr/ADR-004-wellness-positioning-and-privacy-baseline.md)) | BR-001, BR-003, BR-014..BR-017; TC-009, TC-011, TC-022..TC-025; personal fields marked in Data Model; store-compliance privacy rows; legal review open (ADR-004) |
| Local notifications | 2026-10-23 | bootstrap (F-008) | BR-007, BR-012, BR-013; EQ-005; TC-008, TC-020, TC-021, TC-041; Mobile QA deep-link check |
| AI / LLM (bounded rewording via Firebase AI Logic) | 2026-10-23 | bootstrap ([ADR-003](adr/ADR-003-gemini-via-firebase-ai-logic.md)) | BR-002, BR-010, BR-016, BR-019, BR-020; EQ-006, EQ-007; TC-010, TC-018, TC-024, TC-027, TC-028, TC-042; Ops: model ID constant, budget alert; AI-worded label |
| Offline-first (on-device only, no sync) | 2026-10-23 | bootstrap | Data Model: local drift store, no conflict rule (single device); TC-043 offline; Mobile QA offline check |

## 2. Catalog — triggers → what to add
Triggers are signals in a task, PRD change, or diff. "Add" means: create the item if missing,
using the project's existing docs (skip docs the project doesn't have).

| Capability | Triggers (task words / code signals) | Add |
|---|---|---|
| **Accounts & login** | sign up, login, auth, password, OAuth/social login; auth packages | BR: account deletion, password/session rules · TC: login, logout, deletion · Sitemap: auth screens + access zones · Ops: auth secrets names · Mobile: store-compliance rows (account deletion; Sign in with Apple if social login) |
| **Personal data** | profile, email, phone, address, contacts, photos of people | BR: data minimization, retention, export/delete · Privacy policy items · Data Model: personal fields marked · Mobile: App Privacy + Data safety rows · Local law row (e.g. RA 10173 / GDPR) |
| **Payments** | pay, checkout, subscription, premium, in-app purchase; payment SDKs | ADR: provider + store billing rules · BR: no card data stored, receipts, refunds · TC: success / failure / cancel / restore · Ops: webhook + key names · Mobile: store billing compliance row |
| **Location** | map, nearby, GPS, geofence, tracking | BR: purpose + precision + background use · Permission purpose strings · TC: denied / approximate / background · Mobile QA: permission states |
| **Camera / mic / photos / files** | upload, scan, record, attach, camera | BR: what's stored, where, size limits · Permission strings · Ops: storage bucket names · TC: denied permission, large file, bad format · Methods: size/duration limits (EQ) |
| **Push notifications** | notify, remind, alert, push | BR: opt-in, quiet hours, no engagement spam · TC: permission denied, tap opens right screen · Ops: push credentials names · Mobile QA: deep link from notification |
| **AI / LLM features** | AI, summarize, chat, generate, recommend; model SDKs | BR: grounding/citations, refusal when unknown, no secrets in prompts, no logging of personal data · Methods: thresholds, timeouts, call budget (EQ) · TC: timeout, empty, adversarial input · Ops: model ID env var, quota alerts · Disclosure that content is AI-generated |
| **User-generated content** | comments, posts, reviews, uploads by users | BR: moderation, reporting, blocking · TC: report flow, abusive input · Mobile: store UGC rules (report/block required) |
| **Offline / sync** | offline, cache, sync, airplane mode | Data Model: local store + conflict rule (ADR) · TC: offline edit, reconnect, conflict · Mobile QA: offline checks |
| **Analytics / tracking** | analytics, track, events, attribution SDKs | User Flow §6 events (no personal data) · Privacy policy + store privacy rows · Mobile: tracking-permission rule if cross-app tracking |
| **Localization** | translate, language, locale | BR: every string in all supported languages · TC: switch language, long strings · Store listing languages |
| **Roles & admin** | admin, moderator, staff, permissions | Sitemap access zones · BR: server-side role checks · TC: forbidden access per role · rules-reviewer check |
| **Public deployment** | deploy, URL, host, launch | Ops doc (deploy, secrets names, runbook) · health check · Playwright clean-browser check · budget alert |
| **Mobile store distribution** | App Store, Play Store, TestFlight, release | Install the mobile pack for the stack (e.g. `packs/mobile-flutter/`) via `choose-stack`; if no pack, add release / store-compliance / store-listing / mobile-qa docs from the closest pack as a guide |
| **Regulated domain** | finance, health, children, education records | ADR: which laws/rules apply · BR per rule · store-compliance extra rows · rules-reviewer checks · legal review noted as an open question |

**Unknown capability?** If a task introduces something not in the catalog, `/adapt-project` adds
a new catalog row first (triggers + what to add), then applies it.
