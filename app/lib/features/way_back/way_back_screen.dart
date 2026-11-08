import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../domain/ranking.dart';
import '../../ui/ui.dart';
import '../starting_point/setup_copy.dart';
import '../today/today_controller.dart';
import 'way_back_logic.dart';

/// The activities the person has done before, for the "Go back to what helped" card.
final _helpedProvider = FutureProvider.autoDispose<List<ActivityKind>>((ref) async {
  final inputs = await ref.read(todayRepositoryProvider).inputs();
  // Only activities Today could still offer: a leave-out is never named (BR-011).
  return [
    for (final k in previousActivities(inputs.reflections))
      if (inputs.actions.any((a) => a.activity == k && !isExcludedAction(a, inputs.person.excluded))) k,
  ];
});

/// S-005 My Way Back (frames 4.1 to 4.3, UF-004): what changed (optional), what to try, then one small first step
/// that waits on Today. No step records a loss, and nothing is planned here (BR-005, BR-007, BR-008).
class WayBackScreen extends ConsumerStatefulWidget {
  const WayBackScreen({super.key});

  @override
  ConsumerState<WayBackScreen> createState() => _WayBackScreenState();
}

class _WayBackScreenState extends ConsumerState<WayBackScreen> {
  static const _steps = 3;

  int _step = 0;
  Set<String> _whatChanged = {};
  ReturnApproach _approach = ReturnApproach.previous;
  WayBackStart? _start;
  bool _busy = false;

  void _toToday() => context.go('/today');

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
    } else if (_step == 2) {
      // The first step has already been put on Today, so Back leaves rather than asking the questions again.
      _toToday();
    } else {
      setState(() => _step--);
    }
  }

  Future<void> _showStep() async {
    if (_busy) return;
    setState(() => _busy = true);
    final start = await ref
        .read(todayControllerProvider.notifier)
        .startWayBack(whatChanged: _whatChanged, approach: _approach);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _start = start;
      _step = 2;
    });
  }

  Future<void> _pauseInstead() async {
    if (_busy) return;
    setState(() => _busy = true);
    await ref.read(todayControllerProvider.notifier).pause(7);
    if (!mounted) return;
    _toToday();
  }

  @override
  Widget build(BuildContext context) {
    final helped = ref.watch(_helpedProvider).valueOrNull ?? const <ActivityKind>[];
    final title = switch (_step) {
      0 => 'What changed?',
      1 => 'What would you like to try?',
      _ => _start == null ? 'Nothing to suggest right now' : 'A small first step',
    };

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(LiltSpacing.sm, LiltSpacing.sm, LiltSpacing.lg, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      tooltip: 'Back',
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: LiltSpacing.sm),
                    LiltStepProgress(step: _step + 1, steps: _steps),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.md, LiltSpacing.lg, LiltSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(header: true, liveRegion: true, child: Text(title, style: LiltText.display)),
                      const SizedBox(height: LiltSpacing.md),
                      ..._body(helped),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.lg),
                child: Column(mainAxisSize: MainAxisSize.min, children: _footer()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _body(List<ActivityKind> helped) {
    final muted = LiltText.body.copyWith(color: LiltColors.inkMuted);
    switch (_step) {
      case 0:
        return [
          Text('Only if you want to say. Skipping is fine.', style: muted),
          const SizedBox(height: LiltSpacing.lg),
          LiltChipWrap(
            children: [
              for (final o in whatChangedOptions)
                LiltChip(
                  label: o.label,
                  multi: true,
                  selected: _whatChanged.contains(o.code),
                  onTap: () => setState(() => _whatChanged = toggleWhatChanged(_whatChanged, o.code)),
                ),
            ],
          ),
        ];
      case 1:
        final names = [for (final a in helped.take(3)) activityLabel(a, null)];
        return [
          Text('Either way, the first step is a small one.', style: muted),
          const SizedBox(height: LiltSpacing.lg),
          LiltChoiceCard(
            title: 'Go back to what helped',
            subtitle: names.isEmpty ? 'Nothing logged yet, so we’ll start with a gentle starter.' : names.join(', '),
            kind: LiltChoiceKind.radio,
            selected: _approach == ReturnApproach.previous,
            onTap: () => setState(() => _approach = ReturnApproach.previous),
          ),
          const SizedBox(height: LiltSpacing.sm),
          LiltChoiceCard(
            title: 'Try something different',
            subtitle: 'A fresh idea, kept small.',
            kind: LiltChoiceKind.radio,
            selected: _approach == ReturnApproach.different,
            onTap: () => setState(() => _approach = ReturnApproach.different),
          ),
        ];
      default:
        final start = _start;
        if (start == null) {
          return [Text('Your answers are noted. Today will have ideas when something fits.', style: muted)];
        }
        return [
          Container(
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
                Text(start.title, style: LiltText.body.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: LiltSpacing.xs),
                Text('${start.durationMin} min · ${activityLabel(start.activity, null)}', style: muted),
                const SizedBox(height: LiltSpacing.sm),
                Text(start.reason, style: LiltText.body),
              ],
            ),
          ),
          const SizedBox(height: LiltSpacing.md),
          Text('It’s waiting on Today. Nothing is planned until you choose it.', style: muted),
        ];
    }
  }

  List<Widget> _footer() {
    switch (_step) {
      case 0:
        return [
          LiltButton(label: 'Next', onPressed: _whatChanged.isEmpty ? null : () => setState(() => _step = 1)),
          const SizedBox(height: LiltSpacing.sm),
          LiltButton(
            label: 'Skip',
            kind: LiltButtonKind.text,
            expand: true,
            onPressed: () => setState(() {
              _whatChanged = {};
              _step = 1;
            }),
          ),
        ];
      case 1:
        return [
          LiltButton(label: 'Show me a small first step', loading: _busy, onPressed: _showStep),
          const SizedBox(height: LiltSpacing.sm),
          LiltButton(
            label: 'Pause for a week instead',
            kind: LiltButtonKind.text,
            expand: true,
            onPressed: _busy ? null : _pauseInstead,
          ),
        ];
      default:
        return [LiltButton(label: 'Go to Today', onPressed: _toToday)];
    }
  }
}

/// The welcome-back banner on Today (frame 2.9): offered after a lapse, never pushed. "Not now" costs nothing.
class WelcomeBackBanner extends StatelessWidget {
  const WelcomeBackBanner({super.key, required this.onFind, required this.onNotNow});

  final VoidCallback onFind;
  final VoidCallback onNotNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LiltSpacing.lg),
      decoration: ShapeDecoration(
        color: LiltColors.selected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LiltRadius.card)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back. Want help picking a gentle first step?', style: LiltText.body),
          const SizedBox(height: LiltSpacing.sm),
          Wrap(
            children: [
              LiltButton(label: 'Find my way back', kind: LiltButtonKind.text, flush: true, onPressed: onFind),
              const SizedBox(width: LiltSpacing.lg),
              LiltButton(label: 'Not now', kind: LiltButtonKind.text, onPressed: onNotNow),
            ],
          ),
        ],
      ),
    );
  }
}
