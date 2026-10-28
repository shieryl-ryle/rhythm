import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../ui/ui.dart';
import 'option_cards.dart';
import 'reflection_sheet.dart';
import 'rhythm_grid.dart';
import 'today_controller.dart';
import 'today_logic.dart';
import 'today_repository.dart';
import 'today_sheets.dart';

/// S-004 Today (frames 1.16, 2.3, 2.5, 2.8, 9.3): this week's rhythm, the time and energy chips, one expanded
/// option with its reason, and compact cards for the other activities followed. One filled button on the
/// screen (DESIGN.md). Nothing is planned until the person taps "I'll try this" (BR-005).
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Back from the background on a new day: show the new day, with fresh chips and a fresh chain.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.read(todayControllerProvider.notifier).refreshIfNewDay(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(todayControllerProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            LiltHeader(
              onProfile: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings are coming soon.')),
              ),
            ),
            Expanded(
              child: async.when(
                data: (view) => _TodayBody(view: view),
                // Frame loading state: the rhythm card as empty tiles, nothing else.
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: LiltSpacing.lg),
                  child: Align(alignment: Alignment.topCenter, child: RhythmGridSkeleton()),
                ),
                error: (_, _) => _LoadFailed(onRetry: () => ref.invalidate(todayControllerProvider)),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LiltSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Today didn’t load', style: LiltText.display.copyWith(fontSize: 30), textAlign: TextAlign.center),
            const SizedBox(height: LiltSpacing.sm),
            Text('Your answers are safe. Try again.', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
            const SizedBox(height: LiltSpacing.xl),
            LiltButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(todayControllerProvider.notifier);
    final mode = view.mode;
    final large = MediaQuery.textScalerOf(context).scale(1) >= 1.5;

    final title = switch (mode) {
      TodayMode.paused => 'Paused, resume anytime',
      TodayMode.nothingFitsChips => 'Nothing fits those choices',
      TodayMode.nothingFitsChoices => 'Nothing to suggest right now',
      TodayMode.allDone => 'That’s all for today',
      TodayMode.options => view.hasPlan
          ? 'Today’s plan'
          : (view.hasHistory ? 'Here’s what fits today' : 'Your first ideas'),
    };

    final rhythm = Semantics(
      sortKey: const OrdinalSortKey(1),
      child: view.hasHistory ? RhythmGridCard(days: view.grid) : WeekStripCard(days: view.weekStrip),
    );
    final showChips = mode == TodayMode.options && !view.hasPlan || mode == TodayMode.nothingFitsChips;
    final titleWidget = Semantics(
      header: true,
      liveRegion: true,
      sortKey: const OrdinalSortKey(0),
      child: Text(title, style: LiltText.display),
    );

    void notToday({TodayOption? option, bool lighter = false}) => showNotTodaySheet(
          context,
          lighterAvailable: lighter && view.lighterAvailable,
          onLighter: c.lighter,
          onPause: (days) => c.pause(days, option: option),
        );

    // "I'll try this" plans it and offers Undo, because a plan item is created (BR-005: only on a tap).
    Future<void> accepted(Future<bool> Function() accept) async {
      final messenger = ScaffoldMessenger.of(context);
      final planned = await accept();
      if (!planned) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Added to today’s plan'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.lg),
            action: SnackBarAction(label: 'Undo', onPressed: c.undoLastAccept),
          ),
        );
    }

    // "How did it go?": the sheet, then the one sentence that says what will change (F-003). Closing it without
    // saving changes nothing: the reflection stays unknown (BR-009).
    Future<void> reflect(PlannedItem p) async {
      final messenger = ScaffoldMessenger.of(context);
      final answer = await showReflectionSheet(
        context,
        activityTitle: p.title,
        initial: p.isOpen
            ? null
            : ReflectionAnswer(
                status: p.reflection.status,
                enjoyment: p.reflection.enjoyment,
                barrier: p.reflection.barrier,
              ),
      );
      if (answer == null) return;
      final sentence = await c.saveReflection(p, answer);
      if (sentence == null) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(sentence),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.lg),
          ),
        );
    }

    final children = <Widget>[];

    // Plan items from later days and from earlier days still waiting for an answer (UF-003), below the options.
    void planSections() {
      void section(String heading, List<PlannedItem> items, {bool reflectable = false}) {
        if (items.isEmpty) return;
        children
          ..add(const SizedBox(height: LiltSpacing.sm))
          ..add(Semantics(header: true, child: Text(heading, style: LiltText.body.copyWith(fontWeight: FontWeight.w600))))
          ..add(const SizedBox(height: LiltSpacing.md));
        for (final p in items) {
          children
            ..add(PlannedCard(planned: p, today: view.today, onReflect: reflectable ? () => reflect(p) : null))
            ..add(const SizedBox(height: LiltSpacing.md));
        }
      }

      section('Coming up', view.upcomingItems);
      section('From earlier', view.earlierOpen, reflectable: true);
    }

    if (mode == TodayMode.paused) {
      // Frame 2.8: the pause comes first, the rhythm under it. A plan made before pausing stays visible.
      children
        ..add(titleWidget)
        ..add(const SizedBox(height: LiltSpacing.md))
        ..add(Text(_pausedBody(view), style: LiltText.body.copyWith(color: LiltColors.inkMuted)))
        ..add(const SizedBox(height: LiltSpacing.lg))
        ..add(LiltButton(label: 'Resume now', onPressed: c.resume))
        ..add(const SizedBox(height: LiltSpacing.lg));
      for (final p in view.todayItems) {
        children
          ..add(PlannedCard(planned: p, today: view.today, onReflect: () => reflect(p)))
          ..add(const SizedBox(height: LiltSpacing.md));
      }
      children.add(rhythm);
    } else {
      // At large text the rhythm card moves under the options, so the first screen has the action on it.
      if (!large) {
        children
          ..add(rhythm)
          ..add(const SizedBox(height: LiltSpacing.lg));
      }
      children
        ..add(Text(longDate(view.today), style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)))
        ..add(const SizedBox(height: LiltSpacing.xs))
        ..add(titleWidget);

      if (showChips) {
        children
          ..add(const SizedBox(height: LiltSpacing.md))
          ..add(
            LiltChipWrap(
              children: [
                LiltChip(
                  label: '${view.chips.timeMin} min',
                  menu: true,
                  onTap: () => showTimeSheet(
                    context,
                    current: view.chips.timeMin,
                    onPick: (m) => c.setChips(view.chips.copyWith(timeMin: m)),
                  ),
                ),
                LiltChip(
                  label: '${energyLabel(view.chips.energy)} energy',
                  menu: true,
                  onTap: () => showEnergySheet(
                    context,
                    current: view.chips.energy,
                    onPick: (e) => c.setChips(view.chips.copyWith(energy: e)),
                  ),
                ),
              ],
            ),
          );
      }
      children.add(const SizedBox(height: LiltSpacing.lg));

      switch (mode) {
        case TodayMode.options:
          if (view.hasPlan) {
            for (final p in view.todayItems) {
              children
                ..add(PlannedCard(
                  planned: p,
                  today: view.today,
                  onReflect: () => reflect(p),
                  onNotToday: notToday,
                ))
                ..add(const SizedBox(height: LiltSpacing.md));
            }
            if (view.compact.isNotEmpty) {
              children
                ..add(const SizedBox(height: LiltSpacing.sm))
                ..add(Semantics(header: true, child: Text('Still open', style: LiltText.body.copyWith(fontWeight: FontWeight.w600))))
                ..add(const SizedBox(height: LiltSpacing.md));
            }
          } else if (view.shown != null) {
            final shown = view.shown!;
            children
              ..add(HeroCard(
                offer: shown,
                relation: relationLabel(shown.action.activity, view.followedPaths),
                today: view.today,
                position: view.heroPosition,
                total: view.heroTotal,
                canSwap: view.canSwap,
                onAccept: () => accepted(c.acceptShown),
                onSwap: c.swapShown,
                onNotToday: () => notToday(lighter: true),
              ))
              ..add(const SizedBox(height: LiltSpacing.md));
          }
          for (final option in view.compact) {
            children
              ..add(CompactCard(
                option: option,
                relation: relationLabel(option.ranked.action.activity, view.followedPaths),
                today: view.today,
                onAccept: () => accepted(() => c.acceptCompact(option)),
                onNotToday: () => notToday(option: option),
              ))
              ..add(const SizedBox(height: LiltSpacing.md));
          }
          planSections();

        case TodayMode.nothingFitsChips:
          // State N2: the chips are the cause. The button relaxes them for today only; it plans nothing (BR-005).
          // The body names only what can be done on this screen: "add something of your own" comes with that control.
          final relax = view.plan.relaxation!;
          children
            ..add(Text('Change the time or energy.', style: LiltText.body.copyWith(color: LiltColors.inkMuted)))
            ..add(const SizedBox(height: LiltSpacing.lg))
            ..add(LiltButton(label: relax.label, onPressed: () => c.setChips(relax.chips)))
            ..add(const SizedBox(height: LiltSpacing.sm))
            ..add(LiltButton(label: 'Not today', kind: LiltButtonKind.text, expand: true, onPressed: notToday));

        case TodayMode.nothingFitsChoices:
          // State N3: nothing fits even without the chips, so the chips are hidden: they cannot fix it.
          children
            ..add(Text(
              'Your leave-out and access choices cover everything we have.',
              style: LiltText.body.copyWith(color: LiltColors.inkMuted),
            ))
            ..add(const SizedBox(height: LiltSpacing.lg))
            ..add(LiltButton(label: 'Not today', kind: LiltButtonKind.text, expand: true, onPressed: notToday));

        case TodayMode.allDone:
          children
            ..add(Text('Rest counts too. Come back tomorrow for new ideas.', style: LiltText.body.copyWith(color: LiltColors.inkMuted)))
            ..add(const SizedBox(height: LiltSpacing.lg))
            ..add(LiltButton(label: 'Not today', kind: LiltButtonKind.text, expand: true, onPressed: notToday));

        case TodayMode.paused:
          break;
      }

      if (large) {
        children
          ..add(const SizedBox(height: LiltSpacing.sm))
          ..add(rhythm);
      }
    }

    // A column in a scroll view, not a lazy list: the screen is short, and everything on it exists for screen
    // readers and tests, not only what is on screen.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  /// "Rest counts too. Reminders are off until Monday 26 October. Your progress stays." (frame 2.8).
  String _pausedBody(TodayView view) {
    final end = view.pause?.endDay;
    return end == null
        ? 'Rest counts too. Your progress stays.'
        : 'Rest counts too. Reminders are off until ${longDate(end)}. Your progress stays.';
  }
}
