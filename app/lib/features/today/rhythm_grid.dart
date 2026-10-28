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

  @override
  Widget build(BuildContext context) {
    final weeks = <List<GridDay>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7 > days.length ? days.length : i + 7));
    }
    return _Card(
      title: 'Your rhythm · last $rhythmWeeks weeks',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // the newest week stays in view
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var w = 0; w < weeks.length; w++) ...[
              if (w > 0) const SizedBox(width: 4),
              Column(
                children: [
                  for (var d = 0; d < weeks[w].length; d++) ...[
                    if (d > 0) const SizedBox(height: 3),
                    _Tile(day: weeks[w][d], width: 18, height: 8),
                  ],
                ],
              ),
            ],
          ],
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
    return _Card(
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
                  _Tile(day: days[i], height: 12),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Semantics(header: true, child: Text(title, style: LiltText.label.copyWith(fontWeight: FontWeight.w600))),
          const SizedBox(height: LiltSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.day, this.width, required this.height});

  final GridDay day;
  final double? width;
  final double height;

  static const _levels = [LiltColors.grid0, LiltColors.grid1, LiltColors.grid2, LiltColors.grid3];

  /// Words for screen readers, so the level is never carried by colour alone (DESIGN.md).
  String get _label {
    final date = shortDate(day.day);
    if (day.cell.isPause) return '$date: paused';
    return switch (day.cell.level) {
      3 => '$date: goal met',
      2 || 1 => '$date: some activity',
      _ => '$date: rest or not recorded',
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
