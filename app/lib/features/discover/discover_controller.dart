import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/ranking.dart';
import '../today/today_controller.dart';
import '../today/today_data.dart';
import '../today/today_logic.dart';
import 'discover_logic.dart';

/// Everything Discover reads from the database in one go.
class DiscoverInputs {
  const DiscoverInputs({required this.today, required this.savedOrder});

  /// The same inputs Today ranks with, so the two never disagree about what is offered.
  final TodayInputs today;

  /// Saved action ids, most recently saved first.
  final List<String> savedOrder;

  Set<String> get saved => savedOrder.toSet();
}

/// The one place Discover reads and writes rows (saved actions, followed activities).
class DiscoverRepository {
  DiscoverRepository(this._db);

  final LiltDatabase _db;

  Future<DiscoverInputs> load() async {
    final today = await loadTodayInputs(_db);
    final rows = await (_db.select(_db.savedActions)..orderBy([(t) => OrderingTerm.desc(t.savedAt)])).get();
    return DiscoverInputs(today: today, savedOrder: [for (final r in rows) r.actionId]);
  }

  Future<void> setSaved(String actionId, {required bool saved}) async {
    if (saved) {
      await _db.into(_db.savedActions).insertOnConflictUpdate(SavedActionsCompanion.insert(actionId: actionId));
    } else {
      await (_db.delete(_db.savedActions)..where((t) => t.actionId.equals(actionId))).go();
    }
  }

  Future<String?> description(String actionId) async =>
      (await (_db.select(_db.actions)..where((t) => t.id.equals(actionId))).getSingleOrNull())?.description;

  /// "Follow this activity" (frame 3.9): where the person is with it sets the path (docs/data-model.md).
  Future<void> follow(ActivityKind activity, Familiarity familiarity) => _db.transaction(() async {
        final already = await (_db.select(_db.followedActivities)
              ..where((t) => t.activity.equals(activity.code) & t.unfollowedAt.isNull()))
            .get();
        if (already.isNotEmpty) return;
        await _db.into(_db.followedActivities).insert(
              FollowedActivitiesCompanion.insert(
                activity: activity,
                path: switch (familiarity) {
                  Familiarity.alreadyPlay => SetupPath.keepGoing,
                  Familiarity.usedToPlay => SetupPath.pickUpAgain,
                  Familiarity.newToMe => SetupPath.addNew,
                },
                familiarity: Value(familiarity),
              ),
            );
      });

  /// Stops following: the row stays with an end time, so history that points at it still reads.
  Future<void> unfollow(ActivityKind activity) async {
    await (_db.update(_db.followedActivities)..where((t) => t.activity.equals(activity.code) & t.unfollowedAt.isNull()))
        .write(FollowedActivitiesCompanion(unfollowedAt: Value(DateTime.now().toUtc())));
  }
}

final discoverRepositoryProvider = Provider<DiscoverRepository>((ref) => DiscoverRepository(ref.watch(databaseProvider)));

enum DiscoverTab { forYou, saved }

final discoverTabProvider = StateProvider<DiscoverTab>((ref) => DiscoverTab.forYou);
final discoverFilterProvider = StateProvider<Set<DiscoverFilter>>((ref) => const {});

/// S-009 Discover. Nothing here plans anything by itself: "Plan it" is a tap (BR-005).
final discoverControllerProvider = AsyncNotifierProvider<DiscoverController, DiscoverInputs>(DiscoverController.new);

class DiscoverController extends AsyncNotifier<DiscoverInputs> {
  DiscoverRepository get _repo => ref.read(discoverRepositoryProvider);

  @override
  Future<DiscoverInputs> build() async {
    final consent = ref.watch(consentProvider);
    if (consent.isLoading || !(consent.value ?? false)) throw StateError('Discover needs consent');
    await ref.watch(libraryReadyProvider.future);
    // What Today shows changes with a reflection, a follow, a pause or a loaded demo person; so does what is ranked
    // here. Reading it again keeps this list from using a stale person (BR-011).
    ref.watch(todayControllerProvider.select((a) => a.valueOrNull?.grid));
    return _repo.load();
  }

  void _assertConsentNow() {
    final consent = ref.read(consentProvider);
    if (consent.isLoading || !(consent.value ?? false)) throw StateError('Discover needs consent');
  }

  Future<void> _reload() async => state = AsyncData(await _repo.load());

  Future<void> toggleSaved(String actionId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    _assertConsentNow();
    await _repo.setSaved(actionId, saved: !current.saved.contains(actionId));
    await _reload();
  }

  Future<void> follow(ActivityKind activity, Familiarity familiarity) async {
    _assertConsentNow();
    await _repo.follow(activity, familiarity);
    ref.invalidate(todayControllerProvider); // Today's cards follow what the person follows
    await _reload();
  }

  Future<void> unfollow(ActivityKind activity) async {
    _assertConsentNow();
    await _repo.unfollow(activity);
    ref.invalidate(todayControllerProvider);
    await _reload();
  }

  /// "Plan it": puts this idea in the plan at the next free time, only because the person tapped it (BR-005).
  /// The slot is chosen first and the idea ranked for that slot, so "Outdoors after dark" left out is honoured
  /// exactly as on Today (BR-011). Nothing is planned during a pause (BR-006).
  Future<PlanOutcome> plan(String actionId) async {
    final inputs = state.valueOrNull;
    if (inputs == null) return PlanOutcome.unavailable;
    if (ref.read(todayControllerProvider).valueOrNull?.pause != null) return PlanOutcome.paused;
    final today = inputs.today;
    final action = today.actions.where((a) => a.id == actionId).firstOrNull;
    if (action == null) return PlanOutcome.unavailable;
    final slot = upcomingSlots(today.freeTimes, ref.read(clockProvider)()).firstOrNull;
    final ranked = rankOptions(
      actions: [action],
      person: today.person,
      libraryVersion: today.libraryVersion,
      request: RankingRequest(forToday: false, suggestionIsDark: slot?.isDark ?? false),
      limit: 1,
      reasonContext: today.actions,
    );
    if (ranked.isEmpty) return PlanOutcome.unavailable;
    final planned =
        await ref.read(todayControllerProvider.notifier).acceptCompact(TodayOption(ranked: ranked.first, slot: slot));
    return planned ? PlanOutcome.planned : PlanOutcome.unavailable;
  }
}

/// What "Plan it" did, so the message says the true thing.
enum PlanOutcome { planned, paused, unavailable }

/// What the activity detail (3.10) shows.
class ActivityDetail {
  const ActivityDetail({
    required this.item,
    required this.description,
    required this.following,
  });

  final DiscoverItem item;
  final String description;
  final bool following;
}

final activityDetailProvider = FutureProvider.autoDispose.family<ActivityDetail?, String>((ref, actionId) async {
  final inputs = await ref.watch(discoverControllerProvider.future);
  final today = inputs.today;
  final action = today.actions.where((a) => a.id == actionId).firstOrNull;
  if (action == null) return null;
  final ranked = rankOptions(
    actions: [action],
    person: today.person,
    libraryVersion: today.libraryVersion,
    request: const RankingRequest(forToday: false),
    limit: 1,
    reasonContext: today.actions,
  );
  // An idea the person has left out is never shown, even by a saved link (BR-011).
  if (ranked.isEmpty) return null;
  return ActivityDetail(
    item: DiscoverItem(
      ranked: ranked.first,
      saved: inputs.saved.contains(actionId),
      isNew: !today.person.followed.contains(action.activity),
    ),
    description: await ref.read(discoverRepositoryProvider).description(actionId) ?? '',
    following: today.person.followed.contains(action.activity),
  );
});
