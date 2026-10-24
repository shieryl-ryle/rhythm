# Agentic Repo Starter

A project starter that AI coding agents (Claude Code, and any tool that reads `AGENTS.md`) can
work in **without chat history**: product docs with one owner each, append-only decision records,
scoped agents and skills, and a setup that **adapts to your requirements as the project grows**.

**Use it for:** hackathons (idea → deployed prototype → pitch), web and AI apps, and mobile apps
shipped to the **App Store and Google Play** (Flutter pack included).

---

## Quick start

**Once per machine** — install the tools in [docs/toolbox.md](docs/toolbox.md) (at least
Context7 and Superpowers).

**Every new project:**
1. Copy this folder and start a fresh git history:
   ```bash
   # macOS / Linux / Git Bash
   cp -r agentic-repo-starter my-project && rm -rf my-project/.git
   cd my-project && git init
   ```
   ```powershell
   # Windows PowerShell
   Copy-Item -Recurse agentic-repo-starter my-project; Remove-Item -Recurse -Force my-project\.git
   cd my-project; git init
   ```
2. Open `my-project` in your editor, start a **new** Claude Code session there, and run
   **`/bootstrap-project`**. Paste a brief if you have one — it answers most questions for you.
3. Start building with **`/start-task`**.

---

## How a project flows

```
/bootstrap-project
   ├─ pick which docs apply (core + optional)
   ├─ /write-brd ............ business case (if judges, clients, or sponsors need one)
   ├─ /write-prd ............ problem, users, features F-###, rules BR-###
   ├─ /choose-stack ......... tech picked from requirements + team experience → ADR → pack
   ├─ capabilities .......... login, payments, AI… each adds its rules, tests, checks
   └─ fill docs, toolbox, first tasks (deployed walking skeleton first if it must ship)

then, for each piece of work:
/start-task ─→ new capability? ─→ /adapt-project ─→ build ─→ test-runner + rules-reviewer ─→ done
                                                    └─ decision made? → /write-adr

mobile release:
/ship-mobile-release ─→ store-reviewer ─→ TestFlight / Play testing ─→ submit ─→ staged rollout
```

## Everyday commands

| Command | When |
|---|---|
| `/bootstrap-project` | Once, right after copying the starter |
| `/write-brd` · `/write-prd` | Draft or revise the business case / product spec |
| `/choose-stack` | Pick the technology — or change platform later (e.g. add a mobile app) |
| `/start-task` | Begin any piece of work |
| `/adapt-project` | A feature brings something new (login, payments, location, notifications, AI, uploads…) — usually triggered for you by `/start-task` |
| `/write-adr` | Any decision someone might later ask "why?" about |
| `/add-subagent` | The same kind of delegated job keeps recurring |
| `/ship-mobile-release` | Releasing to the stores (after the mobile pack is installed) |

---

## It adapts to the project

**At the start — stack from requirements.** `/choose-stack` weighs platforms, deadline, required
cloud, device features, and **what the team has actually shipped with**, compares 2–3 options,
recommends one, and records it as an ADR. Nothing is assumed.

**While building — capabilities.** [docs/capabilities.md](docs/capabilities.md) lists what the app
currently does and a catalog of what each capability requires. When a task introduces a new one,
`/adapt-project` adds the matching rules, tests, store checks, and reviewer checks **before** the
code is written. Example: adding Google sign-in adds an account-deletion rule, login/deletion tests,
and the App Store "Sign in with Apple" and Play "web deletion link" checks.

**Three safety nets** catch anything missed: `/start-task` checks each task, `rules-reviewer`
flags code that adds a capability without its rules, and `/write-prd` re-checks when requirements
change.

## Packs (optional add-ons)

Packs live in `packs/` and stay **inactive** until `/choose-stack` installs one, so a project can
add a platform later.

| Pack | Adds |
|---|---|
| `mobile-flutter` | Release runbook (versioning, signing, TestFlight, Play testing, staged rollout) · store-compliance checklist with official source links and "verified" dates · store listing · mobile QA device matrix · `/ship-mobile-release` · `flutter-ui-builder` and `store-reviewer` agents |

Store rules change yearly, so the pack re-verifies them against official sources before every
release instead of trusting a frozen list.

## Toolbox

External plugins and MCP servers, installed **per machine** (not copied into the repo). Details,
install commands, and "when to use" rules: [docs/toolbox.md](docs/toolbox.md).

