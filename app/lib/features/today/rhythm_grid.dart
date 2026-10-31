import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/day.dart';
import 'today_controller.dart';

/// The Rhythm grid (docs/DESIGN.md Commit grid tile, ADR-012): small filled rectangles, one per day, seven rows
/// (Monday to Sunday) by up to twelve weeks, newest week at the right. Today's tile has a 2 px focus ring. A
/// paused day is drawn exactly like level 0. Nothing here is red, outlined or "empty grey for a miss".
class RhythmGridCard extends StatelessWidget {
  const RhythmGridCard({super.key, required this.days});

  /// The days to draw, oldest first, starting on a Monday.
  final List<GridDay> days;

  /// What a screen reader says for the whole grid: one node instead of eighty-four tiles, with today named.
  String get _summary {
    final active = days.where((d) => !d.cell.isPause && d.cell.level > 0).length;
    final today = days.where((d) => d.isToday).firstOrNull;
    final todayWords = today == null ? '' : ' Today: ${RhythmTile(day: today, height: 0).label.split(': ').last}.';
    return 'Your rhythm, last $rhythmWeeks weeks. $active days with activity.$todayWords';
  }

  @override
  Widget build(BuildContext context) {
    final weeks = <List<GridDay>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7 > days.length ? days.length : i + 7));
    }
    return RhythmCard(
      title: 'Your rhythm · last $rhythmWeeks weeks',
      semanticsOverride: _summary,
      child: LayoutBuilder(
        builder: (context, box) {
          // Tiles fill the card whatever the phone width: (width - the gaps) / the weeks.
          const gap = 4.0;
          final tile = ((box.maxWidth - gap * (rhythmWeeks - 1)) / rhythmWeeks).clamp(8.0, 26.0);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var w = 0; w < weeks.length; w++) ...[
                if (w > 0) const SizedBox(width: gap),
                Column(
                  children: [
                    for (var d = 0; d < weeks[w].length; d++) ...[
                      if (d > 0) const SizedBox(height: 3),
                      RhythmTile(day: weeks[w][d], width: tile, height: 8),
                    ],
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// The card while Today loads: the same grid as empty tiles and nothing else (docs/sitemap.md, loading state).
class RhythmGridSkeleton extends StatelessWidget {
  const RhythmGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RhythmCard(
        title: '',
        showTitle: false,
        child: LayoutBuilder(
          builder: (context, box) {
            const gap = 4.0;
            final tile = ((box.maxWidth - gap * (rhythmWeeks - 1)) / rhythmWeeks).clamp(8.0, 26.0);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var w = 0; w < rhythmWeeks; w++) ...[
                  if (w > 0) const SizedBox(width: gap),
                  Column(
                    children: [
                      for (var d = 0; d < 7; d++) ...[
                        if (d > 0) const SizedBox(height: 3),
                        Container(
                          width: tile,
                          height: 8,
                          decoration: BoxDecoration(color: LiltColors.grid0, borderRadius: BorderRadius.circular(1.5)),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Day one (frame 1.16): this week as seven tiles with the day letters above them, "starts today".
class WeekStripCard extends StatelessWidget {
  const WeekStripCard({super.key, required this.days});

  final List<GridDay> days;

  @override
  Widget build(BuildContext context) {
    const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return RhythmCard(
      title: 'This week · starts today',
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: Column(
                children: [
                  ExcludeSemantics(child: Text(letters[i], style: LiltText.label.copyWith(fontSize: 12))),
                  const SizedBox(height: 6),
                  RhythmTile(day: days[i], height: 12),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RhythmCard extends StatelessWidget {
  const RhythmCard({super.key, required this.title, required this.child, this.semanticsOverride, this.showTitle = true});

  final String title;
  final Widget child;

  /// One spoken summary for the whole card, with the tiles left out of the reading order.
  final String? semanticsOverride;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LiltSpacing.lg),
      decoration: ShapeDecoration(
        color: LiltColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LiltRadius.card),
          side: const BorderSide(color: LiltColors.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Semantics(header: true, child: Text(title, style: LiltText.label.copyWith(fontWeight: FontWeight.w600))),
            const SizedBox(height: LiltSpacing.lg),
          ],
          child,
        ],
      ),
    );
    if (semanticsOverride == null) return card;
    return Semantics(label: semanticsOverride, container: true, child: ExcludeSemantics(child: card));
  }
}

class RhythmTile extends StatelessWidget {
  const RhythmTile({super.key, required this.day, this.width, required this.height});

  final GridDay day;
  final double? width;
  final double height;

  static const _levels = [LiltColors.grid0, LiltColors.grid1, LiltColors.grid2, LiltColors.grid3];

  /// Words for screen readers, so the level is never carried by colour alone (DESIGN.md).
  String get label => _label;

  String get _label {
    final date = shortDate(day.day);
    final label = '$date${day.isToday ? ' (today)' : ''}';
    if (day.cell.isPause) return '$label: paused';
    return switch (day.cell.level) {
      3 => '$label: goal met',
      2 || 1 => '$label: some activity',
      _ => '$label: rest or not recorded',
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = day.cell.isPause ? LiltColors.gridPause : _levels[day.cell.level];
    return Semantics(
      container: true,
      label: _label,
      child: ExcludeSemantics(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5),
            border: day.isToday ? Border.all(color: LiltColors.primary, width: 2) : null,
          ),
        ),
      ),
    );
  }
}

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November',
  'December',
];
const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

/// "Friday 23 October".
String longDate(String day) {
  final d = parseDay(day);
  return '${_weekdays[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';
}

/// "Oct 21", for screen readers.
String shortDate(String day) {
  final d = parseDay(day);
  return '${_months[d.month - 1].substring(0, 3)} ${d.day}';
}

/// "Sat 24 Oct", for a card that is planned for another day.
String weekdayDate(String day) {
  final d = parseDay(day);
  return '${_weekdays[d.weekday - 1].substring(0, 3)} ${d.day} ${_months[d.month - 1].substring(0, 3)}';
}
