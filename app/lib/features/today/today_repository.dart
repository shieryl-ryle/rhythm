import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/enums.dart';
import '../../domain/day.dart';
import '../../domain/lapse.dart';
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

/// One thing in the plan with how it went. [reflection] is `unknown` until the person answers (BR-009).
class PlannedItem {
  const PlannedItem({required this.item, required this.reflection, required this.action});

  final PlanItem item;
  final Reflection reflection;

  /// Null for a one-off the person typed in, or an action no longer in the library.
  final ActionInfo? action;

  bool get isOpen => reflection.status == ReflectionStatus.unknown;
  String get title => item.title;
}

/// How many days back an unanswered item is still offered under "From earlier" [assumption]. It is not deleted
/// or counted as anything when it ages out (BR-009): it just stops asking.
const reflectWindowDays = 7;

/// How far up the scale an answer is: an answer may be changed to the same or a higher one, never lowered
/// (BR-007, EQ-011, docs/data-model.md rules for code that uses the schema).
int reflectionRank(ReflectionStatus status) => switch (status) {
      ReflectionStatus.completed => 2,
      ReflectionStatus.partly => 1,
      ReflectionStatus.skipped || ReflectionStatus.unknown => 0,
    };

/// The answers a person can change `from` to: all three for something not answered or answered "didn't get to it",
/// "partly" or "done" for partly, only "done" for done.
Set<ReflectionStatus> allowedAnswers(ReflectionStatus from) => {
      for (final s in [ReflectionStatus.completed, ReflectionStatus.partly, ReflectionStatus.skipped])
        if (from == ReflectionStatus.unknown || reflectionRank(s) >= reflectionRank(from)) s,
    };

enum ReflectionSave {
  saved,

  /// The new answer was lower than the one stored, so nothing was written.
  refusedLower,

  /// The plan item is gone.
  missing,
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

  // ---- plan and reflections

  /// The plan: everything planned for today or later, and anything from an earlier day that has not been
  /// answered yet (so it can still be reflected on, UF-003). Read by the day it was planned for, not the day it
  /// was offered. Ordered by day and time.
  Future<List<PlannedItem>> planItems(String today, Map<String, ActionInfo> actionsById) async {
    final rows = await (_db.select(_db.planItems).join([
      innerJoin(_db.reflections, _db.reflections.planItemId.equalsExp(_db.planItems.id)),
    ])
          ..orderBy([
            OrderingTerm(expression: _db.planItems.plannedDay),
            OrderingTerm(expression: _db.planItems.plannedTime),
            OrderingTerm(expression: const CustomExpression<int>('plan_item.rowid')),
          ]))
        .get();
    final since = addDays(today, -reflectWindowDays);
    return [
      for (final r in rows)
        if (r.readTable(_db.planItems).plannedDay.compareTo(today) >= 0 ||
            (r.readTable(_db.reflections).status == ReflectionStatus.unknown &&
                r.readTable(_db.planItems).plannedDay.compareTo(since) >= 0))
          PlannedItem(
            item: r.readTable(_db.planItems),
            reflection: r.readTable(_db.reflections),
            action: actionsById[r.readTable(_db.planItems).actionId],
          ),
    ];
  }

  /// Saves how it went (docs/data-model.md §7, frame 3.11). The barrier is asked only after "partly" or "didn't get
  /// to it" (BR-008), so it is cleared for "done"; enjoyment is not asked after "didn't get to it". Changing an
  /// answer to "done" clears the barrier.
  ///
  /// An answer is never lowered: Done cannot become Partly or Didn't get to it, and Partly cannot become Didn't get
  /// to it, because that would take a day away from active days and the grid (BR-007, EQ-011). The follow-ups
  /// (barrier, enjoyment) can always be changed.
  Future<ReflectionSave> saveReflection(
    String planItemId, {
    required ReflectionStatus status,
    int? enjoyment,
    Barrier? barrier,
  }) async {
    if (status == ReflectionStatus.unknown) throw ArgumentError.value(status, 'status', 'an answer is required');
    final asksBarrier = status == ReflectionStatus.partly || status == ReflectionStatus.skipped;
    final asksEnjoyment = status != ReflectionStatus.skipped;
    return _db.transaction(() async {
      final current =
          await (_db.select(_db.reflections)..where((t) => t.planItemId.equals(planItemId))).getSingleOrNull();
      if (current == null) return ReflectionSave.missing;
      if (current.status != ReflectionStatus.unknown && reflectionRank(status) < reflectionRank(current.status)) {
        return ReflectionSave.refusedLower;
      }
      await (_db.update(_db.reflections)..where((t) => t.planItemId.equals(planItemId))).write(
        ReflectionsCompanion(
          status: Value(status),
          enjoyment: Value(asksEnjoyment ? enjoyment : null),
          barrier: Value(asksBarrier ? barrier : null),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ReflectionSave.saved;
    });
  }

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
        final acted = await _actedActionIds(day);
        for (final option in plan.hero) {
          // An option already stepped past, declined or accepted today is not offered again.
          if (acted.contains(option.ranked.action.id)) continue;
          await _insertOffer(day, option, chips, followed);
        }
      });

