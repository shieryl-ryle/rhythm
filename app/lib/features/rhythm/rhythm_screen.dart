import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/day.dart';
import '../../domain/patterns.dart';
import '../../ui/ui.dart';
import '../today/rhythm_grid.dart';
import '../today/today_controller.dart';
import 'observation_sheet.dart';
import 'rhythm_controller.dart';
import 'rhythm_repository.dart';

/// S-006 My rhythm (frame 6.1): the grid with active days and returns, then What works for me, where a noticed
/// pattern waits for a yes or a no and confirmed ones can be changed or removed (F-004, F-006, BR-010).
///
/// Not built yet: the "How Lilt has adjusted to you" timeline, Achievements and "What you've shared" (docs/sitemap.md).
class RhythmScreen extends ConsumerWidget {
  const RhythmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rhythmControllerProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            LiltHeader(onProfile: () => context.push('/settings')),
            Expanded(
              child: async.when(
                data: (data) => _Body(data: data),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => _LoadFailed(onRetry: () => ref.invalidate(rhythmControllerProvider)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(LiltSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(liveRegion: true, child: const Text('Your rhythm didn’t load.', style: LiltText.body)),
          const SizedBox(height: LiltSpacing.md),
          LiltButton(label: 'Try again', onPressed: onRetry, kind: LiltButtonKind.secondary),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.data});

  final RhythmData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.xl),
      children: [
        Semantics(header: true, child: const Text('My rhythm', style: LiltText.display)),
        const SizedBox(height: LiltSpacing.lg),
        _GridCard(data: data),
        if (!data.isEmpty) ...[
          const SizedBox(height: LiltSpacing.section),
          Semantics(
            header: true,
            child: Text('What works for me', style: LiltText.body.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: LiltSpacing.md),
          if (data.proposed != null) ...[
            _ProposedCard(observation: data.proposed!),
            const SizedBox(height: LiltSpacing.md),
          ],
          for (final o in data.confirmed) ...[_ConfirmedCard(observation: o), const SizedBox(height: LiltSpacing.md)],
          if (data.proposed == null && data.confirmed.isEmpty)
            const Text(
              'Nothing here yet. When a pattern shows up in how your days go, it will wait here for you to say if it fits.',
              style: LiltText.body,
            ),
        ],
      ],
    );
  }
}

/// "Active on 31 days. Came back 2 times after a break." Totals only go up (BR-007).
String totalsLine(int activeDays, int returns) {
  final active = 'Active on $activeDays ${activeDays == 1 ? 'day' : 'days'}.';
  if (returns == 0) return active;
  return '$active Came back $returns ${returns == 1 ? 'time' : 'times'} after a break.';
}

class _GridCard extends StatelessWidget {
  const _GridCard({required this.data});

  final RhythmData data;

  @override
  Widget build(BuildContext context) {
    if (data.totals.activeDays == 0 && data.totals.returns == 0) return _FirstWeeksCard(today: data.today);
    final line = totalsLine(data.totals.activeDays, data.totals.returns);
    return RhythmCard(
      title: '',
      showTitle: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            label: 'Your rhythm, last $myRhythmWeeks weeks.',
            child: ExcludeSemantics(
              child: MonthGrid(days: data.grid, firstDay: data.history.isEmpty ? null : data.history.first.day),
            ),
          ),
          const SizedBox(height: LiltSpacing.md),
          const GridLegend(),
          const SizedBox(height: LiltSpacing.lg),
          Semantics(liveRegion: true, child: Text(line, style: LiltText.body)),
          if (data.history.isNotEmpty) ...[
            const SizedBox(height: LiltSpacing.sm),
            LiltButton(
              label: 'See every day',
              kind: LiltButtonKind.text,
              flush: true,
              onPressed: () => context.push('/rhythm/history'),
            ),
          ],
        ],
      ),
    );
  }
}

final _monthStyle = LiltText.label.copyWith(fontSize: 12, color: LiltColors.inkMuted);

