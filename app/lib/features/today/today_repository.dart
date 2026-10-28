import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/enums.dart';
import '../../domain/day.dart';
import '../../domain/models.dart';
import 'today_data.dart';
import 'today_logic.dart';

/// One option that was offered today, with the reason that was shown and the action it points at.
class StoredOffer {
  const StoredOffer({required this.offer, required this.action, required this.reason});

  final OptionOffer offer;
  final ActionInfo action;
  final String reason;

  OfferStatus get status => offer.status;
}

/// A pause as Today needs it: `endDay` is the first day the person is active again (docs/data-model.md: a
/// 1 week pause from Friday 23 October ends Friday 30 October). A null `endDay` means until resumed.
class ActivePause {
  const ActivePause({required this.id, required this.startDay, this.endDay});

  final String id;
  final String startDay;
  final String? endDay;
}

/// Reads and writes what Today stores: the day's options, the plan item an accepted option becomes, and pauses.
/// Everything that changes more than one row runs in one transaction.
///
/// Nothing is planned unless the person accepts (BR-005); a missing reflection stays `unknown` and is never a
/// skip (BR-009).
class TodayRepository {
  TodayRepository(this._db);

  final LiltDatabase _db;

  Future<TodayInputs> inputs() => loadTodayInputs(_db);

  // ---- options

  /// The day's offers, oldest swap first, with their reason.
  Future<List<StoredOffer>> offersFor(String day, Map<String, ActionInfo> actionsById) async {
    final offers = await (_db.select(_db.optionOffers)
          ..where((t) => t.day.equals(day))
          // Insert order is the order of the chain; swap positions count per followed activity, not overall.
          ..orderBy([(t) => OrderingTerm(expression: const CustomExpression<int>('rowid'))]))
        .get();
    final reasons = await (_db.select(_db.offerReasons)..where((t) => t.rank.equals(1))).get();
    final reasonByOffer = {for (final r in reasons) r.offerId: r.reasonText};
    return [
      for (final o in offers)
        if (actionsById[o.actionId] != null)
          StoredOffer(offer: o, action: actionsById[o.actionId]!, reason: reasonByOffer[o.id] ?? ''),
    ];
  }

  /// Writes the hero chain: the options the person can step through with "Something else", all at once, so a
  /// restart cannot reshuffle them (docs/data-model.md `swap_index`). Offers still waiting from an earlier call
  /// today are removed first, so changing the chips re-ranks what has not been acted on.
  Future<void> createHeroChain(String day, TodayPlan plan, TodayChips chips) => _db.transaction(() async {
        await _deleteWaiting(day);
        final followed = await _followedIds();
        for (final option in plan.hero) {
          await _insertOffer(day, option, chips, followed);
        }
      });

  Future<void> _deleteWaiting(String day) async {
    final waiting = await (_db.select(_db.optionOffers)
          ..where((t) => t.day.equals(day) & t.status.equals(OfferStatus.offered.code)))
        .get();
    for (final o in waiting) {
      await (_db.delete(_db.optionOffers)..where((t) => t.id.equals(o.id))).go();
    }
  }

  Future<Map<ActivityKind, String>> _followedIds() async {
    final rows = await (_db.select(_db.followedActivities)..where((t) => t.unfollowedAt.isNull())).get();
    return {for (final r in rows.reversed) r.activity: r.id};
  }

  /// Inserts one offer with the next free swap position for its followed activity, and its reason.
  Future<OptionOffer> _insertOffer(
    String day,
    TodayOption option,
    TodayChips chips,
    Map<ActivityKind, String> followed, {
    OfferStatus status = OfferStatus.offered,
  }) async {
    final followedId = followed[option.ranked.action.activity];
    final taken = await (_db.select(_db.optionOffers)
          ..where((t) => t.day.equals(day) & (followedId == null ? t.followedActivityId.isNull() : t.followedActivityId.equals(followedId))))
        .get();
    final swap = taken.isEmpty ? 1 : taken.map((o) => o.swapIndex).reduce((a, b) => a > b ? a : b) + 1;

    final offer = await _db.into(_db.optionOffers).insertReturning(
          OptionOffersCompanion.insert(
            day: day,
            actionId: option.ranked.action.id,
            suggestedDay: option.slot?.day ?? day,
            followedActivityId: Value(followedId),
            suggestedTime: Value(option.slot?.clock),
            swapIndex: Value(swap),
            status: Value(status),
            timeInputMin: Value(chips.timeMin),
            energyInput: Value(chips.energy),
          ),
        );
    final reason = option.ranked.reason;
    await _db.into(_db.offerReasons).insert(
          OfferReasonsCompanion.insert(
            offerId: offer.id,
            rank: 1,
            reasonCode: reason.code,
            reasonText: reason.text,
          ),
        );
    return offer;
  }

