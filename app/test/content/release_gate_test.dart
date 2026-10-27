import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/library/library_models.dart';

import '../support/test_support.dart';

/// Release gate for the content lists (BR-002 says "reviewed text"; ADR-004 requires review before sessions
/// with real people). It is skipped in everyday runs and enforced by the release and study builds:
///
///     flutter test test/content/release_gate_test.dart --dart-define=REQUIRE_REVIEWED_CONTENT=true
///
/// It fails until `reviewed_by` and `reviewed_on` are filled in actions.json and the status no longer says
/// "draft".
const _enforce = bool.fromEnvironment('REQUIRE_REVIEWED_CONTENT');

void main() {
  test('the library has been reviewed for safety and culture', () async {
    final library = parseActionLibrary(await readAssetFile(LibraryAssets.actions));
    expect(library.isReviewed, isTrue, reason: 'status: "${library.status}", reviewed_by: ${library.reviewedBy}');
  }, skip: _enforce ? false : 'Enforced only for release and study builds (REQUIRE_REVIEWED_CONTENT=true)');

  test('a draft library is never counted as reviewed', () {
    const draft = ActionLibrary(
      version: 'v',
      tagCodes: [],
      actions: [],
      status: 'draft: not reviewed',
      reviewedBy: 'someone',
      reviewedOn: '2026-11-01',
    );
    expect(draft.isReviewed, isFalse);
    const reviewed = ActionLibrary(
      version: 'v',
      tagCodes: [],
      actions: [],
      status: 'reviewed',
      reviewedBy: 'someone',
      reviewedOn: '2026-11-01',
    );
    expect(reviewed.isReviewed, isTrue);
  });
}
