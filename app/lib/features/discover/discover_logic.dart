import 'package:flutter/material.dart';

import '../../data/enums.dart';
import '../../domain/models.dart';
import '../../domain/ranking.dart';

/// S-009 Discover (F-002, F-004): the library as a browsable list, ordered for the person. Pure rules, so every
/// state can be tested without a screen. Leave-outs and access are applied by the ranker, never relaxed (BR-011).

/// The filter chips (frame 5.1). They are multi-select; choosing none means all (docs/DESIGN.md, Selection).
enum DiscoverFilter {
  quick('Quick'),
  indoors('Indoors'),
  outdoors('Outdoors'),
  withOthers('With others');

  const DiscoverFilter(this.label);
  final String label;
}

/// "Quick" means 20 minutes or less [assumption].
const quickMinutes = 20;

/// Filters of different kinds narrow each other (Quick and Outdoors: quick and outdoors); the two places are
/// alternatives (Indoors and Outdoors: either).
bool matchesFilters(ActionInfo a, Set<DiscoverFilter> filters) {
  if (filters.isEmpty) return true;
  if (filters.contains(DiscoverFilter.quick) && a.durationMin > quickMinutes) return false;
  if (filters.contains(DiscoverFilter.withOthers) && !a.tags.contains('with_company')) return false;
  final places = <String>{
    if (filters.contains(DiscoverFilter.indoors)) 'indoors',
    if (filters.contains(DiscoverFilter.outdoors)) 'outdoors',
  };
  return places.isEmpty || a.tags.any(places.contains);
}

/// "20 min · outdoors", "45 min · with others" (frame 5.1).
String metaLine(ActionInfo a) {
  final place = a.tags.contains('with_company')
      ? 'with others'
      : a.tags.contains('indoors')
          ? 'indoors'
          : a.tags.contains('outdoors')
              ? 'outdoors'
              : null;
  return place == null ? '${a.durationMin} min' : '${a.durationMin} min · $place';
}

/// One card: an action, why it is suggested (BR-004), whether it is saved and whether the person already follows
/// the activity ("New for you" is shown only when they do not).
class DiscoverItem {
  const DiscoverItem({required this.ranked, required this.saved, required this.isNew});

  final RankedAction ranked;
  final bool saved;
  final bool isNew;

  ActionInfo get action => ranked.action;
  String get reason => ranked.reason.text;
}

/// "For you": the library ordered by the ranker, one idea per activity, with the filters applied before ranking so
/// "Indoors" finds an indoor idea even for an activity whose best idea is outdoors.
List<DiscoverItem> forYouItems({
  required List<ActionInfo> actions,
  required PersonContext person,
  required String libraryVersion,
  required Set<DiscoverFilter> filters,
  required Set<String> saved,
}) {
  final ranked = rankOptions(
    actions: [for (final a in actions) if (matchesFilters(a, filters)) a],
    person: person,
    libraryVersion: libraryVersion,
    request: const RankingRequest(forToday: false),
    limit: 100,
    reasonContext: actions,
    // Browsing shows the whole library, not only the starters Today offers someone with no history.
    startersFirst: false,
  );
  return [
    for (final r in ranked)
      DiscoverItem(ranked: r, saved: saved.contains(r.action.id), isNew: !person.followed.contains(r.action.activity)),
  ];
}

/// "Saved": what the person bookmarked, most recent first. A saved action that is now left out or retired is not
/// shown (BR-011); it stays saved and returns if the leave-out is lifted.
List<DiscoverItem> savedItems({
  required List<ActionInfo> actions,
  required PersonContext person,
  required String libraryVersion,
  required List<String> savedOrder,
}) {
  final byId = {for (final a in actions) a.id: a};
  final items = <DiscoverItem>[];
  for (final id in savedOrder) {
    final action = byId[id];
    if (action == null) continue;
    final ranked = rankOptions(
      actions: [action],
      person: person,
      libraryVersion: libraryVersion,
      request: const RankingRequest(forToday: false),
      limit: 1,
      reasonContext: actions,
    );
    if (ranked.isEmpty) continue;
    items.add(DiscoverItem(ranked: ranked.first, saved: true, isNew: !person.followed.contains(action.activity)));
  }
  return items;
}

/// A tile icon per activity, standing in for the illustrations in the frames.
IconData iconFor(ActivityKind kind) => switch (kind) {
      ActivityKind.walking => Icons.directions_walk,
      ActivityKind.running => Icons.directions_run,
      ActivityKind.gym => Icons.fitness_center,
      ActivityKind.cycling => Icons.directions_bike,
      ActivityKind.swimming => Icons.pool,
      ActivityKind.basketball => Icons.sports_basketball,
      ActivityKind.racketSports || ActivityKind.pickleball => Icons.sports_tennis,
      ActivityKind.teamSports => Icons.groups,
      ActivityKind.yoga || ActivityKind.pilates => Icons.self_improvement,
      ActivityKind.dance => Icons.music_note,
      ActivityKind.hiking => Icons.hiking,
      ActivityKind.bouldering => Icons.terrain,
      ActivityKind.other || ActivityKind.notSure => Icons.bolt,
    };
