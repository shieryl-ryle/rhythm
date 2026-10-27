# Lilt app (Flutter)

Walking skeleton (TASK-001): consent screen S-001, then Today S-004 with three hard-coded library actions.
The consent is stored in a local drift database. No row is written before the person agrees (BR-014, TC-022);
the empty local store is created on first launch. On the web demo the data sits in the browser, not on a phone.

## Commands (run from `app/`)
| Do | Command |
|---|---|
| Install packages | `flutter pub get` |
| Generate drift code | `dart run build_runner build --delete-conflicting-outputs` |
| Analyze | `flutter analyze` |
| Test | `flutter test` |
| Run in Chrome | `flutter run -d chrome` |
| Web release build | `flutter build web --release --no-web-resources-cdn` (output `build/web`, served by `firebase.json`; self-hosts CanvasKit so no third-party request is made at runtime, BR-015) |
| Android release APK | `flutter build apk --release` |

## Web database assets
drift on the web needs two files in `web/`, matching the resolved package versions in `pubspec.lock`:
- `sqlite3.wasm` from the `simolus3/sqlite3.dart` release `sqlite3-3.5.2`
- `drift_worker.js` from the `simolus3/drift` release `drift-2.34.4`

When `drift` or `sqlite3` change in `pubspec.lock`, download the matching release assets again
(`gh release download <tag> -R <repo> -p <file>`).

## No third-party requests (BR-015)
The web build contacts only its own origin. CanvasKit is self-hosted by `--no-web-resources-cdn`. The body font
Geist is bundled (`assets/fonts/geist/`, SIL OFL 1.1). The engine's default fallback font Roboto is self-hosted in
`web/fonts/roboto/v32/` and wired by `web/flutter_bootstrap.js` (`fontFallbackBaseUrl`). A glyph that none of these
fonts contain would try a further fallback file under `fonts/` and show a missing-glyph box instead of calling out.
Check this after any dependency or Flutter upgrade: open the built site with the network panel and confirm every
request goes to the same origin.

## Identifiers still to set
- Android application ID is the scaffold placeholder `com.example.lilt`. Change it before the first store upload
  (see `docs/release.md` §0).
- The release APK is signed with the debug key until the upload keystore exists (`docs/release.md` §2).

## Layout
`lib/app/` shell, router and theme tokens · `lib/data/` drift database and repositories · `lib/features/<feature>/`
screens. Design tokens come from `docs/DESIGN.md`.
