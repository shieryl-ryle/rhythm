# SAD — Subagents Document — Rhythm build crew

> **Purpose:** the small roster of build-time AI agents. Each entry materializes into
> `.claude/agents/<name>.md` (Claude Code; other tools such as Cursor can read the same files).
> Add or change an agent here first, then update its file (`add-subagent` skill).

## Roster rules (anti-sprawl)
- Keep the roster small (3–5 agents). Each agent justifies its slot by one of:
  **repeated-spawn** (the task recurs), **context-offload** (it needs lots of reading the main
  session shouldn't hold), or **guardrail-enforcement** (it checks rules independently).
- Least privilege: reviewers and runners are read-only (no Edit/Write).
- Descriptions start with "Use when / before / after …" and must not overlap.
- Model tiers are recommendations (fast · balanced · deep); files use `model: inherit` unless
  there is a reason to pin one.

**Rejected agents:**
| Candidate | Why rejected |
|---|---|
| database / drift agent | Schema written once from the Data Model; the main session owns it |
| ai-engineer agent | The AI adapter is one small module; rules-reviewer covers its guardrails |
| safety-reviewer agent | Overlaps rules-reviewer (BR-001..BR-003, BR-016, BR-020 are already its checks) |
| copywriter agent | Wording list in DESIGN.md + TC-015 enforce tone; not a recurring delegated job yet |

## Agent entries

### rules-reviewer
- **Justification:** guardrail-enforcement
- **Tools:** Read, Grep, Glob, Bash (read-only git)
- **Checks:** PRD BR-001..BR-020 (project checks listed in the agent file); secrets; capability
  drift; owning-doc updates.
- **Output:** `file:line — BR-### — fix`, or "no violations" + what was checked.

### test-runner
- **Justification:** repeated-spawn
- **Tools:** Read, Grep, Glob, Bash
- **Runs:** gates in QA §1 (`flutter analyze`, `flutter test`, integration tests, TC-040 on the
  deployed URL). **Never** edits code to make tests pass; never calls the paid Gemini tier.

### flutter-ui-builder (from `packs/mobile-flutter`)
- **Justification:** repeated-spawn (≈ 16 screens/sheets in the Sitemap)
- **Tools:** Read, Grep, Glob, Edit, Write, Bash
- **Owns (write scope):** one screen's files under `app/lib/features/<feature>/` + shared widgets
  in `app/lib/app/widgets/` it needs, and that screen's tests
- **Inputs:** `docs/sitemap.md`, `docs/user-flow.md`, `docs/DESIGN.md`, `docs/prd.md` §6
- **Caution:** no business logic in widgets (call `app/lib/domain/`); no new packages without
  saying why; verify Flutter APIs via Context7 / Dart MCP.
- **Done when:** all declared states render; `flutter analyze` and the screen's tests pass.

### store-reviewer (from `packs/mobile-flutter`)
- **Justification:** guardrail-enforcement
- **Tools:** Read, Grep, Glob, Bash (read-only)
- **Runs:** only before a store release (none planned before 2026-11-20); checks
  `docs/store-compliance.md`.

### design-reviewer
- **Justification:** guardrail-enforcement + repeated-spawn (wireframes v1, revisions, visual
  design); reviews independently of the session that drew the frames.
- **Tools:** Read, Grep, Glob, Figma MCP read-only (`create_session`, `get_metadata`,
  `get_screenshot`, `get_variable_defs`, `whoami`); never `use_figma`
- **Checks:** PRD G1–G4, personas, BR-### visible in UI; Sitemap screen/state coverage; User Flow
  walkthrough and edge cases; DESIGN.md wording list; owner design decisions (Sitemap §1).
- **Output:** verdict · findings `Section › Frame — severity — source — issue — fix` · coverage
  counts · what's working.

## Materialization
| Agent | File | In sync? |
|---|---|---|
| rules-reviewer | `.claude/agents/rules-reviewer.md` | ✅ |
| test-runner | `.claude/agents/test-runner.md` | ✅ |
| flutter-ui-builder | `.claude/agents/flutter-ui-builder.md` | ✅ |
| store-reviewer | `.claude/agents/store-reviewer.md` | ✅ |
| design-reviewer | `.claude/agents/design-reviewer.md` | ✅ |
