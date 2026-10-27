import '../data/enums.dart';

/// Plain inputs for the domain rules (docs/methods.md EQ-001 to EQ-011). The data layer turns database rows
/// into these, so the rules stay pure Dart and can be tested without a database.

/// A library action as the rules see it (DS-001).
class ActionInfo {
  const ActionInfo({
    required this.id,
    required this.activity,
    required this.title,
    required this.durationMin,
    required this.energyNeeded,
    required this.tags,
    required this.isStarter,
    required this.similarTo,
    required this.libraryVersion,
  });

  final String id;
  final ActivityKind activity;
  final String title;
  final int durationMin;
  final Energy energyNeeded;
  final Set<String> tags;
  final bool isStarter;
  final List<String> similarTo;
  final String libraryVersion;
}

/// One planned thing and how it went. A reflection that was never answered has status `unknown` (BR-009).
class ReflectionRecord {
  const ReflectionRecord({
    required this.day,
    required this.activity,
    required this.status,
    this.actionId,
    this.tags = const {},
    this.plannedMinute,
    this.enjoyment,
    this.barrier,
  });

  /// The plan item's local day, `YYYY-MM-DD`.
  final String day;
  final ActivityKind activity;
  final ReflectionStatus status;

  /// Null for a one-off the person typed in.
  final String? actionId;
  final Set<String> tags;

  /// Planned start in minutes since midnight, when there is one.
  final int? plannedMinute;

  /// 1 Not for me, 2 Okay, 3 Enjoyed it. Null when not answered.
  final int? enjoyment;
  final Barrier? barrier;

  bool get isKnown => status != ReflectionStatus.unknown;

  /// A reflected day is one with a `completed` or `partly` reflection (EQ-001).
  bool get makesReflectedDay =>
      status == ReflectionStatus.completed || status == ReflectionStatus.partly;
}

/// A pause. A null [endDay] means until resumed.
class PauseSpan {
  const PauseSpan({required this.startDay, this.endDay});

  final String startDay;
  final String? endDay;
}

/// What Works for Me, as far as ranking is concerned (BR-010).
class ObservationInfo {
  const ObservationInfo({required this.patternKey, required this.text, required this.status});

  final String patternKey;
  final String text;
  final ObsStatus status;
}

/// One option that was offered, for the study metric (EQ-010).
class OfferRecord {
  const OfferRecord({
    required this.day,
    required this.status,
    required this.actionDurationMin,
    this.editedDurationMin,
  });

  final String day;
  final OfferStatus status;
  final int actionDurationMin;
  final int? editedDurationMin;
}