| Tier | Tools |
|---|---|
| Every project | **Context7** (current library docs) · **Superpowers** (verify before "done", systematic debugging, TDD) |
| When it applies | **Playwright MCP** (real-browser checks of a deployed URL) · **Google agents-cli** (Gemini/ADK agents on Google Cloud) · **frontend-design** (less generic UI) · **Dart & Flutter MCP** (Flutter projects) |

---

## What's inside

```
CLAUDE.md                      → points to AGENTS.md (one instruction source for every tool)
AGENTS.md                      → router: where to look, commands, rules, definition of done
docs/                          (core = always kept; opt = keep only if it applies)
  index.md                     → core · "one fact, one home" ownership map + ID conventions
  brd.md                       → opt  · business objectives, model, risks (BO-###, RK-###)
  prd.md                       → core · features F-###, journeys UJ-###, rules BR-###
  sitemap.md                   → opt  · screens S-###, routes, access boundaries
  user-flow.md                 → opt  · flows UF-###, edge cases EV-###, instrumentation
  system-design.md             → core · architecture, integrations, security, stack currency
  data-model.md                → opt  · entities, columns, enums
  methods.md                   → opt  · every number/threshold EQ-###, datasets DS-###
  DESIGN.md                    → opt  · visual tokens + component rules (DESIGN.md format)
  qa-test-plan.md              → core · gates, TC-### test cases, exit criteria
  ops.md                       → opt  · deploy, secret names, runbook
  sad.md                       → core · agent roster → .claude/agents/
  toolbox.md                   → core · plugins / MCP servers: which, when, how they fit
  capabilities.md              → core · active capabilities + catalog of what each requires
  implementation-plan.md       → core · TASK-### ledger with owners and write scopes
  demo-script.md               → opt  · timed walkthrough, live vs seeded, fallbacks
  pitch/                       → opt  · pitch kit, business model canvas, visual direction
  adr/                         → core · append-only decision records (template + ADR-001)
seed/README.md                 → opt  · synthetic fixture data + expected outcomes
packs/
  mobile-flutter/              → App Store + Google Play add-on (inactive until installed)
.claude/
  agents/
    rules-reviewer.md          → read-only diff review against BR-### rules + capability drift
    test-runner.md             → runs gates + deployed-URL check, reports evidence, never fixes
  skills/
    bootstrap-project/         → set up a new project (run once)
    write-brd/                 → interview → docs/brd.md
    write-prd/                 → interview → docs/prd.md
    choose-stack/              → requirements + team skills → stack ADR → pack
    adapt-project/             → new capability → rules, tests, checks before code
    start-task/                → claim TASK-###, branch, load only the docs it needs
    write-adr/                 → record a decision correctly
    add-subagent/              → add a specialist agent with the right shape
```

**IDs that tie it together:** `F` feature · `UJ` journey · `BR` rule · `BO`/`RK` business
objective/risk · `S` screen · `UF`/`EV` flow/edge case · `EQ`/`DS` number/dataset · `TC` test ·
`TASK` work · `ADR` decision. IDs are never reused or renumbered.

## Subagent or skill?

| | Subagent (`.claude/agents/*.md`) | Skill (`.claude/skills/*/SKILL.md`) |
|---|---|---|
| Runs | In its own context, returns a result | Inside the current session |
| Best for | Isolated jobs: review, test runs, building one screen | Repeatable procedures and checklists |
| Tool limits | Yes, via `tools:` | Inherits the session's tools |

In both, the `description` line decides when Claude uses it — write it as "Use when …" with
concrete triggers, and don't let two descriptions overlap.

## Principles

- **Route, don't restate.** `AGENTS.md` stays short; each fact lives in exactly one owning doc.
- **Decisions are append-only.** Never edit an Accepted ADR; supersede it.
- **Requirements first, then stack, then code.** The setup grows with the project, not ahead of it.
- **Verify, don't remember.** Library APIs, model IDs, and store rules are checked against current
  official sources, with dates recorded.
- **Start small.** Delete optional docs you don't need; add agents only when a job recurs.

## Moving to a new machine

Copy the `agentic-repo-starter` folder across (zip, USB, or cloud drive), then reinstall the
toolbox — tools are per machine. Everything in this repo is plain Markdown and works the same on
macOS, Windows, and Linux.
