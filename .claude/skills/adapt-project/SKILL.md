---
name: adapt-project
description: Use when a task, PRD change, or code change introduces a capability that isn't in docs/capabilities.md §1 yet — e.g. adding login, payments, location, camera, notifications, AI features, user content, offline sync, analytics, languages, admin roles, deployment, or store release — or when the user says "we're adding X" / "the requirements changed". Adds the matching rules, tests, docs, checks, and agents before the feature is built.
---

# Adapt the project to a new capability

Goal: the project's rules, tests, and checks grow **before** the code that needs them.

1. **Detect.** Compare the task / PRD change / diff against the trigger column of
   `docs/capabilities.md` §2. List every capability it introduces that is not in §1. If none, stop
   and say "no new capabilities".
2. **Confirm.** Show the user: capability → what will be added (from the catalog row, filtered to
   docs this project actually has). Ask before applying. If a capability isn't in the catalog,
   propose a new catalog row first.
3. **Apply**, in the owning docs only (see `docs/index.md` §0) — link, don't duplicate:
   - PRD: new `BR-###` rules (testable) and acceptance criteria; never renumber existing IDs.
   - QA: matching `TC-###` cases.
   - Methods: any new limits/thresholds as `EQ-###`, marked [assumption] until sourced.
   - Sitemap / User Flow / Data Model / Ops: only the rows the capability needs.
   - Mobile projects: new rows in `store-compliance.md` (with source link + verified date) and
     checks in `mobile-qa.md`.
   - Agents: add checks to `rules-reviewer` (and `store-reviewer` if present), each tied to a BR.
   - Toolbox: suggest any tool the capability needs (e.g. Playwright for public deployment).
   - Packs: if the capability is a platform (e.g. mobile store distribution) and a pack exists,
     install it via `choose-stack`.
4. **Decide.** If the capability involves a real choice (payment provider, auth method, offline
   conflict rule, which law applies), write an ADR with `write-adr`.
5. **Record.** Add the capability to `docs/capabilities.md` §1 with date, task, and the IDs added.
6. **Verify current rules.** For store, legal, or platform requirements, check current official
   sources (web search / Context7) — never rely on memory; put the source link next to the rule.

## Report
Capabilities added, IDs created (BR / TC / EQ / ADR), docs touched, agent checks added, and any
open questions (e.g. legal review needed).