const _monthShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// The grid with a month name above the first week that holds the 1st of that month, as in frame 6.1.
class MonthGrid extends StatelessWidget {
  const MonthGrid({super.key, required this.days, this.firstDay});

  /// Oldest first, starting on a Monday.
  final List<GridDay> days;

  /// The first day anything was planned. Days before it are left unfilled, as in the calendar, not drawn as rest.
  final String? firstDay;

  @override
  Widget build(BuildContext context) {
    final weeks = <List<GridDay>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7 > days.length ? days.length : i + 7));
    }
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 4.0;
        final count = weeks.isEmpty ? 1 : weeks.length;
        final tile = ((box.maxWidth - gap * (count - 1)) / count).clamp(8.0, 26.0);
        final labels = <int, String>{};
        var last = -3;
        for (var w = 0; w < weeks.length; w++) {
          final first = weeks[w].where((d) => parseDay(d.day).day == 1).firstOrNull;
          // Keep at least three columns between names so they never run into each other.
          // A name over columns that are left unfilled (before the first plan) would label nothing.
          final blank = firstDay != null && weeks[w].last.day.compareTo(firstDay!) < 0;
          if (first != null && !blank && w - last >= 3) {
            labels[w] = _monthShort[parseDay(first.day).month - 1];
            last = w;
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: box.maxWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // An invisible name sets the row's height, so it is measured at any text size and the names
                  // never sit on the first row of tiles.
                  Opacity(opacity: 0, child: Text('Oct', style: _monthStyle)),
                  for (final e in labels.entries)
                    Positioned(
                      left: e.key * (tile + gap),
                      child: Text(e.value, style: _monthStyle),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                for (var w = 0; w < weeks.length; w++) ...[
                  if (w > 0) const SizedBox(width: gap),
                  Column(
                    children: [
                      for (var d = 0; d < weeks[w].length; d++) ...[
                        if (d > 0) const SizedBox(height: 3),
                        if (firstDay != null && weeks[w][d].day.compareTo(firstDay!) < 0)
                          SizedBox(width: tile, height: 9)
                        else
                          RhythmTile(day: weeks[w][d], width: tile, height: 9),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Done, Partly, Rest or not shared. Colour is never the only way to tell (each tile also has a spoken label).
class GridLegend extends StatelessWidget {
  const GridLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: LiltSpacing.xs + 2),
        // Flexible, so a long label wraps at large text instead of running off the card.
        Flexible(child: Text(label, style: LiltText.label.copyWith(fontSize: 13))),
      ],
    );
    return Wrap(
      spacing: LiltSpacing.lg,
      runSpacing: LiltSpacing.sm,
      children: [
        item(LiltColors.grid3, 'Done'),
        item(LiltColors.grid2, 'Partly'),
        item(LiltColors.grid0, 'Rest or not shared'),
      ],
    );
  }
}

/// Only an enjoyed pattern adds to a suggestion's score (EQ-009); a "gets in the way" note, or the person's own
/// words with no pattern behind them, is kept for them and says so.
String _confirmedLine(String patternKey) => PatternKey.tryParse(patternKey)?.isPositive ?? false
    ? 'Confirmed · used for suggestions'
    : 'Confirmed · a note for you';

/// Day one (frame 9.7): this week and the next as empty tiles, today outlined, and one line. Nothing is grey for
/// "nothing yet": an empty tile is just not filled yet.
class _FirstWeeksCard extends StatelessWidget {
  const _FirstWeeksCard({required this.today});

  final String today;

  @override
  Widget build(BuildContext context) {
    final start = weekStart(today);
    Widget row(int week) => Padding(
      padding: EdgeInsets.only(top: week == 0 ? 0 : LiltSpacing.sm),
      child: Row(
        children: [
          for (var i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: LiltSpacing.sm),
            Expanded(child: _tile(addDays(start, week * 7 + i))),
          ],
        ],
      ),
    );
    return RhythmCard(
      title: '',
      showTitle: false,
      semanticsOverride: 'Your first two weeks. Each day you check in fills a tile. Today is ${longDate(today)}.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your first two weeks', style: LiltText.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: LiltSpacing.md),
          row(0),
          row(1),
          const SizedBox(height: LiltSpacing.md),
          Text('Each day you check in fills a tile.', style: LiltText.label.copyWith(color: LiltColors.inkMuted)),
        ],
      ),
    );
  }

  /// Days before today in this week have no tile; today has the 2 px ring (DESIGN.md, Commit grid tile).
  Widget _tile(String day) {
    if (day.compareTo(today) < 0) return const SizedBox(height: 16);
    final isToday = day == today;
    return Container(
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isToday ? LiltColors.primary : LiltColors.line, width: isToday ? 2 : 1),
      ),
    );
  }
}

