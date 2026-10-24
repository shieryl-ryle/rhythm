---
name: choose-stack
description: Use after the PRD exists and before writing System Design, or when the user asks "what should we build this with?", "which framework/technology?", or wants to change platform (e.g. web → mobile). Recommends a stack from the requirements and the team's real experience, records it as an ADR, and installs a matching pack if one exists.
---

# Choose the stack

Recommend — don't default. The right stack depends on what this project needs and who builds it.

## 1. Gather the drivers (from PRD/BRD first; ask only for gaps, max 4 questions per message)
| Driver | Question |
|---|---|
| Platforms | iOS? Android? Web? Desktop? Store distribution required? |
| Team experience | Which languages/frameworks has the team **shipped** with? (weigh heavily — code you can review beats code an AI writes slightly better) |
| Deadline | Hackathon (days) / MVP (weeks) / product (months)? |
| Hard constraints | Required cloud or tools (e.g. "must deploy on Google Cloud"), budget, client mandate, existing codebase |
| Device depth | Camera/AR, background location, Bluetooth, widgets, watch, heavy offline? |
| Data & AI | Realtime? Offline sync? AI calls server-side? Regulated data (finance, health, children)? |
| Machine | Developer OS (iOS builds need macOS + Xcode unless a cloud build service is used) |

## 2. Shortlist 2–3 candidates and compare
Build a table with the drivers as rows and candidates as columns; mark ✅ / ⚠️ / ❌ with one-line
reasons. Typical candidates (not exhaustive — consider others if the drivers point there):
- **Mobile, both stores:** Flutter · Expo (React Native) · native Swift + Kotlin · Kotlin Multiplatform
- **Web app / SaaS:** a full-stack web framework the team knows (e.g. Next.js, Django, Rails, Laravel)
- **Data / AI demo with a short deadline:** Streamlit or Gradio + a Python backend
- **Backend / API:** FastAPI, Node, or a managed backend (Firebase, Supabase)

## 3. Recommend one
- State the pick and the **one deciding reason**. If team experience and another driver conflict,
  say which wins and why.
- Name what would change the decision ("pick native instead if the app becomes Watch-first").
- Verify current versions and any platform requirements with Context7 / official docs; never
  quote versions from memory.

## 4. Record and apply
1. Write an ADR (`write-adr`): context = drivers, options = shortlist table, decision = stack.
2. Fill System Design §6 Stack currency with the chosen versions (verified date).
3. **Packs:** if `packs/` has a pack for this stack (e.g. `packs/mobile-flutter/` for Flutter
   mobile apps), install it per its README. If no pack exists, say so — `adapt-project` will add
   the needed docs and checks as capabilities appear.
4. Update `docs/capabilities.md` §1 with the platform capability (e.g. "Mobile store
   distribution") so later tasks know it's active.

## Re-running later
If the platform changes mid-project (e.g. adding a mobile app to a web product), run this again:
new ADR that supersedes the old one, install any matching pack, and update capabilities.
