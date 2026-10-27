import 'dart:convert';

import 'database.dart';

/// A step that must run when everything is deleted, such as cancelling scheduled notifications
/// (EQ-005) or deleting a Together account and its server data (BR-017).
typedef DeleteAllHook = Future<void> Function();

/// Export and delete-all for My Data (F-007, BR-017).
class MyDataService {
  MyDataService(this._db, {this.hooks = const []});

  final LiltDatabase _db;

  /// Run before any local row is removed. If one throws, nothing is deleted, so the person can retry.
  final List<DeleteAllHook> hooks;

  /// Children first, so foreign keys never block a delete. Must list every user table: [deleteAll]
  /// throws if a table is missing, so a new table cannot be forgotten.
  static const deleteOrder = <String>[
    'reflection',
    'offer_reason',
    'plan_item',
    'option_offer',
    'saved_action',
    'followed_activity',
    'preference',
    'pause',
    'observation',
    'return_event',
    'achievement_earned',
    'notification_setting',
    'profile',
    'consent',
  ];

  /// Every user table as a list of rows, exactly as stored (enums as their codes, comma sets as comma
  /// text, booleans as 0 or 1, dates as UTC ISO-8601). The library table `action` is not personal data.
  Future<Map<String, Object?>> exportData() async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final table in _db.userTables) {
      final name = table.actualTableName;
      final rows = await _db.customSelect('SELECT * FROM "$name"', readsFrom: {table}).get();
      tables[name] = rows.map((row) => row.data).toList();
    }
    return {
      'app': 'Lilt',
      'export_version': 1,
      'schema_version': _db.schemaVersion,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'tables': tables,
    };
  }

  /// The export as a readable JSON document.
  Future<String> exportJson() async => const JsonEncoder.withIndent('  ').convert(await exportData());

  /// Removes every local record, including the consent log, so the app returns to the consent screen.
  /// It cannot be undone (BR-017). The library table `action` is kept.
  Future<void> deleteAll() async {
    final userTableNames = _db.userTables.map((t) => t.actualTableName).toSet();
    if (userTableNames.length != deleteOrder.length || !userTableNames.containsAll(deleteOrder)) {
      throw StateError(
        'MyDataService.deleteOrder does not match the user tables: '
        '${userTableNames.difference(deleteOrder.toSet())} missing, '
        '${deleteOrder.toSet().difference(userTableNames)} unknown.',
      );
    }
    for (final hook in hooks) {
      await hook();
    }
    await _db.transaction(() async {
      for (final name in deleteOrder) {
        await _db.customStatement('DELETE FROM "$name"');
      }
    });
  }
}
