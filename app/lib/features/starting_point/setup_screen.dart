import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import 'activity_search_screen.dart';
import 'setup_controller.dart';
import 'setup_copy.dart';
import 'setup_model.dart';

/// S-003 My Starting Point: one question at a time, each with a Next button and no auto-advance (DESIGN.md).
/// Frames 1.3 to 1.15. Earlier answers fold into a summary row that can be changed.
///
/// Next sits in the same place on every question (y736 to 784 on an 800 dp screen). A question that can be
/// skipped has Skip at the top right, so adding it never moves Next or leaves it touching another button.
class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);

    if (state.saving || state.failed) {
      return Scaffold(
        body: SafeArea(
          child: _Finding(failed: state.failed, onRetry: controller.finish, onBack: controller.dismissFailure),
        ),
      );
    }

    final step = state.step;
    final a = state.answers;
    final summary = summaryFor(step, a);
    final eyebrow = eyebrowFor(step);
    final helper = helperFor(step, a);
    final ready = canContinue(step, a);
    final hint = !ready ? requiredHint(step) : null;

    return PopScope(
      canPop: state.index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.back();
      },
      child: Scaffold(
        body: SafeArea(
          child: _ScrollFrame(
            scrollKey: ValueKey(step),
            header: (scrolled) => _Header(
              onBack: state.index == 0 ? null : controller.back,
              onSkip: canSkip(step) ? controller.skip : null,
              divider: scrolled,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LiltStepProgress(step: state.index + 1, steps: state.steps.length),
                const SizedBox(height: LiltSpacing.md),
                if (eyebrow != null) Text(eyebrow, style: LiltText.label.copyWith(color: LiltColors.inkMuted)),
                if (summary != null) ...[
                  const SizedBox(height: LiltSpacing.sm),
                  _SummaryRow(text: summary, onEdit: controller.editSection),
                ],
                const SizedBox(height: LiltSpacing.md),
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(titleFor(step, a), style: LiltText.display),
                ),
                if (helper != null) ...[
                  const SizedBox(height: LiltSpacing.md),
                  Text(
                    helper,
                    style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400),
                  ),
                ],
                const SizedBox(height: LiltSpacing.lg),
                _Question(step: step),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hint != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LiltSpacing.sm),
                      // Screen readers hear the hint with the button, so they know why it is off.
                      child: ExcludeSemantics(
                        child: Text(
                          hint,
                          textAlign: TextAlign.center,
                          style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  Semantics(
                    hint: hint,
                    child: LiltButton(
                      label: state.isLast ? 'Show me today' : 'Next',
                      onPressed: ready ? (state.isLast ? controller.finish : controller.next) : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A pinned header, a scrolling body and a pinned footer. A hairline shows under the header once the body has
/// scrolled, so content never slides under it unmarked.
class _ScrollFrame extends StatefulWidget {
  const _ScrollFrame({required this.scrollKey, required this.header, required this.body, required this.footer});

  final Key scrollKey;
  final Widget Function(bool scrolled) header;
  final Widget body;
  final Widget footer;

  @override
  State<_ScrollFrame> createState() => _ScrollFrameState();
}

class _ScrollFrameState extends State<_ScrollFrame> {
  bool _scrolled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header(_scrolled),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              final scrolled = n.metrics.pixels > 0;
              if (scrolled != _scrolled && n.depth == 0) setState(() => _scrolled = scrolled);
              return false;
            },
            child: SingleChildScrollView(
              key: widget.scrollKey,
              padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.lg),
              child: widget.body,
            ),
          ),
        ),
        widget.footer,
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onSkip, required this.divider});

  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    // At least 64 dp, and taller when the title wraps at large text, so it is never cut off.
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: divider ? LiltColors.line : Colors.transparent)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Row(
          children: [
            const SizedBox(width: LiltSpacing.xs),
            SizedBox(
              width: 48,
              height: 48,
              child: onBack == null
                  ? null
                  : IconButton(onPressed: onBack, tooltip: 'Back', icon: const Icon(Icons.arrow_back)),
            ),
            const SizedBox(width: LiltSpacing.sm),
            // The running title repeats on every step, so it is not a heading for screen readers: the question is.
            Expanded(child: Text('Getting to know you', style: LiltText.body.copyWith(fontWeight: FontWeight.w600))),
            if (onSkip != null)
              Padding(
                padding: const EdgeInsets.only(right: LiltSpacing.sm),
                child: LiltButton(label: 'Skip', kind: LiltButtonKind.text, onPressed: onSkip),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.text, required this.onEdit});

  final String text;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.only(
        left: LiltSpacing.lg,
        right: LiltSpacing.xs,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LiltRadius.md),
          side: const BorderSide(color: LiltColors.line),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: LiltText.label.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          LiltButton(
            label: 'Edit',
            kind: LiltButtonKind.text,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

/// The body of one question.
class _Question extends ConsumerWidget {
  const _Question({required this.step});

  final SetupStep step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(setupControllerProvider.select((s) => s.answers));
    final c = ref.read(setupControllerProvider.notifier);

    Widget group(String heading, Widget chips) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: LiltText.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: LiltSpacing.md),
        chips,
      ],
    );

    Widget multi<T>(
      List<Option<T>> options,
      Set<T> selected,
      void Function(T) onTap,
    ) => LiltChipWrap(
      children: [
        for (final o in options)
          LiltChip(
            label: o.label,
            multi: true,
            selected: selected.contains(o.value),
            onTap: () => onTap(o.value),
          ),
      ],
    );

    Widget cards<T>(
      List<Option<T>> options,
      T? selected,
      void Function(T) onTap,
    ) => Column(
      children: [
        for (final o in options) ...[
          LiltChoiceCard(
            title: o.label,
            kind: LiltChoiceKind.radio,
            selected: selected == o.value,
            onTap: () => onTap(o.value),
          ),
          const SizedBox(height: LiltSpacing.sm),
        ],
      ],
    );

    switch (step) {
      case SetupStep.brings:
        return Column(
          children: [
            for (final o in pathOptions) ...[
              LiltChoiceCard(
                title: o.label,
                subtitle: o.subtitle,
                selected: a.paths.contains(o.value),
                dimmed:
                    o.value == SetupPath.startFresh &&
                    a.paths.isNotEmpty &&
                    !a.paths.contains(o.value),
                onTap: () => c.togglePath(o.value),
              ),
              const SizedBox(height: LiltSpacing.sm),
            ],
          ],
        );

      case SetupStep.keepActivity:
        return _ActivityChips(
          kinds: keepGoingKinds,
          kind: a.keepActivity,
          customName: a.keepCustomName,
          onPick: (kind, name) => c.setKeepActivity(kind, customName: name),
        );

      case SetupStep.keepProgress:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cards(progressOptions, a.progress, c.setProgress),
            if (a.asksWhatMakesItHarder) ...[
              const SizedBox(height: LiltSpacing.md),
              const Divider(height: 1, color: LiltColors.line),
              const SizedBox(height: LiltSpacing.xl),
              group(
                'What’s making it harder? (optional)',
                multi(hardBecauseOptions, a.hardBecause, c.toggleHardBecause),
              ),
            ],
          ],
        );

      case SetupStep.addNew:
        return _ActivityChips(
          kinds: addNewKinds,
          kind: a.addNewActivity,
          customName: a.addNewCustomName,
          onPick: (kind, name) => c.setAddNew(kind, customName: name),
        );

      case SetupStep.pickUpWhich:
        return _ActivityChips(
          kinds: pickUpKinds,
          kind: a.pickUpActivity,
          customName: a.pickUpCustomName,
          onPick: (kind, name) => c.setPickUp(kind, customName: name),
        );

      case SetupStep.pickUpStopped:
        return cards(stoppedOptions, a.stoppedAgo, c.setStopped);

      case SetupStep.pickUpGotInWay:
        return multi(gotInTheWayOptions, a.gotInTheWay, c.toggleGotInTheWay);

      case SetupStep.pickUpHelp:
        return multi(wouldHelpOptions, a.wouldHelp, c.toggleWouldHelp);

      case SetupStep.startFresh:
        return LiltChipWrap(
          children: [
            for (final o in freshOptions)
              LiltChip(label: o.label, selected: a.freshChoice == o.value, onTap: () => c.setFresh(o.value)),
          ],
        );

      case SetupStep.week:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            group(
              'Usually free',
              multi(freeTimeOptions, a.freeTimes, c.toggleFreeTime),
            ),
            const SizedBox(height: LiltSpacing.section),
            group(
              'What you have access to',
              multi(accessOptions, a.access, c.toggleAccess),
            ),
            const SizedBox(height: LiltSpacing.section),
            group(
              'What usually gets in the way',
              multi(barrierOptions, a.barriers, c.toggleBarrier),
            ),
          ],
        );

      case SetupStep.why:
        return multi(motivationOptions, a.motivations, c.toggleMotivation);

      case SetupStep.leaveOut:
        final conflicts = leaveOutConflicts(a);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LiltChipWrap(
              children: [
                for (final o in leaveOutOptions)
                  LiltChip(
                    label: o.label,
                    multi: true,
                    selected: a.excluded.contains(o.value),
                    onTap: () => c.toggleExcluded(o.value),
                  ),
                LiltChip(
                  label: 'Nothing to leave out',
                  selected: a.excluded.isEmpty,
                  onTap: c.clearExcluded,
                ),
              ],
            ),
            if (conflicts.isNotEmpty) ...[
              const SizedBox(height: LiltSpacing.lg),
              Text(
                'You also picked ${conflicts.map((k) => activityLabel(k, null).toLowerCase()).join(' and ')}. '
                'We won’t suggest ${conflicts.length == 1 ? 'it' : 'them'} while ${conflicts.length == 1 ? 'it is' : 'they are'} left out.',
                style: LiltText.label.copyWith(
                  color: LiltColors.inkMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        );
    }
  }
}

