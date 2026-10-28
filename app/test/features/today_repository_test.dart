import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/domain/lapse.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/today/today_logic.dart';
import 'package:lilt/features/today/today_repository.dart';

import '../support/test_support.dart';

/// What Today stores, against the real library and a real (in-memory) database.
void main() {
  late LiltDatabase db;
  late TodayRepository repo;
  // Friday 23 October 2026, 09:00.
  final now = DateTime(2026, 10, 23, 9);
  const today = '2026-10-23';

  setUp(() async {
    db = LiltDatabase(NativeDatabase.memory());
    repo = TodayRepository(db);
    await DriftLibraryLoader(db, readAssetFile).load();
    await DriftSetupRepository(db).save(const SetupAnswers(
      paths: {SetupPath.keepGoing},
      keepActivity: ActivityKind.running,
      progress: Progress.goingWell,
      freeTimes: {'lunch', 'weekends'},
      access: {'none'},
    ));
  });
  tearDown(() => db.close());

  Future<TodayPlan> plan({TodayChips chips = const TodayChips(), bool lighter = false}) async {
    final i = await repo.inputs();
    return buildTodayPlan(
      actions: i.actions,
      person: i.person,
      libraryVersion: i.libraryVersion,
      followedOrder: i.followedOrder,
      freeTimes: i.freeTimes,
      chips: chips,
      now: now,
      lighter: lighter,
    );
  }

  Future<List<StoredOffer>> offers() async {
    final i = await repo.inputs();
    return repo.offersFor(today, {for (final a in i.actions) a.id: a});
  }

  test('the inputs reflect what setup saved', () async {
    final i = await repo.inputs();
    expect(i.freeTimes, {'lunch', 'weekends'});
    expect(i.followedOrder, [ActivityKind.running]);
    expect(i.actions, isNotEmpty);
    expect(i.libraryVersion, isNotEmpty);
    expect(i.reflections, isEmpty);
  });

  test('the hero chain is stored once, with a reason each, and a restart does not reshuffle it', () async {
    final p = await plan();
    expect(p.hero, isNotEmpty);
    await repo.createHeroChain(today, p, const TodayChips());

    final first = await offers();
    expect(first.length, p.hero.length);
    expect(first.every((o) => o.reason.isNotEmpty), isTrue);
    expect(first.every((o) => o.status == OfferStatus.offered), isTrue);
    expect(first.first.offer.suggestedTime, '12:30');
    expect(first.first.offer.timeInputMin, 20);
    expect(first.first.offer.energyInput, Energy.medium);

    // Reading again (a restart) gives the same offers in the same order.
    final again = await offers();
    expect(again.map((o) => o.offer.id), first.map((o) => o.offer.id));
    expect(shownOffer(again)!.offer.id, first.first.offer.id);
  });

  test('"Something else": the shown offer becomes replaced and the next one is shown', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final chain = await offers();
    expect(chain.length, greaterThanOrEqualTo(2));
    await repo.replace(shownOffer(chain)!);

    final after = await offers();
    expect(after.first.status, OfferStatus.replaced);
    expect(shownOffer(after)!.offer.id, chain[1].offer.id);
  });

  test('"I\'ll try this" creates a plan item and an unknown reflection, in one step (BR-005, BR-009)', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final shown = shownOffer(await offers())!;
    expect(await db.select(db.planItems).get(), isEmpty, reason: 'nothing is planned until the person accepts');

    await repo.accept(shown);

    final item = (await db.select(db.planItems).get()).single;
    expect(item.offerId, shown.offer.id);
    expect(item.actionId, shown.action.id);
    expect(item.plannedDay, shown.offer.suggestedDay);
    expect(item.plannedTime, '12:30');
    final reflection = (await db.select(db.reflections).get()).single;
    expect(reflection.planItemId, item.id);
    expect(reflection.status, ReflectionStatus.unknown);
    expect((await offers()).first.status, OfferStatus.accepted);

    // An accepted option with no reflection does not count as a reflected day.
    expect((await repo.inputs()).reflectedDays, isEmpty);
  });

  test('a compact card is stored only when accepted, with its own swap position', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final hero = shownOffer(await offers())!;
    // Accept an option for the same activity as the hero's, which would clash on swap position 1.
    await repo.acceptNew(today, p.hero.first, const TodayChips());
    final all = await offers();
    expect(all.where((o) => o.status == OfferStatus.accepted), hasLength(1));
    expect(all.map((o) => '${o.offer.followedActivityId}:${o.offer.swapIndex}').toSet().length, all.length,
        reason: 'no two offers share a followed activity and swap position');
    expect(hero.offer.id, isNotEmpty);
  });

  test('changing the chips re-ranks only what has not been acted on', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final first = shownOffer(await offers())!;
    await repo.replace(first); // acted on
    final replacedId = first.offer.id;

    final p2 = await plan(chips: const TodayChips(timeMin: 45, energy: Energy.high));
    await repo.createHeroChain(today, p2, const TodayChips(timeMin: 45, energy: Energy.high));

    final after = await offers();
    expect(after.where((o) => o.offer.id == replacedId).single.status, OfferStatus.replaced);
    final waiting = after.where((o) => o.status == OfferStatus.offered);
    expect(waiting, isNotEmpty);
    expect(waiting.every((o) => o.offer.timeInputMin == 45 && o.offer.energyInput == Energy.high), isTrue,
        reason: 'the offer records the chip values used when it was made');
  });

  test('accepting twice plans once: a second tap changes nothing', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final shown = shownOffer(await offers())!;
    expect(await repo.accept(shown), isTrue);
    expect(await repo.accept(shown), isFalse);
    expect(await db.select(db.planItems).get(), hasLength(1));
    expect(await db.select(db.reflections).get(), hasLength(1));
  });

  test('accepting the same compact option twice plans it once', () async {
    final p = await plan();
    final first = await repo.acceptNew(today, p.hero.first, const TodayChips());
    final second = await repo.acceptNew(today, p.hero.first, const TodayChips());
    expect(first, isNotNull);
    expect(second, isNull);
    expect(await db.select(db.planItems).get(), hasLength(1));
  });

  test('Undo removes the plan item and its unknown reflection, and the offer waits again', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final shown = shownOffer(await offers())!;
    await repo.accept(shown);
    await repo.undoAccept(shown.offer.id, wasNew: false);
    expect(await db.select(db.planItems).get(), isEmpty);
    expect(await db.select(db.reflections).get(), isEmpty);
    expect(shownOffer(await offers())!.offer.id, shown.offer.id);
  });

  test('Undo of an accepted compact card removes the offer it created', () async {
    final p = await plan();
    final id = await repo.acceptNew(today, p.hero.first, const TodayChips());
    await repo.undoAccept(id!, wasNew: true);
    expect(await db.select(db.planItems).get(), isEmpty);
    expect(await offers(), isEmpty);
  });

  test('a rebuilt chain does not offer an action already stepped past today', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final first = shownOffer(await offers())!;
    await repo.replace(first);
    await repo.createHeroChain(today, p, const TodayChips());
    final waiting = (await offers()).where((o) => o.status == OfferStatus.offered);
    expect(waiting.map((o) => o.action.id), isNot(contains(first.action.id)));
  });

  test('a waiting option whose time has passed moves to the next slot, in the same order', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final before = (await offers()).map((o) => o.offer.id).toList();
    final later = upcomingSlots({'lunch', 'weekends'}, DateTime(2026, 10, 23, 14)).first;
    await repo.reslotWaiting(today, later);
    final after = await offers();
    expect(after.map((o) => o.offer.id), before);
    expect(after.every((o) => o.offer.suggestedTime == '10:00' && o.offer.suggestedDay == '2026-10-24'), isTrue);
  });

  test('"Resume now" ends every pause that covers today', () async {
    await repo.pause(today, 7);
    await repo.pause(today, 14); // an overlapping one, from a double tap
    await repo.resume(today);
    expect(await repo.activePause(today), isNull);
  });

  test('"Not today" declines the shown offer', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final shown = shownOffer(await offers())!;
    await repo.decline(shown);
    expect((await offers()).first.status, OfferStatus.declined);
  });

  test('"Something lighter" replaces the shown offer with a lighter chain', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    final shown = shownOffer(await offers())!;
    final lighter = await plan(lighter: true);
    expect(lighter.kind, TodayKind.options);

    await repo.swapToLighter(today, shown, lighter, const TodayChips());

    final after = await offers();
    expect(after.firstWhere((o) => o.offer.id == shown.offer.id).status, OfferStatus.replaced);
    final now = shownOffer(after)!;
    expect(now.action.durationMin, lessThanOrEqualTo(10));
    expect(now.action.energyNeeded, Energy.low);
  });

  group('pause (BR-006)', () {
    test('a pause covers its start day up to, not including, its end day', () async {
      expect(await repo.activePause(today), isNull);
      await repo.pause(today, 7);
      expect((await repo.activePause(today))!.endDay, '2026-10-30');
      expect(await repo.activePause('2026-10-29'), isNotNull);
      expect(await repo.activePause('2026-10-30'), isNull, reason: 'the end day is the first active day');
      expect(await repo.activePause('2026-10-22'), isNull);
    });

    test('pausing declines the shown offer and counts nothing as a miss', () async {
      final p = await plan();
      await repo.createHeroChain(today, p, const TodayChips());
      final shown = shownOffer(await offers())!;
      await repo.pause(today, 3, shown: shown);
      expect((await offers()).first.status, OfferStatus.declined);
      expect(await db.select(db.reflections).get(), isEmpty);
    });

    test('"Resume now" ends the pause today, so options show again', () async {
      await repo.pause(today, 14);
      await repo.resume(today);
      expect(await repo.activePause(today), isNull);
      expect((await db.select(db.pauses).get()).single.endDay, today);
    });

    test('the pause does not create a lapse for the days it covers (EQ-001)', () async {
      await repo.pause('2026-11-01', 7);
      final i = await repo.inputs();
      final paused = pausedDays(i.pauses, '2026-11-20');
      expect(paused, containsAll(['2026-11-01', '2026-11-07']));
      expect(paused, isNot(contains('2026-11-08')), reason: 'a 1 week pause ends on the 8th');
    });
  });

  test('a person with reflections gets them in the inputs, with the action\'s tags', () async {
    final p = await plan();
    await repo.createHeroChain(today, p, const TodayChips());
    await repo.accept(shownOffer(await offers())!);
    await (db.update(db.reflections)).write(const ReflectionsCompanion(status: Value(ReflectionStatus.completed), enjoyment: Value(3)));
    final i = await repo.inputs();
    expect(i.reflections.single.status, ReflectionStatus.completed);
    expect(i.reflections.single.enjoyment, 3);
    expect(i.reflections.single.tags, isNotEmpty);
    expect(i.reflectedDays, {today});
    expect(parseDay(today).weekday, DateTime.friday);
  });
}
