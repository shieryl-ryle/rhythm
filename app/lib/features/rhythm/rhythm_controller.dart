import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/day.dart';
import '../today/today_controller.dart';
import 'rhythm_repository.dart';

final rhythmRepositoryProvider = Provider<RhythmRepository>((ref) => RhythmRepository(ref.watch(databaseProvider)));

/// My rhythm (S-006). It reads again whenever Today changes (a new answer lands on the grid and in the totals),
/// and each time it reads it may notice one new pattern (EQ-009).
final rhythmControllerProvider = AsyncNotifierProvider<RhythmController, RhythmData>(RhythmController.new);

class RhythmController extends AsyncNotifier<RhythmData> {
  @override
  Future<RhythmData> build() {
    // Today's own state is the signal that something was answered or planned; the value is not used.
    ref.watch(todayControllerProvider.select((a) => a.valueOrNull?.grid));
    return _read();
  }

  RhythmRepository get _repo => ref.read(rhythmRepositoryProvider);

  Future<RhythmData> _read() async {
    final now = ref.read(clockProvider)();
    final today = formatDay(now);
    await _repo.proposeIfDue(today: today, now: now);
    return _repo.read(today: today, now: now);
  }

  Future<bool> _change(Future<void> Function() action) async {
    try {
      await action();
      state = AsyncData(await _read());
      return true;
    } on Object {
      return false;
    }
  }

  /// "Yes, it fits": suggestions may now use it (BR-010). Returns false when it could not be saved.
  Future<bool> confirm(String id) => _change(() => _repo.confirm(id, now: ref.read(clockProvider)()));

  /// "Not really" or "Remove it": it stops affecting suggestions and is not proposed again (BR-010).
  Future<bool> remove(String id) => _change(() => _repo.delete(id));

  /// The person rewrote it. Returns false when it could not be saved or the text is not allowed.
  Future<bool> edit(String id, String text) async {
    var saved = false;
    final ok = await _change(() async => saved = await _repo.edit(id, text, now: ref.read(clockProvider)()));
    return ok && saved;
  }

  /// Days with a changed answer from the day detail (6.5) land in the grid, the totals and Today.
  Future<void> reload() async {
    ref.invalidate(todayControllerProvider);
    state = AsyncData(await _read());
  }
}

/// What the day detail (6.5) shows for one day.
final dayEntriesProvider = FutureProvider.autoDispose.family<List<DayEntry>, String>(
  (ref, day) => ref.read(rhythmRepositoryProvider).entriesFor(day),
);
