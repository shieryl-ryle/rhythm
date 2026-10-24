# Mobile pack — Flutter (App Store + Google Play)

Optional add-on for projects that ship a **Flutter** app to the **Apple App Store** and
**Google Play**. Installed by `/choose-stack` when Flutter mobile is chosen — at bootstrap, or
later if a project adds a mobile app. Until installed, it is inactive.

## What it adds
| File | Installed to | Purpose |
|---|---|---|
| `docs/release.md` | `docs/` | Release runbook: versioning, signing, builds, TestFlight / Play testing, submit, rollout |
| `docs/store-listing.md` | `docs/` | App name, descriptions, keywords, icon, screenshots, review notes — for both stores |
| `docs/store-compliance.md` | `docs/` | Store rules checklist: privacy, permissions, account deletion, target SDK, age rating |
| `docs/mobile-qa.md` | `docs/` | Device matrix, platform checks, accessibility, pre-release QA |
| `skills/ship-mobile-release/` | `.claude/skills/` | `/ship-mobile-release` — walks one release end to end |
| `agents/flutter-ui-builder.md` | `.claude/agents/` | Builds one Flutter screen with all states, following DESIGN.md + platform conventions |
| `agents/store-reviewer.md` | `.claude/agents/` | Read-only pre-submission check against store-compliance.md |

## Install (done by `/choose-stack`, or by hand)
1. Copy `docs/*` → `docs/`, `skills/*` → `.claude/skills/`, `agents/*` → `.claude/agents/`.
2. Add the rows below to `docs/index.md` §0, and the docs to the AGENTS.md navigation table.
3. Add `flutter-ui-builder` and `store-reviewer` to `docs/sad.md`.
4. Add "Mobile store distribution" to `docs/capabilities.md` §1.
5. Leave `packs/` in place (other packs may be needed later).

```
| Store release process, versioning, signing (names only) | [Release](release.md) | Mobile |
| Store listing copy and assets | [Store listing](store-listing.md) | Mobile |
| Store rules: privacy, permissions, account deletion, SDK targets | [Store compliance](store-compliance.md) | Mobile |
| Device matrix and mobile QA | [Mobile QA](mobile-qa.md) | Mobile |
```

## Toolbox additions (install per machine)
- **Dart & Flutter MCP server** (official) — lets the agent analyze, fix, run tests, and inspect
  the running app: `claude mcp add --transport stdio dart -- dart mcp-server`
  ([docs](https://docs.flutter.dev/ai/mcp-server))
- **Figma MCP** — read designs into code (already available via claude.ai connectors when authorized).
- **Shorebird** (optional) — code push for Dart fixes without a store review; check current
  pricing and store-policy fit before adopting.
- Context7 for current Flutter / package APIs; frontend-design for less generic UI.

## Requirements
- macOS + Xcode for iOS builds and uploads (Flutter's iOS release guide requires a Mac).
- Apple Developer Program (paid, yearly) and a Google Play Console account (one-time fee).
- Store rules change yearly — every rule in `store-compliance.md` has a source link and a
  "last verified" date; re-verify before each major release.
