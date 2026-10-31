import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../domain/day.dart';
import '../today/rhythm_grid.dart';
import '../today/today_controller.dart';
import 'day_sheet.dart';
import 'rhythm_controller.dart';
import 'rhythm_repository.dart';
import 'rhythm_screen.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// S-015 Full history (frame 6.4): every month as a calendar, newest first, with the same tile colours as the
/// grid. Tap a day for its detail (S-113). Days after today are plain numbers, not tiles.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rhythmControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(LiltSpacing.sm, LiltSpacing.sm, LiltSpacing.lg, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Back',
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: LiltSpacing.sm),
                  Semantics(
                    header: true,
                    child: Text(
                      'Your rhythm',
                      style: LiltText.body.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: async.when(
                data: (data) => _Months(data: data),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.all(LiltSpacing.lg),
                  child: Semantics(
                    liveRegion: true,
                    child: const Text('Your rhythm didn’t load.', style: LiltText.body),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Months extends StatelessWidget {
  const _Months({required this.data});

  final RhythmData data;

  @override
  Widget build(BuildContext context) {
    final byDay = {for (final d in data.history) d.day: d};
    final today = parseDay(data.today);
    final first = data.history.isEmpty ? today : parseDay(data.history.first.day);
    // Newest month first.
    final months = <DateTime>[];
    for (
      var m = DateTime.utc(today.year, today.month);
      !m.isBefore(DateTime.utc(first.year, first.month));
      m = DateTime.utc(m.year, m.month - 1)
    ) {
      months.add(m);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(LiltSpacing.sm, LiltSpacing.md, LiltSpacing.sm, LiltSpacing.xl),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: LiltSpacing.sm),
          child: GridLegend(),
        ),
        const SizedBox(height: LiltSpacing.lg),
        for (final m in months) ...[
          _Month(month: m, byDay: byDay, today: data.today),
          const SizedBox(height: LiltSpacing.xl),
        ],
      ],
    );
  }
}

class _Month extends StatelessWidget {
  const _Month({required this.month, required this.byDay, required this.today});

  final DateTime month;
  final Map<String, GridDay> byDay;
  final String today;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime.utc(month.year, month.month + 1, 0).day;
    final lead = month.weekday - DateTime.monday;
    final cells = <Widget>[
      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++)
        _DayCell(
          date: formatDay(DateTime.utc(month.year, month.month, d)),
          number: d,
          day: byDay[formatDay(DateTime.utc(month.year, month.month, d))],
        ),
    ];
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.sm),
          child: Semantics(
            header: true,
            child: Text(
              '${_monthNames[month.month - 1]} ${month.year}',
              style: LiltText.body.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: LiltSpacing.sm),
        ExcludeSemantics(
          child: Row(
            children: [
              for (final l in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Center(
                    child: Text(l, style: LiltText.label.copyWith(fontSize: 12, color: LiltColors.inkMuted)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: LiltSpacing.xs),
        for (var row = 0; row < cells.length; row += 7)
          Row(children: [for (final c in cells.sublist(row, row + 7)) Expanded(child: c)]),
      ],
    );
  }
}

/// One day. A day with a tile can be opened; a day before the first plan or after today is just its number.
class _DayCell extends StatelessWidget {
  const _DayCell({required this.date, required this.number, required this.day});

  final String date;
  final int number;
  final GridDay? day;

  static const _levels = [LiltColors.grid0, LiltColors.grid1, LiltColors.grid2, LiltColors.grid3];

  @override
  Widget build(BuildContext context) {
    final d = day;
    if (d == null) {
      return ExcludeSemantics(
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text('$number', style: LiltText.label.copyWith(fontSize: 14, color: LiltColors.inkMuted)),
          ),
        ),
      );
    }
    final color = d.cell.isPause ? LiltColors.gridPause : _levels[d.cell.level];
    // Ink on the darkest tile is under 4.5:1, so that one takes white text.
    final textColor = !d.cell.isPause && d.cell.level == 3 ? LiltColors.onPrimary : LiltColors.ink;
    final label = '${longDate(date)}${d.isToday ? ' (today)' : ''}: ${daySummary(d).split(' · ').first.toLowerCase()}';
    void open() => showDaySheet(context, d);
    return Semantics(
      button: true,
      label: label,
      onTap: open,
      excludeSemantics: true,
      child: InkWell(
        onTap: open,
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LiltRadius.sm)),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Ink(
            height: 44,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(LiltRadius.sm),
                side: d.isToday ? const BorderSide(color: LiltColors.primary, width: 2) : BorderSide.none,
              ),
            ),
            child: Center(
              child: Text('$number', style: LiltText.label.copyWith(fontSize: 14, color: textColor)),
            ),
          ),
        ),
      ),
    );
  }
}
