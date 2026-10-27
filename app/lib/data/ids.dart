import 'dart:math';

final _random = Random.secure();

/// A prefixed random UUID v4, e.g. `plan_3f2b…` (docs/data-model.md §1).
String newId(String prefix) {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 10xx
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${prefix}_${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// The local calendar day as `YYYY-MM-DD` (the grid, lapses and caps work on local days).
String localDay(DateTime moment) {
  final local = moment.toLocal();
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
