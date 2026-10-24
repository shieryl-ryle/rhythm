# ADR-003 — Gemini via Firebase AI Logic for bounded rewording

- **Date:** 2026-10-23
- **Status:** Superseded by ADR-006
- **Owners:** Shieryl (team)
- **Related:** [PRD](../prd.md) §2 (hybrid learning), F-002, F-004, BR-002, BR-010, BR-016 · [ADR-002](ADR-002-flutter-android-web-on-device.md)

### Context
The hybrid learning approach uses an LLM only to reword library actions and draft observations for
the user to confirm (BR-002, BR-010). The app has no backend for P0, and an API key must not ship
inside the app. The team chose Gemini with Firebase. Sources checked 2026-10-23:
- Firebase AI Logic is a client SDK plus a Firebase proxy that keeps the Gemini API key on the
  server, with App Check and per-user rate limits.
- The Flutter package is `firebase_ai`, supported on Android and web.
- The Gemini Developer API free tier runs on the no-cost Spark plan; paid tiers need Blaze.
- `gemini-3.5-flash-lite` is the stable "cost-sensitive" model, retiring no earlier than
  2027-07-21.
- **On the free tier, content is "used to improve our products"; on the paid tier it is not.**

### Why now
F-002 and F-004 have an AI path, and the consent text (BR-014, BR-016) must say where data goes.

### Options considered
1. **Firebase AI Logic (client SDK + Firebase proxy).** Pros: no server code; the key stays off
   the device; App Check; Spark (no-cost) plan works with the free tier. Cons: the free tier allows
   content to be used to improve Google products.
2. **Own proxy in Cloud Functions calling the Gemini API.** Pros: full control over prompts and
   redaction on the server. Cons: Cloud Functions require the Blaze plan; more code to secure.
3. **No LLM (library text only).** Pros: simplest and fully deterministic. Cons: weaker on the
   "technical depth" and AI judging criteria; the owner chose the hybrid approach.

### Decision
1. AI calls go through **Firebase AI Logic** (`firebase_ai`) with the **Gemini Developer API**
   provider, protected by **App Check**.
2. Model: **`gemini-3.5-flash-lite`**, set from one config constant (no model IDs scattered in
   code).
3. Prompts contain only de-identified, minimal fields: the library action text, duration,
   intensity, and the user's selected preference tags. They never contain a name, contact
   details, device IDs, or free-text reflections (BR-016).
4. Every AI output passes the safety check (BR-001, BR-002). On failure, timeout, or AI-off, the
   app uses the library's original text.
5. **Tier:** the **free tier is used only for development with synthetic data**. Before any
   real-user session, and for the judged build, the project switches to the **paid tier** (Blaze
   plan with a budget alert), where content is not used to improve Google products. No real user
   data is ever sent while on the free tier.

### Why this option
It gives AI rewording without writing or securing any server code, which fits a 4-week P0 that
has no backend.

### Overrides
- **Prior ADRs:** none
- **Docs to reconcile:** System Design §4 (integrations), Methods (timeouts, call budget), Ops
  (Firebase project, App Check), PRD consent wording (F-007)
- **Out of scope:** P1 circles backend; on-device models

### Consequences
- **Easier:** no backend for P0; the key never ships in the app.
- **Harder / owed:** App Check setup for Android (Play Integrity) and web (reCAPTCHA Enterprise);
  model retirement must be monitored; prompt safety tests.
- **Follow-up:** a task to switch to the paid tier and set a budget alert before the first
  real-user session ([Implementation Plan](../implementation-plan.md)).
