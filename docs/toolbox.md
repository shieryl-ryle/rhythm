# Toolbox — plugins & MCP servers

> External tools that make agents more reliable. They are **installed on your machine, not copied
> into this repo** — install once, they work in every project. This doc owns *which* tools we use,
> *when*, and *how they fit the starter's flow*. Verify install commands against each repo's README
> before running (last checked 2026-10-23).

## Who owns what (avoid two sources of truth)
| Concern | Owner | Tools may help, but… |
|---|---|---|
| What to build | `docs/prd.md` (`/write-prd`) | Superpowers `brainstorming` may explore ideas, but decisions land in the PRD |
| Work ledger | `docs/implementation-plan.md` (`/start-task`) | Superpowers `writing-plans` may plan **inside one TASK**; save to `docs/superpowers/plans/` and link it from the task row |
| Decisions | `docs/adr/` (`/write-adr`) | — |
| Visual tokens | `docs/DESIGN.md` | `frontend-design` styles screens **using** DESIGN.md tokens, never its own palette |

---

## Tier 1 — every project

### Context7 — current library docs
- **Repo:** [upstash/context7](https://github.com/upstash/context7) (MIT)
- **Gives:** version-specific docs and examples for the libraries you actually use, fetched before
  coding.
- **Why:** model knowledge has a cutoff; fast-moving SDKs (Gemini/Vertex, ADK, Streamlit, Next.js)
  change APIs and model IDs. This is how the AGENTS.md "Stack currency" rule gets enforced.
- **Install:** `npx ctx7 setup --claude` (optional free API key raises rate limits)
- **Use:** before writing code against any library in System Design §6, fetch its docs via
  Context7. Record the version checked in the Stack currency table.

### Superpowers — disciplined building
- **Repo:** [obra/superpowers](https://github.com/obra/superpowers) (MIT)
- **Gives:** skills for test-driven development, systematic debugging, verification before
  completion, code review, git worktrees, subagent-driven development, brainstorming, planning.
- **Why:** targets the two most common agent failures — claiming "done" without proof, and fixing
  bugs by guessing.
- **Install:** `/plugin install superpowers@claude-plugins-official`
- **Use by mode:**
  | Skill | App development | Hackathon |
  |---|---|---|
  | `verification-before-completion` | ✅ always | ✅ always |
  | `systematic-debugging` | ✅ always | ✅ always |
  | `test-driven-development` | ✅ | ⚠️ only for core logic (rules, calculations, citation checks) |
  | `requesting-code-review` / `receiving-code-review` | ✅ | ⚠️ before merging risky changes |
  | `brainstorming`, `writing-plans`, `executing-plans` | ✅ inside a TASK | ❌ skip — PRD + task ledger already cover it |
  | `using-git-worktrees`, `subagent-driven-development` | ✅ for parallel work | ⚠️ only with a teammate on separate scopes |

---

## Tier 2 — when it applies

### Playwright MCP — real-browser checks
- **Repo:** [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp)
- **Gives:** the agent can open, click through, and read your app in a real browser.
- **When:** the app has a web UI, and especially when a **deployed URL must work** (hackathon
  submissions, demos). Also for demo screenshots.
- **Install:** `claude mcp add playwright npx @playwright/mcp@latest` (needs Node.js)
- **Use:** `test-runner` runs the clean-browser check on the deployed URL (QA plan) before every
  submission or release. Avoid its arbitrary-code tool unless you need it.

### Google agents-cli — Gemini / ADK agents on Google Cloud
- **Repo:** [google/agents-cli](https://github.com/google/agents-cli) (Apache-2.0) — successor to
  the maintenance-mode `agent-starter-pack`
- **Gives:** skills + CLI to scaffold ADK agents, run evals, deploy to Cloud Run / GKE / Agent
  Runtime, and set up observability.
- **When:** you are building an **agent** (tool-using, multi-step) on Google Cloud. Not needed for
  an app that just calls Gemini once per request.
- **Install:** `uvx google-agents-cli setup` (skills only: `npx skills add google/agents-cli`;
  needs Python 3.11+, uv, Node.js)
- **Use:** let it scaffold the agent code inside the write scope of a TASK; deployment config and
  secret names still go in `docs/ops.md`; its eval results feed `docs/methods.md`.

### frontend-design (Anthropic) — less generic UI
- **Repo:** [anthropics/skills](https://github.com/anthropics/skills)
- **Gives:** guidance that steers UI away from generic, template-looking screens.
- **When:** the project has user-facing screens and looks matter (demos, judged UX, clients).
- **Install:** `/plugin install frontend-design@claude-plugins-official`
- **Use:** fill `docs/DESIGN.md` first; the skill applies those tokens. Optional check:
  `npx @google/design.md lint docs/DESIGN.md` (Windows: `npx -p @google/design.md designmd lint docs/DESIGN.md`).

### Dart & Flutter MCP server (official) — Flutter projects
- **Docs:** [docs.flutter.dev/ai/mcp-server](https://docs.flutter.dev/ai/mcp-server)
- **Gives:** the agent can analyze and fix Dart code, run tests, search pub.dev, and inspect the
  running app.
- **When:** the project uses Flutter (installed with `packs/mobile-flutter`).
- **Install:** `claude mcp add --transport stdio dart -- dart mcp-server` (needs the Dart/Flutter
  SDK on PATH)
- **Use:** `flutter-ui-builder` uses it to verify APIs and run analysis/tests.

---

## Deliberately not used
| Tool | Why |
|---|---|
| GitHub Spec Kit | Duplicates PRD → plan → tasks; two competing sources of truth |
| Bulk subagent collections | Overlapping agents get picked wrongly; follow `docs/sad.md` roster rules |

## Setup checklist (per machine)
- [ ] Context7
- [ ] Superpowers
- [ ] Playwright MCP (web UI projects)
- [ ] agents-cli (Google Cloud agent projects)
- [ ] frontend-design (projects with screens)
- [ ] Dart & Flutter MCP (Flutter projects)
- [ ] Restart Claude Code, then run `/mcp` and `/plugin` to confirm they're loaded
