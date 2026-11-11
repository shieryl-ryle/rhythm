import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../ui/ui.dart';
import '../today/today_controller.dart';
import 'discover_controller.dart';
import 'discover_logic.dart';

/// Plans an idea because the person tapped "Plan it" (BR-005), then says so with an Undo. With a screen reader on
/// the Undo stays until the person leaves the screen (WCAG 2.2.1), as on Today.
Future<void> planFromDiscover(BuildContext context, WidgetRef ref, String actionId) async {
  final messenger = ScaffoldMessenger.of(context);
  final screenReader = MediaQuery.accessibleNavigationOf(context);
  final outcome = await ref.read(discoverControllerProvider.notifier).plan(actionId);
  final planned = outcome == PlanOutcome.planned;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(switch (outcome) {
          PlanOutcome.planned => 'Added to your plan',
          PlanOutcome.paused => 'You’re on a pause. Resume on Today when you’re ready.',
          PlanOutcome.unavailable => 'Couldn’t add that right now.',
        }),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.lg),
        persist: planned && screenReader,
        duration: const Duration(seconds: 6),
        action: planned
            ? SnackBarAction(
                label: 'Undo',
                onPressed: ref.read(todayControllerProvider.notifier).undoLastAccept,
              )
            : null,
      ),
    );
}

/// S-009 Discover (frames 5.1 to 5.3): ideas from the library ordered for the person, with what they have saved.
/// Every card says why it is suggested (BR-004); nothing is planned until a tap (BR-005).
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(discoverControllerProvider);
    final tab = ref.watch(discoverTabProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            LiltHeader(onProfile: () => context.push('/settings')),
            Padding(
              padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.md),
              child: LiltSegmented<DiscoverTab>(
                segments: const [
                  LiltSegment(value: DiscoverTab.forYou, label: 'For you'),
                  LiltSegment(value: DiscoverTab.saved, label: 'Saved'),
                ],
                value: tab,
                onChanged: (t) => ref.read(discoverTabProvider.notifier).state = t,
              ),
            ),
            Expanded(
              child: async.when(
                data: (inputs) => _Body(inputs: inputs, tab: tab),
                loading: () => const _Loading(),
                error: (_, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(LiltSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Discover didn’t load', style: LiltText.display.copyWith(fontSize: 30), textAlign: TextAlign.center),
                        const SizedBox(height: LiltSpacing.sm),
                        Text('Your answers are safe. Try again.', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
                        const SizedBox(height: LiltSpacing.xl),
                        LiltButton(label: 'Try again', onPressed: () => ref.invalidate(discoverControllerProvider)),
                      ],
                    ),
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

/// Frame 5.3: the cards as empty shapes, nothing else.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.lg),
      child: Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            Container(
              height: 112,
              decoration: ShapeDecoration(
                color: LiltColors.grid0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LiltRadius.card)),
              ),
            ),
            const SizedBox(height: LiltSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.inputs, required this.tab});

  final DiscoverInputs inputs;
  final DiscoverTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(discoverFilterProvider);
    final today = inputs.today;
    final muted = LiltText.body.copyWith(color: LiltColors.inkMuted);

    final items = tab == DiscoverTab.forYou
        ? forYouItems(
            actions: today.actions,
            person: today.person,
            libraryVersion: today.libraryVersion,
            filters: filters,
            saved: inputs.saved,
          )
        : savedItems(
            actions: today.actions,
            person: today.person,
            libraryVersion: today.libraryVersion,
            savedOrder: inputs.savedOrder,
          );

    Widget empty() {
      if (tab == DiscoverTab.saved) {
        return Text('Nothing saved yet. Tap the bookmark on an idea to keep it here.', style: muted);
      }
      if (filters.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nothing matches those filters.', style: muted),
            const SizedBox(height: LiltSpacing.sm),
            LiltButton(
              label: 'Clear filters',
              kind: LiltButtonKind.text,
              flush: true,
              onPressed: () => ref.read(discoverFilterProvider.notifier).state = const {},
            ),
          ],
        );
      }
      // Frame state "all excluded": the leave-outs cover everything, so say so rather than show a blank screen.
      return Text('Your leave-out and access choices cover everything we have.', style: muted);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.xl),
      children: [
        if (tab == DiscoverTab.forYou) ...[
          LiltChipWrap(
            children: [
              for (final f in DiscoverFilter.values)
                LiltChip(
                  label: f.label,
                  multi: true,
                  selected: filters.contains(f),
                  onTap: () => ref.read(discoverFilterProvider.notifier).state =
                      filters.contains(f) ? ({...filters}..remove(f)) : {...filters, f},
                ),
            ],
          ),
          const SizedBox(height: LiltSpacing.md),
        ],
        if (items.isEmpty)
          empty()
        else
          for (final item in items) ...[
            IdeaCard(
              item: item,
              onOpen: () => context.push('/activity/${item.action.id}'),
              onToggleSaved: () => ref.read(discoverControllerProvider.notifier).toggleSaved(item.action.id),
              onPlan: tab == DiscoverTab.saved ? () => planFromDiscover(context, ref, item.action.id) : null,
            ),
            const SizedBox(height: LiltSpacing.md),
          ],
      ],
    );
  }
}

