import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../ui/ui.dart';
import 'option_cards.dart';
import 'rhythm_grid.dart';
import 'today_controller.dart';
import 'today_logic.dart';
import 'today_sheets.dart';

/// S-004 Today (frames 1.16, 2.3, 2.5, 2.8, 9.3): this week's rhythm, the time and energy chips, one expanded
/// option with its reason, and compact cards for the other activities followed. One filled button on the
/// screen (DESIGN.md). Nothing is planned until the person taps "I'll try this" (BR-005).
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                loading: () => const SizedBox.shrink(),
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
            Text('Nothing was lost. Try again.', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
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

    final title = switch (mode) {
      TodayMode.paused => 'Paused, resume anytime',
      TodayMode.nothingFitsChips => 'Nothing fits those choices',
      TodayMode.nothingFitsChoices => 'Nothing to suggest right now',
      TodayMode.allDone => 'That’s all for today',
      TodayMode.options => view.accepted.isNotEmpty
          ? 'Today’s plan'
          : (view.hasHistory ? 'Here’s what fits today' : 'Your first ideas'),
    };

    final rhythm = view.hasHistory ? RhythmGridCard(days: view.grid) : WeekStripCard(days: view.weekStrip);
    final showChips = mode == TodayMode.options && view.accepted.isEmpty || mode == TodayMode.nothingFitsChips;

    void notToday({TodayOption? option, bool lighter = false}) => showNotTodaySheet(
          context,
          lighterAvailable: lighter && view.lighterAvailable,
          onLighter: c.lighter,
          onPause: (days) => c.pause(days, option: option),
        );

    final children = <Widget>[];

    if (mode == TodayMode.paused) {
      // Frame 2.8: the pause comes first, the rhythm under it.
      children
        ..add(Semantics(header: true, liveRegion: true, child: Text(title, style: LiltText.display)))
        ..add(const SizedBox(height: LiltSpacing.md))
        ..add(Text(_pausedBody(view), style: LiltText.body.copyWith(color: LiltColors.inkMuted)))
        ..add(const SizedBox(height: LiltSpacing.lg))
        ..add(LiltButton(label: 'Resume now', onPressed: c.resume))
        ..add(const SizedBox(height: LiltSpacing.lg))
        ..add(rhythm);
    } else {
      children
        ..add(rhythm)
        ..add(const SizedBox(height: LiltSpacing.lg))
        ..add(Text(longDate(view.today), style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)))
        ..add(const SizedBox(height: LiltSpacing.xs))
        ..add(Semantics(header: true, liveRegion: true, child: Text(title, style: LiltText.display)));

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
          if (view.accepted.isNotEmpty) {
            for (final a in view.accepted) {
              children
                ..add(PlannedCard(offer: a, today: view.today))
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
                onAccept: c.acceptShown,
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
                onAccept: () => c.acceptCompact(option),
                onNotToday: () => notToday(option: option),
              ))
              ..add(const SizedBox(height: LiltSpacing.md));
          }

        case TodayMode.nothingFitsChips:
          // State N2: the chips are the cause. The button relaxes them for today only; it plans nothing (BR-005).
          final relax = view.plan.relaxation!;
          children
            ..add(Text(
              'Change the time or energy, or add something of your own.',
              style: LiltText.body.copyWith(color: LiltColors.inkMuted),
            ))
            ..add(const SizedBox(height: LiltSpacing.lg))
            ..add(LiltButton(label: relax.label, onPressed: () => c.setChips(relax.chips)))
            ..add(LiltButton(label: 'Not today', kind: LiltButtonKind.text, expand: true, onPressed: notToday));

        case TodayMode.nothingFitsChoices:
          // State N3: nothing fits even without the chips, so the chips are hidden: they cannot fix it.
          children
            ..add(Text(
              'Your leave-out and access choices cover everything we have. You can change them any time.',
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
