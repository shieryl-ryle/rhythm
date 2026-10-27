# Lilt app (Flutter)

Walking skeleton (TASK-001): consent screen S-001, then Today S-004 with three hard-coded library actions.
The consent is stored in a local drift database; nothing is stored before the person agrees (BR-014).

## Commands (run from `app/`)
| Do | Command |
|---|---|
| Install packages | `flutter pub get` |
| Generate drift code | `dart run build_runner build --delete-conflicting-outputs` |
| Analyze | `flutter analyze` |
| Test | `flutter test` |
| Run in Chrome | `flutter run -d chrome` |
| Web release build | `flutter build web --release` (output `build/web`, served by `firebase.json`) |
| Android release APK | `flutter build apk --release` |

## Web database assets
drift on the web needs two files in `web/`, matching the resolved package versions in `pubspec.lock`:
- `sqlite3.wasm` from the `simolus3/sqlite3.dart` release `sqlite3-3.5.2`
- `drift_worker.js` from the `simolus3/drift` release `drift-2.34.4`

When `drift` or `sqlite3` change in `pubspec.lock`, download the matching release assets again
(`gh release download <tag> -R <repo> -p <file>`).

## Identifiers still to set
- Android application ID is the scaffold placeholder `com.example.lilt`. Change it before the first store upload
  (see `docs/release.md` §0).
- The release APK is signed with the debug key until the upload keystore exists (`docs/release.md` §2).
- `.firebaserc` holds the placeholder project `TBD-firebase-project-id`.

## Layout
`lib/app/` shell, router and theme tokens · `lib/data/` drift database and repositories · `lib/features/<feature>/`
screens. Design tokens come from `docs/DESIGN.md`.
