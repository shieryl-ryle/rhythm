import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import '../starting_point/setup_copy.dart';
import '../today/reflection_sheet.dart';
import '../today/rhythm_grid.dart';
import '../today/today_controller.dart';
import '../today/today_repository.dart';
import 'rhythm_controller.dart';
import 'rhythm_repository.dart';

/// What the day detail says under the date: the day's level in words, never colour alone (frame 6.5).
String daySummary(GridDay day) {
  if (day.cell.isPause) return 'Paused';
  return switch (day.cell.level) {
    3 => 'Done · counts toward your rhythm',
    2 || 1 => 'Partly · counts toward your rhythm',
    _ => 'Rest or not shared',
  };
}

/// S-113 Day detail (frame 6.5): one day's date, how it counted, and each thing planned that day with Edit or
/// Add answer. An answer can be kept or raised, never lowered (BR-007, EQ-011).
Future<void> showDaySheet(BuildContext context, GridDay day) {
  return showLiltSheet<void>(
    context,
    title: longDate(day.day),
    // A day with nothing done has no line of its own: its entries say how each went, and an empty one says so.
    subtitle: day.cell.isPause || day.cell.level > 0 ? daySummary(day) : null,
    bodyBuilder: (_) => _DayEntries(day: day.day),
  );
}

class _DayEntries extends ConsumerWidget {
  const _DayEntries({required this.day});

  final String day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(dayEntriesProvider(day));
    // Full width: the sheet centres a body narrower than itself, which would indent the date line above it.
    return SizedBox(
      width: double.infinity,
      child: entries.when(
        loading: () => const SizedBox(height: LiltSpacing.xxxl),
        error: (_, _) => Semantics(
          liveRegion: true,
          child: const Text('That didn’t load. Close this and try again.', style: LiltText.body),
        ),
        data: (list) {
          if (list.isEmpty) return const Text('Nothing was planned this day.', style: LiltText.body);
          return Column(
            children: [
              for (final e in list) ...[_EntryCard(day: day, entry: e), const SizedBox(height: LiltSpacing.md)],
            ],
          );
        },
      ),
    );
  }
}

String _statusLine(DayEntry e) {
  final status = switch (e.status) {
    ReflectionStatus.completed => 'Done',
    ReflectionStatus.partly => 'Partly',
    ReflectionStatus.skipped => 'Not this time',
    ReflectionStatus.unknown => 'Not shared',
  };
  final how = switch (e.reflection.enjoyment) {
    3 => 'enjoyed it',
    2 => 'okay',
    1 => 'not for me',
    _ => null,
  };
  return how == null ? status : '$status · $how';
}

class _EntryCard extends ConsumerStatefulWidget {
  const _EntryCard({required this.day, required this.entry});

  final String day;
  final DayEntry entry;

  @override
  ConsumerState<_EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends ConsumerState<_EntryCard> {
  bool _failed = false;

  Future<void> _answer() async {
    final e = widget.entry;
    final answered = e.status != ReflectionStatus.unknown;
    final answer = await showReflectionSheet(
      context,
      activityTitle: e.title,
      initial: answered
          ? ReflectionAnswer(status: e.status, enjoyment: e.reflection.enjoyment, barrier: e.reflection.barrier)
          : null,
      allowed: allowedAnswers(e.status),
    );
    if (answer == null || !mounted) return;
    try {
      final result = await ref
          .read(todayRepositoryProvider)
          .saveReflection(e.planItemId, status: answer.status, enjoyment: answer.enjoyment, barrier: answer.barrier);
      if (result != ReflectionSave.saved) throw StateError('not saved');
      ref.invalidate(dayEntriesProvider(widget.day));
      await ref.read(rhythmControllerProvider.notifier).reload();
      if (mounted) setState(() => _failed = false);
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final answered = e.status != ReflectionStatus.unknown;
    return RhythmCard(
      title: '',
      showTitle: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: LiltColors.selected,
                borderRadius: BorderRadius.circular(LiltRadius.pill),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.md, vertical: LiltSpacing.xs),
                child: Text(activityLabel(e.activity, null), style: LiltText.label.copyWith(fontSize: 13)),
              ),
            ),
          ),
          const SizedBox(height: LiltSpacing.sm),
          Text(e.title, style: LiltText.body.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: LiltSpacing.xs),
          Text(_statusLine(e), style: LiltText.label.copyWith(color: LiltColors.inkMuted)),
          Align(
            alignment: Alignment.centerRight,
            child: LiltButton(
              label: answered ? 'Edit' : 'Add answer',
              semanticLabel: '${answered ? 'Edit' : 'Add answer'}: ${e.title}',
              kind: LiltButtonKind.text,
              onPressed: _answer,
            ),
          ),
          if (_failed)
            Semantics(liveRegion: true, child: const Text('That didn’t save. Try again.', style: LiltText.body)),
        ],
      ),
    );
  }
}