  Future<Set<String>> _actedActionIds(String day) async {
    final rows = await (_db.select(_db.optionOffers)
          ..where((t) => t.day.equals(day) & t.status.equals(OfferStatus.offered.code).not()))
        .get();
    return {for (final o in rows) o.actionId};
  }

  /// A waiting option whose suggested time has passed is moved to the next free slot, so Today never shows or
  /// plans a time in the past. Only the time changes: the options and their order stay (no reshuffle).
  Future<void> reslotWaiting(String day, SuggestedSlot? slot) async {
    final waiting = await (_db.select(_db.optionOffers)
          ..where((t) => t.day.equals(day) & t.status.equals(OfferStatus.offered.code)))
        .get();
    for (final o in waiting) {
      await (_db.update(_db.optionOffers)..where((t) => t.id.equals(o.id))).write(
        OptionOffersCompanion(suggestedDay: Value(slot?.day ?? day), suggestedTime: Value(slot?.clock)),
      );
    }
  }

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
  Future<bool> accept(StoredOffer stored) => _db.transaction(() async {
        // Still waiting? A second tap on the same button, or a stale screen, must not plan it twice.
        final current = await (_db.select(_db.optionOffers)..where((t) => t.id.equals(stored.offer.id))).getSingleOrNull();
        if (current == null || current.status != OfferStatus.offered) return false;
        await (_db.update(_db.optionOffers)..where((t) => t.id.equals(stored.offer.id)))
            .write(OptionOffersCompanion(status: Value(OfferStatus.accepted)));
        await _createPlanItem(stored.offer, stored.action);
        return true;
      });

  /// "I'll try this" on a compact card, which is not stored until now.
  Future<String?> acceptNew(String day, TodayOption option, TodayChips chips) => _db.transaction(() async {
        // The same action is not planned twice in a day (a double tap).
        if ((await _actedActionIds(day)).contains(option.ranked.action.id)) return null;
        final followed = await _followedIds();
        final offer = await _insertOffer(day, option, chips, followed, status: OfferStatus.accepted);
        await _createPlanItem(offer, option.ranked.action);
        return offer.id;
      });

  /// Undo for "I'll try this": the plan item goes (its unknown reflection with it). An offer from the hero chain
  /// goes back to waiting; one that was created by accepting a compact card is removed.
  Future<void> undoAccept(String offerId, {required bool wasNew}) => _db.transaction(() async {
        // A plan item that has been answered is never deleted: totals never go down (docs/data-model.md).
        final item = await (_db.select(_db.planItems)..where((t) => t.offerId.equals(offerId))).getSingleOrNull();
        if (item != null) {
          final r = await (_db.select(_db.reflections)..where((t) => t.planItemId.equals(item.id))).getSingleOrNull();
          if (r != null && r.status != ReflectionStatus.unknown) return;
        }
        await (_db.delete(_db.planItems)..where((t) => t.offerId.equals(offerId))).go();
        if (wasNew) {
          await (_db.delete(_db.optionOffers)..where((t) => t.id.equals(offerId))).go();
        } else {
          await _setStatus(offerId, OfferStatus.offered);
        }
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

  // ---- returns (EQ-011)

  /// Return days that already have a `return_event`, so recording one is idempotent.
  Future<Set<String>> recordedReturnDays() async => {for (final r in await _db.select(_db.returnEvents).get()) r.returnDay};

  /// Records each return in [due] once. The answers from My Way Back go on the lapse they were given for
  /// ([answersLapseStart]), never on another one. A return is a total that only ever goes up (BR-007).
  Future<void> recordReturns(
    List<LapseSpan> due, {
    String? answersLapseStart,
    String? whatChanged,
    ReturnApproach? approach,
  }) =>
      _db.transaction(() async {
        // Checked again inside the transaction: two overlapping reads of Today must not both record the same return.
        final already = await recordedReturnDays();
        for (final span in due) {
          if (already.contains(span.returnDay)) continue;
          final own = answersLapseStart != null && answersLapseStart == span.startDay;
          await _db.into(_db.returnEvents).insert(
                ReturnEventsCompanion.insert(
                  lapseStartDay: span.startDay,
                  returnDay: span.returnDay!,
                  whatChanged: Value(own ? whatChanged : null),
                  approach: Value(own ? approach : null),
                ),
              );
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
    final rows = await (_db.select(_db.pauses)..where((t) => t.kind.equals(PauseKind.pause.code))).get();
    for (final p in rows) {
      final covers = p.startDay.compareTo(today) <= 0 && (p.endDay == null || p.endDay!.compareTo(today) > 0);
      if (covers) {
        await (_db.update(_db.pauses)..where((t) => t.id.equals(p.id))).write(PausesCompanion(endDay: Value(today)));
      }
    }
  }
}

/// Which stored offer Today shows now: the first of the chain still waiting, by swap order.
StoredOffer? shownOffer(List<StoredOffer> offers) {
  final waiting = offers.where((o) => o.status == OfferStatus.offered).toList();
  return waiting.isEmpty ? null : waiting.first;
}
