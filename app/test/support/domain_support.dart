import 'dart:convert';

import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/models.dart';

import 'test_support.dart';

const fixtureLibraryVersion = 'fixture.1';

T _byCode<T extends Enum>(List<T> values, String code) =>
    values.firstWhere((v) => (v as Coded).code == code);

/// The small action set in `test/fixtures/ranking_actions.json`. An action can carry its own
/// `library_version` to stand for a retired one.
Future<List<ActionInfo>> loadFixtureActions() async {
  final json = jsonDecode(await readAssetFile('test/fixtures/ranking_actions.json')) as Map<String, Object?>;
  final version = json['library_version']! as String;
  return [
    for (final a in (json['actions']! as List).cast<Map<String, Object?>>())
      ActionInfo(
        id: a['id']! as String,
        activity: _byCode(ActivityKind.values, a['activity']! as String),
        title: a['title']! as String,
        durationMin: a['duration_min']! as int,
        energyNeeded: _byCode(Energy.values, a['energy_needed']! as String),
        tags: Set<String>.from(a['tags']! as List),
        isStarter: a['is_starter']! as bool,
        similarTo: List<String>.from(a['similar_to']! as List),
        libraryVersion: (a['library_version'] as String?) ?? version,
      ),
  ];
}

/// A reflection on [day] for [action] (or a one-off when [action] is null).
ReflectionRecord reflect(
  String day,
  ReflectionStatus status, {
  ActionInfo? action,
  ActivityKind activity = ActivityKind.walking,
  int? enjoyment,
  Barrier? barrier,
  int? plannedMinute,
  Set<String>? tags,
}) =>
    ReflectionRecord(
      day: day,
      activity: action?.activity ?? activity,
      status: status,
      actionId: action?.id,
      tags: tags ?? action?.tags ?? const {},
      plannedMinute: plannedMinute,
      enjoyment: enjoyment,
      barrier: barrier,
    );

ReflectionRecord done(String day, {ActionInfo? action, int? enjoyment, ActivityKind? activity}) => reflect(
      day,
      ReflectionStatus.completed,
      action: action,
      enjoyment: enjoyment,
      activity: activity ?? ActivityKind.walking,
    );
