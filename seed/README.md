# Seed data — Rhythm

> Known-state data for development, tests, and the demo. Referenced by
> [Demo script](../docs/demo-script.md) and [Methods](../docs/methods.md) (`DS-001`, `DS-004`).

**Loader:** `app/lib/features/settings/demo_seed.dart` (`DemoSeed`) builds the rows for one persona in Dart,
**relative to the day it is loaded**, so "returned two days ago" is always two days ago. A fixed JSON file would
go stale: the lapse and the return would drift into the past. Same persona and same day give the same rows (no
randomness). It starts with the delete-all path (BR-017), records consent and finishes setup, then writes the
history. Every row has an id that starts with `demo_`, which is how the app knows to label it. Available only in
demo builds (`--dart-define=DEMO=true`), from Settings → "Load demo data: Rana" or "Sam". A release build never
shows it and never loads anything.

```
cd app && flutter run --dart-define=DEMO=true          # then Settings → Load demo data: Rana
# reset: load a persona again (wipes and reseeds), or Settings → Delete everything
```

**Data rules:**
- **Synthetic only:** invented records. No real people, friends' responses, or participant data.
- Deterministic: same persona and same day give the same data, so tests and the demo are reproducible.
- Labelled as synthetic: a "Demo data · invented, not a real person" strip above the tab bar on every main screen
  and at the top of Settings, while any demo row exists. It goes when everything is deleted.

## What the seed contains
| Record / case | Type | Why it exists (which flow, rule, or test needs it) |
|---|---|---|
| Action library v1 (DS-001) | `app/assets/library/actions.json` | All flows; ships in every build, not only demo |
| Red-flag list (DS-002), blocked claims (DS-003) | `app/assets/library/*.json` | BR-001, BR-003; TC-009, TC-011, TC-035, TC-036 |
| Persona "Rana" (returner): moved house; walks; 45 days; regular 3 weeks → 6-day lapse → returns 2 days ago via My Way Back (what changed: environment) | demo seed | UJ-003 demo beat; F-005, F-006; TC-005, TC-029, TC-039 |
| Rana: enjoyed walks "with company" ×4 → one proposed and one confirmed observation | demo seed | F-004, BR-010; TC-018, TC-037 |
| Rana: a 3-day pause during a busy week | demo seed | BR-006 pause marker; TC-014, TC-030 |
| Rana: reflections with `unknown` on some days | demo seed | BR-009; TC-017 |
| Persona "Sam" (starting gentle stretching): ten-minute stretching, mostly partly done, two days skipped for low energy, one never answered; "Team sports" left out | demo seed | F-002 filters, BR-011, grid levels 1–2; TC-019, TC-030 |
| Notification settings on, 1 time, quiet hours default | not seeded yet: reminders are not built, and a setting that says "on" with nothing scheduled would mislead | F-008 display; TC-021 |

## Expected outcomes
Expected results (ranking order, grid levels, lapse and return days, totals) live in
`app/test/fixtures/expected/*.json`, **not** in data the app or the AI model reads, so the system
can't just echo the answer key.