class _ProposedCard extends ConsumerStatefulWidget {
  const _ProposedCard({required this.observation});

  final Observation observation;

  @override
  ConsumerState<_ProposedCard> createState() => _ProposedCardState();
}

class _ProposedCardState extends ConsumerState<_ProposedCard> {
  bool _busy = false;
  bool _failed = false;

  Future<void> _answer(Future<bool> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    final ok = await action();
    if (mounted) {
      setState(() {
        _busy = false;
        _failed = !ok;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.read(rhythmControllerProvider.notifier);
    final id = widget.observation.id;
    return RhythmCard(
      title: '',
      showTitle: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('We noticed', style: LiltText.label.copyWith(color: LiltColors.inkMuted)),
          const SizedBox(height: LiltSpacing.sm),
          Text(
            '${widget.observation.text_}. Does this fit?',
            style: LiltText.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: LiltSpacing.lg),
          // Two equal choices: a yes is not made to look like the one to pick (BR-010).
          LiltButtonRow(
            children: [
              LiltButton(
                label: 'Yes, it fits',
                kind: LiltButtonKind.secondary,
                onPressed: _busy ? null : () => _answer(() => c.confirm(id)),
              ),
              LiltButton(
                label: 'Not really',
                kind: LiltButtonKind.secondary,
                onPressed: _busy ? null : () => _answer(() => c.remove(id)),
              ),
            ],
          ),
          if (_failed) ...[
            const SizedBox(height: LiltSpacing.md),
            Semantics(liveRegion: true, child: const Text('That didn’t save. Try again.', style: LiltText.body)),
          ],
        ],
      ),
    );
  }
}

class _ConfirmedCard extends ConsumerStatefulWidget {
  const _ConfirmedCard({required this.observation});

  final Observation observation;

  @override
  ConsumerState<_ConfirmedCard> createState() => _ConfirmedCardState();
}

class _ConfirmedCardState extends ConsumerState<_ConfirmedCard> {
  bool _failed = false;

  Future<void> _edit() async {
    final choice = await showObservationSheet(context, widget.observation);
    if (choice == null || !mounted) return;
    final c = ref.read(rhythmControllerProvider.notifier);
    final id = widget.observation.id;
    final ok = switch (choice) {
      ObservationKeep() => true,
      ObservationReworded(:final text) => await c.edit(id, text),
      ObservationRemoved() => await c.remove(id),
      // BR-003: nothing was stored. Show the support message and leave the card as it was.
      ObservationFlagged() => await _showSupport(),
    };
    if (mounted) setState(() => _failed = !ok);
  }

  Future<bool> _showSupport() async {
    await context.push('/support');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return RhythmCard(
      title: '',
      showTitle: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.observation.text_, style: LiltText.body),
          const SizedBox(height: LiltSpacing.xs),
          Text(
            _confirmedLine(widget.observation.patternKey),
            style: LiltText.label.copyWith(color: LiltColors.inkMuted),
          ),
          const SizedBox(height: LiltSpacing.xs),
          LiltButton(
            label: 'Edit',
            semanticLabel: 'Edit: ${widget.observation.text_}',
            kind: LiltButtonKind.text,
            flush: true,
            onPressed: _edit,
          ),
          if (_failed)
            Semantics(liveRegion: true, child: const Text('That didn’t save. Try again.', style: LiltText.body)),
        ],
      ),
    );
  }
}
