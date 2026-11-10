import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import 'discover_controller.dart';
import 'discover_logic.dart';
import 'discover_screen.dart';

/// "45 min · with others · free · outdoors · beginner-friendly" (frame 3.10), from what the library records.
String detailMeta(DiscoverItem item) {
  final a = item.action;
  return [
    '${a.durationMin} min',
    a.tags.contains('with_company') ? 'with others' : 'on your own',
    if (a.tags.contains('free')) 'free',
    if (a.tags.contains('indoors')) 'indoors',
    if (a.tags.contains('outdoors')) 'outdoors',
    if (a.isStarter) 'beginner-friendly',
  ].join(' · ');
}

/// S-013 Activity detail (frame 3.10): what it is, why it is suggested (BR-004), and three things to do with it:
/// plan it, follow the activity, or keep it saved. Nothing is planned until "Plan it" is tapped (BR-005).
class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({super.key, required this.actionId});

  final String actionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(activityDetailProvider(actionId));
    return Scaffold(
      body: SafeArea(
        child: async.when(
          data: (detail) => detail == null ? const _Missing() : _Body(detail: detail),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const _Missing(),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({this.saved, this.onToggleSaved});

  final bool? saved;
  final VoidCallback? onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LiltSpacing.sm, LiltSpacing.sm, LiltSpacing.sm, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Back',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: LiltSpacing.sm),
          Expanded(
            child: Semantics(
              header: true,
              child: Text('Activity', style: LiltText.body.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          ),
          if (saved != null)
            IconButton(
              onPressed: onToggleSaved,
              tooltip: saved! ? 'Remove from saved' : 'Save',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(saved! ? Icons.bookmark : Icons.bookmark_border, color: LiltColors.primary),
            ),
        ],
      ),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AppBar(),
        Padding(
          padding: const EdgeInsets.all(LiltSpacing.lg),
          child: Text(
            'This idea isn’t available any more.',
            style: LiltText.body.copyWith(color: LiltColors.inkMuted),
          ),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail});

  final ActivityDetail detail;

  Future<void> _followSafely(WidgetRef ref, ActivityKind activity, Familiarity f) async {
    try {
      await ref.read(discoverControllerProvider.notifier).follow(activity, f);
    } on StateError {
      // Consent was taken away meanwhile (delete-all): the router is already on its way to the consent screen.
    }
  }

  /// "Where are you with it?" (frame 3.9): the answer sets how the activity is followed.
  Future<void> _follow(BuildContext context, WidgetRef ref) async {
    final activity = detail.item.action.activity;
    await showLiltSheet<void>(
      context,
      title: 'Where are you with it?',
      bodyBuilder: (sheet) => Column(
        children: [
          for (final o in const [
            (Familiarity.alreadyPlay, 'I already do this'),
            (Familiarity.usedToPlay, 'I used to do this'),
            (Familiarity.newToMe, 'It’s new to me'),
          ])
            LiltListRow(
              title: o.$2,
              chevron: false,
              onTap: () {
                Navigator.of(sheet).pop();
                _followSafely(ref, activity, o.$1);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = detail.item;
    final a = item.action;
    final muted = LiltText.body.copyWith(color: LiltColors.inkMuted);
    final controller = ref.read(discoverControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AppBar(saved: item.saved, onToggleSaved: () => controller.toggleSaved(a.id)),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.lg, LiltSpacing.lg, LiltSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivityTile(item: item, size: 104),
                const SizedBox(height: LiltSpacing.md),
                if (item.isNew) ...[const NewPill(), const SizedBox(height: LiltSpacing.md)],
                Semantics(header: true, child: Text(a.title, style: LiltText.display)),
                const SizedBox(height: LiltSpacing.md),
                if (detail.description.isNotEmpty) Text(detail.description, style: muted.copyWith(fontSize: 17)),
                const SizedBox(height: LiltSpacing.lg),
                // "Why we suggest it": a left rule, then the reason (BR-004).
                Container(
                  padding: const EdgeInsets.only(left: LiltSpacing.md),
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: LiltColors.primary, width: 3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Why we suggest it', style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)),
                      const SizedBox(height: LiltSpacing.xs),
                      Text(item.reason, style: LiltText.body.copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: LiltSpacing.lg),
                Text(detailMeta(item), style: muted),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LiltButton(label: 'Plan it', onPressed: () => planFromDiscover(context, ref, a.id)),
              const SizedBox(height: LiltSpacing.sm),
              if (a.activity == ActivityKind.other)
                const SizedBox.shrink() // a typed activity is followed from setup and Settings, not from a library idea
              else if (detail.following)
                LiltButton(
                  label: 'Stop following this activity',
                  kind: LiltButtonKind.secondary,
                  onPressed: () => controller.unfollow(a.activity),
                )
              else
                LiltButton(
                  label: 'Follow this activity',
                  kind: LiltButtonKind.secondary,
                  onPressed: () => _follow(context, ref),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