/// A square tile with the activity's icon (the frames use small illustrations).
class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.item, this.size = 56});

  final DiscoverItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: LiltColors.selected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LiltRadius.md)),
        ),
        child: Icon(iconForAction(item.action), color: LiltColors.primary, size: size * 0.5),
      ),
    );
  }
}

/// "New for you" in a small tinted pill (frame 5.1).
class NewPill extends StatelessWidget {
  const NewPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.sm, vertical: LiltSpacing.xs),
      decoration: ShapeDecoration(color: LiltColors.selected, shape: const StadiumBorder()),
      child: Text('New for you', style: LiltText.label.copyWith(fontSize: 12, color: LiltColors.primary)),
    );
  }
}

/// One idea on Discover (frames 5.1 and 5.2): tap the card for its detail, the bookmark to save or remove it, and
/// on the Saved tab "Plan" to put it in the plan.
class IdeaCard extends StatelessWidget {
  const IdeaCard({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onToggleSaved,
    this.onPlan,
  });

  final DiscoverItem item;
  final VoidCallback onOpen;
  final VoidCallback onToggleSaved;
  final VoidCallback? onPlan;

  @override
  Widget build(BuildContext context) {
    final muted = LiltText.body.copyWith(color: LiltColors.inkMuted);
    final a = item.action;
    return Container(
      decoration: ShapeDecoration(
        color: LiltColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LiltRadius.card),
          side: const BorderSide(color: LiltColors.line),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Semantics(
              button: true,
              label: '${a.title}. ${metaLine(a)}. ${item.reason}',
              excludeSemantics: true,
              onTap: onOpen,
              child: InkWell(
                borderRadius: BorderRadius.circular(LiltRadius.card),
                onTap: onOpen,
                child: Padding(
                  padding: const EdgeInsets.all(LiltSpacing.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ActivityTile(item: item),
                      const SizedBox(width: LiltSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.isNew) ...[const NewPill(), const SizedBox(height: LiltSpacing.xs)],
                            Text(a.title, style: LiltText.body.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: LiltSpacing.xs),
                            Text(metaLine(a), style: muted),
                            const SizedBox(height: LiltSpacing.xs),
                            Text(item.reason, style: LiltText.body),
                            if (onPlan != null) ...[
                              const SizedBox(height: LiltSpacing.xs),
                              LiltButton(label: 'Plan', kind: LiltButtonKind.text, flush: true, onPressed: onPlan),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: LiltSpacing.xs, top: LiltSpacing.xs),
            child: IconButton(
              onPressed: onToggleSaved,
              tooltip: item.saved ? 'Remove ${a.title} from saved' : 'Save ${a.title}',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(item.saved ? Icons.bookmark : Icons.bookmark_border, color: LiltColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

