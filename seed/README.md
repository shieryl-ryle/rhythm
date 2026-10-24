# Seed data — Rhythm

> Known-state data for development, tests, and the demo. Referenced by
> [Demo script](../docs/demo-script.md) and [Methods](../docs/methods.md) (`DS-001`, `DS-004`).

**Loader:** `app/lib/data/seed/seed_loader.dart` reads `app/assets/seed/demo_<persona>.json`,
validates it against the drift schema, and loads it. Idempotent; reset wipes all user tables
first (the same path as delete-all, BR-017). Available only in demo builds
(`--dart-define=DEMO=true`), from Settings → "Load demo data (synthetic)".

```
cd app && dart run tool/gen_seed.dart                 # regenerate demo JSON (fixed seed)
cd app && flutter run --dart-define=DEMO=true          # then Settings → Load demo data
# reset: Settings → Load demo data again (wipes and reseeds), or Delete all
```

**Data rules:**
- **Synthetic only:** invented records. No real people, friends' responses, or participant data.
- Deterministic: same seed → same data, so tests and the demo are reproducible.
- Labelled as synthetic wherever it is shown in the UI (a "Demo data" banner on every screen).

## What the seed contains
| Record / case | Type | Why it exists (which flow, rule, or test needs it) |
|---|---|---|
| Action library v1 (DS-001) | `app/assets/library/actions.json` | All flows; ships in every build, not only demo |
| Red-flag list (DS-002), blocked claims (DS-003) | `app/assets/library/*.json` | BR-001, BR-003; TC-009, TC-011, TC-035, TC-036 |
| Persona "Rana" (returner): moved house; walks; 45 days; regular 3 weeks → 6-day lapse → returns 2 days ago via My Way Back (what changed: environment) | demo JSON | UJ-003 demo beat; F-005, F-006; TC-005, TC-029, TC-039 |
| Rana: enjoyed walks "with company" ×4 → one proposed and one confirmed observation | demo JSON | F-004, BR-010; TC-018, TC-037 |
| Rana: a 3-day pause during a busy week | demo JSON | BR-006 pause marker; TC-014, TC-030 |
| Rana: reflections with `unknown` on some days | demo JSON | BR-009; TC-017 |
| Persona "Sam" (stretched student): stretching + earlier sleep; partial completions; excluded category `eating` | demo JSON | F-002 filters, BR-011, grid levels 1–2; TC-019, TC-030 |
| Notification settings on, 1 time, quiet hours default | demo JSON | F-008 display; TC-021 |

## Expected outcomes
Expected results (ranking order, grid levels, lapse and return days, totals) live in
`app/test/fixtures/expected/*.json`, **not** in data the app or the AI model reads, so the system
can't just echo the answer key.