/// Single-choice activity chips, then "Other", which opens the search (frame 1.6). An activity picked from the
/// search that is not one of the chips shows as its own selected chip, so the answer is always visible.
class _ActivityChips extends StatelessWidget {
  const _ActivityChips({
    required this.kinds,
    required this.kind,
    required this.customName,
    required this.onPick,
  });

  final List<ActivityKind> kinds;
  final ActivityKind? kind;
  final String? customName;
  final void Function(ActivityKind kind, String? customName) onPick;

  @override
  Widget build(BuildContext context) {
    final extra = kind != null && !kinds.contains(kind) ? kind : null;
    return LiltChipWrap(
      children: [
        for (final k in kinds)
          LiltChip(
            label: activityLabel(k, null),
            selected: kind == k,
            onTap: () => onPick(k, null),
          ),
        if (extra != null && extra != ActivityKind.other)
          LiltChip(
            label: activityLabel(extra, null),
            selected: true,
            onTap: () {},
          ),
        if (kind == ActivityKind.other && customName != null)
          LiltChip(label: customName!, selected: true, onTap: () {}),
        LiltChip(
          label: 'Other',
          selected: false,
          onTap: () async {
            final pick = await Navigator.of(context).push<ActivityPick>(
              MaterialPageRoute(builder: (_) => const ActivitySearchScreen()),
            );
            if (pick != null) onPick(pick.kind, pick.customName);
          },
        ),
      ],
    );
  }
}

/// Frame 1.15 "Setting up": shown while the answers are saved. If saving fails nothing was stored and the person
/// can try again.
class _Finding extends StatelessWidget {
  const _Finding({
    required this.failed,
    required this.onRetry,
    required this.onBack,
  });

  final bool failed;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LiltSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EqualizerBars(height: 40),
            const SizedBox(height: LiltSpacing.xl),
            Semantics(
              liveRegion: true,
              child: Text(
                failed ? 'That didn’t save' : 'Finding ideas that fit you…',
                textAlign: TextAlign.center,
                style: LiltText.display.copyWith(fontSize: 30),
              ),
            ),
            const SizedBox(height: LiltSpacing.sm),
            Text(
              failed
                  ? 'Nothing was stored. Your answers are still here.'
                  : 'Using what you just told us.',
              textAlign: TextAlign.center,
              style: LiltText.body.copyWith(color: LiltColors.inkMuted),
            ),
            if (failed) ...[
              const SizedBox(height: LiltSpacing.xl),
              LiltButton(label: 'Try again', onPressed: onRetry),
              LiltButton(
                label: 'Back to my answers',
                kind: LiltButtonKind.text,
                onPressed: onBack,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
