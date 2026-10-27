import 'package:drift/drift.dart';

import 'enums.dart';
import 'ids.dart';

/// Tables from docs/data-model.md §4. Table names are the singular names the data model uses.
/// Personal fields are marked 🔒 in the data model; they never leave the device except through a
/// user-initiated export (BR-015).

/// Append-only consent log (BR-014). No row is written before the person agrees (TC-022).
class ConsentRecords extends Table {
  @override
  String get tableName => 'consent';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get consentVersion => text()();
  DateTimeColumn get acceptedAt => dateTime()();
}

/// The device's settings row. A constant daily goal of 1 in P0 (no screen sets it).
class Profiles extends Table {
  @override
  String get tableName => 'profile';

  TextColumn get id => text().withDefault(const Constant('me'))();
  IntColumn get dailyGoal => integer().withDefault(const Constant(1))();
  DateTimeColumn get setupDoneAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per activity the person follows (frames 1.3 to 1.11, 3.9, 7.2).
@TableIndex(name: 'followed_activity_unfollowed', columns: {#unfollowedAt})
class FollowedActivities extends Table {
  @override
  String get tableName => 'followed_activity';

  TextColumn get id => text().clientDefault(() => newId('fol'))();
  TextColumn get activity => text().map(const CodedEnumConverter<ActivityKind>(ActivityKind.values))();
  // 🔒 The typed name when `activity` is `other`.
  TextColumn get customName => text().nullable()();
  TextColumn get path => text().map(const CodedEnumConverter<SetupPath>(SetupPath.values))();
  TextColumn get progress =>
      text().map(const CodedEnumConverter<Progress>(Progress.values)).nullable()();
  // Comma set of hard_because codes, asked when progress is up_and_down or getting_harder.
  TextColumn get hardBecause => text().nullable()();
  TextColumn get stoppedAgo =>
      text().map(const CodedEnumConverter<StoppedAgo>(StoppedAgo.values)).nullable()();
  // Comma set of what_changed codes (frame 1.10).
  TextColumn get gotInTheWay => text().nullable()();
  // Comma set of what_would_help codes (frame 1.11).
  TextColumn get wouldHelp => text().nullable()();
  TextColumn get familiarity =>
      text().map(const CodedEnumConverter<Familiarity>(Familiarity.values)).nullable()();
  DateTimeColumn get followedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get unfollowedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Free times, access, usual barriers, motivations (at most 3) and leave-outs (frames 1.12 to 1.14, 7.8).
class Preferences extends Table {
  @override
  String get tableName => 'preference';

  TextColumn get id => text().clientDefault(() => newId('pref'))();
  TextColumn get kind => text().map(const CodedEnumConverter<PrefKind>(PrefKind.values))();
  // 🔒 A code (see data-model §7) or an activity_kind when kind is `excluded`.
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {kind, value},
      ];
}

/// The curated library (DS-001). Read-only for people; loaded from the bundled asset (TASK-004).
@DataClassName('LibraryAction')
class Actions extends Table {
  @override
  String get tableName => 'action';

  TextColumn get id => text()();
  TextColumn get activity => text().map(const CodedEnumConverter<ActivityKind>(ActivityKind.values))();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get durationMin => integer()();
  TextColumn get intensity => text().map(const CodedEnumConverter<Intensity>(Intensity.values))();
  TextColumn get energyNeeded => text().map(const CodedEnumConverter<Energy>(Energy.values))();
  // Comma-separated tag codes (with_company, indoors, outdoors, free, team_sport, high_impact, after_dark).
  TextColumn get tags => text().withDefault(const Constant(''))();
  BoolColumn get isStarter => boolean().withDefault(const Constant(false))();
  TextColumn get libraryVersion => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One option shown on a day (F-002).
@TableIndex(name: 'option_offer_day', columns: {#day})
class OptionOffers extends Table {
  @override
  String get tableName => 'option_offer';

  TextColumn get id => text().clientDefault(() => newId('off'))();
  TextColumn get day => text()();
  TextColumn get actionId => text().references(Actions, #id, onDelete: KeyAction.restrict)();
  TextColumn get followedActivityId =>
      text().nullable().references(FollowedActivities, #id, onDelete: KeyAction.setNull)();
  TextColumn get suggestedDay => text()();
  TextColumn get suggestedTime => text().nullable()();
  // 1 to 3: the position in the day's "Something else" chain.
  IntColumn get swapIndex => integer().withDefault(const Constant(1))();
  TextColumn get status => text()
      .map(const CodedEnumConverter<OfferStatus>(OfferStatus.values))
      .withDefault(const Constant('offered'))();
  IntColumn get editedDurationMin => integer().nullable()();
  TextColumn get editedDay => text().nullable()();
  TextColumn get editedTime => text().nullable()();
  IntColumn get timeInputMin => integer().nullable()();
  TextColumn get energyInput =>
      text().map(const CodedEnumConverter<Energy>(Energy.values)).nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {day, followedActivityId, swapIndex},
      ];
}

/// The reasons shown for one offer; rank 1 is on the card (BR-004).
class OfferReasons extends Table {
  @override
  String get tableName => 'offer_reason';

  TextColumn get offerId => text().references(OptionOffers, #id, onDelete: KeyAction.cascade)();
  IntColumn get rank => integer()();
  TextColumn get reasonCode => text()();
  TextColumn get reasonText => text()();

  @override
  Set<Column> get primaryKey => {offerId, rank};
}

/// Something on Today's plan: an accepted suggestion, a one-off, or a Together RSVP (BR-005).
@TableIndex(name: 'plan_item_day', columns: {#plannedDay})
class PlanItems extends Table {
  @override
  String get tableName => 'plan_item';

  TextColumn get id => text().clientDefault(() => newId('plan'))();
  TextColumn get source => text().map(const CodedEnumConverter<PlanSource>(PlanSource.values))();
  TextColumn get offerId =>
      text().nullable().references(OptionOffers, #id, onDelete: KeyAction.setNull)();
  TextColumn get actionId =>
      text().nullable().references(Actions, #id, onDelete: KeyAction.restrict)();
  TextColumn get activity => text().map(const CodedEnumConverter<ActivityKind>(ActivityKind.values))();
  TextColumn get title => text()();
  TextColumn get plannedDay => text()();
  TextColumn get plannedTime => text().nullable()();
  IntColumn get durationMin => integer().nullable()();
  TextColumn get withWhom => text()
      .map(const CodedEnumConverter<WithWhom>(WithWhom.values))
      .withDefault(const Constant('solo'))();
  TextColumn get togetherEventId => text().nullable()();
  TextColumn get detailText => text().nullable()();
  // The optional "I'm starting" marker (ADR-014). Nothing is recorded while under way.
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};
}

/// Quick Reflection (F-003). Created as `unknown` with the plan item; deleting the plan item deletes it.
class Reflections extends Table {
  @override
  String get tableName => 'reflection';

  TextColumn get id => text().clientDefault(() => newId('ref'))();
  TextColumn get planItemId => text().references(PlanItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()
      .map(const CodedEnumConverter<ReflectionStatus>(ReflectionStatus.values))
      .withDefault(const Constant('unknown'))();
  // 1 Not for me, 2 Okay, 3 Enjoyed it. Null when not answered. 🔒
  // ignore: recursive_getters
  IntColumn get enjoyment => integer().nullable().check(enjoyment.isBetweenValues(1, 3))();
  // Only asked after `partly` or `skipped` (BR-008). 🔒
  TextColumn get barrier =>
      text().map(const CodedEnumConverter<Barrier>(Barrier.values)).nullable()();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {planItemId},
      ];
}

/// Intentional pauses (UJ-004, BR-006). In P0 only kind `pause` is written.
class Pauses extends Table {
  @override
  String get tableName => 'pause';

  TextColumn get id => text().clientDefault(() => newId('pau'))();
  TextColumn get kind => text().map(const CodedEnumConverter<PauseKind>(PauseKind.values))();
  TextColumn get startDay => text()();
  // Null = until resumed.
  TextColumn get endDay => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// What Works for Me (F-004). Only `confirmed` observations affect ranking (BR-010).
class Observations extends Table {
  @override
  String get tableName => 'observation';

  TextColumn get id => text().clientDefault(() => newId('obs'))();
  // 🔒 Shown to the user.
  TextColumn get text_ => text().named('text')();
  TextColumn get source => text().map(const CodedEnumConverter<ObsSource>(ObsSource.values))();
  TextColumn get status => text()
      .map(const CodedEnumConverter<ObsStatus>(ObsStatus.values))
      .withDefault(const Constant('proposed'))();
  TextColumn get patternKey => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get confirmedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Discover > Saved. The cards are library actions.
class SavedActions extends Table {
  @override
  String get tableName => 'saved_action';

  TextColumn get actionId => text().references(Actions, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get savedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {actionId};
}

/// A return after a lapse (F-005, EQ-011).
class ReturnEvents extends Table {
  @override
  String get tableName => 'return_event';

  TextColumn get id => text().clientDefault(() => newId('ret'))();
  TextColumn get lapseStartDay => text()();
  TextColumn get returnDay => text()();
  // 🔒 Comma set of what_changed codes; skipping stores null.
  TextColumn get whatChanged => text().nullable()();
  TextColumn get approach =>
      text().map(const CodedEnumConverter<ReturnApproach>(ReturnApproach.values)).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Milestones the person has earned (F-015, BR-023). They only ever increase.
@DataClassName('AchievementEarned')
class AchievementsEarned extends Table {
  @override
  String get tableName => 'achievement_earned';

  // back_at_it, bounced_back, something_new, explorer, active_days_10, active_days_30,
  // active_days_100, found_your_rhythm
  TextColumn get code => text()();
  TextColumn get earnedDay => text()();
  BoolColumn get celebrated => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {code};
}

/// Gentle reminders (F-008). One reminder a day at most (EQ-005).
class NotificationSettings extends Table {
  @override
  String get tableName => 'notification_setting';

  TextColumn get id => text().withDefault(const Constant('me'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  // `before_free_time` or `fixed`.
  TextColumn get mode => text().withDefault(const Constant('before_free_time'))();
  TextColumn get fixedTime => text().nullable()();
  IntColumn get leadMin => integer().withDefault(const Constant(30))();
  TextColumn get quietStart => text().withDefault(const Constant('21:00'))();
  TextColumn get quietEnd => text().withDefault(const Constant('07:00'))();
  BoolColumn get lapseCheckinEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