  /// "I'll try this" on an offer that is already stored (the hero card): it becomes `accepted`, and a plan item
  /// with an `unknown` reflection is created with it (docs/data-model.md rules for the code that uses the schema).
  Future<void> accept(StoredOffer stored) => _db.transaction(() async {
        await (_db.update(_db.optionOffers)..where((t) => t.id.equals(stored.offer.id)))
            .write(OptionOffersCompanion(status: Value(OfferStatus.accepted)));
        await _createPlanItem(stored.offer, stored.action);
      });

  /// "I'll try this" on a compact card, which is not stored until now.
  Future<void> acceptNew(String day, TodayOption option, TodayChips chips) => _db.transaction(() async {
        final followed = await _followedIds();
        final offer = await _insertOffer(day, option, chips, followed, status: OfferStatus.accepted);
        await _createPlanItem(offer, option.ranked.action);
      });

  Future<void> _createPlanItem(OptionOffer offer, ActionInfo action) async {
    final item = await _db.into(_db.planItems).insertReturning(
          PlanItemsCompanion.insert(
            source: PlanSource.offer,
            activity: action.activity,
            title: action.title,
            plannedDay: offer.suggestedDay,
            offerId: Value(offer.id),
            actionId: Value(action.id),
            plannedTime: Value(offer.suggestedTime),
            durationMin: Value(action.durationMin),
            withWhom: Value(action.tags.contains('with_company') ? WithWhom.friends : WithWhom.solo),
          ),
        );
    await _db.into(_db.reflections).insert(ReflectionsCompanion.insert(planItemId: item.id));
  }

  /// "Something else": the shown offer becomes `replaced` and the next one in the chain is shown.
  Future<void> replace(StoredOffer stored) =>
      _setStatus(stored.offer.id, OfferStatus.replaced);

  /// "Not today": the shown offer becomes `declined`.
  Future<void> decline(StoredOffer stored) => _setStatus(stored.offer.id, OfferStatus.declined);

  Future<void> _setStatus(String id, OfferStatus status) =>
      (_db.update(_db.optionOffers)..where((t) => t.id.equals(id))).write(OptionOffersCompanion(status: Value(status)));

  /// "Something lighter": the shown offer becomes `replaced` and a new chain from the lighter plan takes over.
  /// No row records the lighter request itself (docs/data-model.md §7, frame 3.3).
  Future<void> swapToLighter(String day, StoredOffer shown, TodayPlan lighterPlan, TodayChips chips) =>
      _db.transaction(() async {
        await _setStatus(shown.offer.id, OfferStatus.replaced);
        await _deleteWaiting(day);
        final followed = await _followedIds();
        for (final option in lighterPlan.hero) {
          await _insertOffer(day, option, chips, followed);
        }
      });

  // ---- pause

  /// The pause that covers [today], or null. A pause covers its start day up to, not including, `endDay`.
  Future<ActivePause?> activePause(String today) async {
    final rows = await (_db.select(_db.pauses)..where((t) => t.kind.equals(PauseKind.pause.code))).get();
    for (final p in rows) {
      final started = p.startDay.compareTo(today) <= 0;
      final notEnded = p.endDay == null || p.endDay!.compareTo(today) > 0;
      if (started && notEnded) return ActivePause(id: p.id, startDay: p.startDay, endDay: p.endDay);
    }
    return null;
  }

  /// "Pause for a while": 3 days, 1 week or 2 weeks from [today] (docs/data-model.md §7, frame 3.3). The shown
  /// offer becomes `declined` ("Not today"); nothing is counted as a miss (BR-006).
  Future<ActivePause> pause(
    String today,
    int days, {
    StoredOffer? shown,
    TodayOption? declinedNew,
    TodayChips chips = const TodayChips(),
  }) =>
      _db.transaction(() async {
        if (shown != null) await _setStatus(shown.offer.id, OfferStatus.declined);
        if (declinedNew != null) {
          await _insertOffer(today, declinedNew, chips, await _followedIds(), status: OfferStatus.declined);
        }
        final row = await _db.into(_db.pauses).insertReturning(
              PausesCompanion.insert(kind: PauseKind.pause, startDay: today, endDay: Value(addDays(today, days))),
            );
        return ActivePause(id: row.id, startDay: row.startDay, endDay: row.endDay);
      });

  /// "Resume now": the pause ends today, so Today shows options again right away. The repository sets
  /// `end_day` to the resume day (docs/data-model.md).
  Future<void> resume(String today) async {
    final active = await activePause(today);
    if (active == null) return;
    await (_db.update(_db.pauses)..where((t) => t.id.equals(active.id))).write(PausesCompanion(endDay: Value(today)));
  }
}

/// Which stored offer Today shows now: the first of the chain still waiting, by swap order.
StoredOffer? shownOffer(List<StoredOffer> offers) {
  final waiting = offers.where((o) => o.status == OfferStatus.offered).toList();
  return waiting.isEmpty ? null : waiting.first;
}
