import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import '../starting_point/setup_copy.dart';
import 'rhythm_grid.dart';
import 'today_logic.dart';
import 'today_repository.dart';

/// "Running" in a small tinted pill, with how the person came to it ("Picking up again") beside it (frame 2.3).
class ActivityTag extends StatelessWidget {
  const ActivityTag({super.key, required this.activity, this.relation, this.trailing});

  final ActivityKind activity;
  final String? relation;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.sm, vertical: LiltSpacing.xs),
          decoration: ShapeDecoration(color: LiltColors.selected, shape: const StadiumBorder()),
          child: Text(
            activityLabel(activity, null),
            style: LiltText.label.copyWith(fontSize: 12, color: LiltColors.primary),
          ),
        ),
        if (relation != null) ...[
          const SizedBox(width: LiltSpacing.sm),
          Flexible(
            child: Text(relation!, style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)),
          ),
        ],
        if (trailing != null) ...[
          const Spacer(),
          Text(trailing!, style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)),
        ],
      ],
    );
  }
}

/// How the activity was chosen, for the label on its card (docs/data-model.md `path`).
String relationLabel(ActivityKind kind, Map<ActivityKind, SetupPath> paths) => switch (paths[kind]) {
      SetupPath.pickUpAgain => 'Picking up again',
      SetupPath.keepGoing => 'Keeping it going',
      SetupPath.addNew || SetupPath.startFresh => 'New to try',
      null => 'New for you',
    };

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(LiltSpacing.lg),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LiltRadius.card),
            side: const BorderSide(color: LiltColors.line),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// What every option says: the title, when it is suggested, and why (BR-004).
class _OptionText extends StatelessWidget {
  const _OptionText({required this.title, required this.suggested, required this.reason, this.big = false});

  final String title;
  final String? suggested;
  final String reason;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: LiltText.body.copyWith(fontWeight: FontWeight.w600, fontSize: big ? 20 : 16, height: 1.3)),
        ),
        if (suggested != null) ...[
          const SizedBox(height: LiltSpacing.xs),
          Text(suggested!, style: LiltText.label.copyWith(fontWeight: FontWeight.w400)),
        ],
        const SizedBox(height: LiltSpacing.md),
        Text(reason, style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)),
      ],
    );
  }
}

/// The one expanded card with the only filled button on Today (DESIGN.md: one primary per screen).
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.offer,
    required this.relation,
    required this.today,
    required this.position,
    required this.total,
    required this.canSwap,
    required this.onAccept,
    required this.onSwap,
    required this.onNotToday,
  });

  final StoredOffer offer;
  final String relation;
  final String today;
  final int position;
  final int total;
  final bool canSwap;
  final VoidCallback onAccept;
  final VoidCallback onSwap;
  final VoidCallback onNotToday;

  @override
  Widget build(BuildContext context) {
    final slot = _slotLabel(offer, today);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityTag(activity: offer.action.activity, relation: relation),
          const SizedBox(height: LiltSpacing.lg),
          _OptionText(title: offer.action.title, suggested: slot, reason: offer.reason, big: true),
          const SizedBox(height: LiltSpacing.lg),
          LiltButton(label: 'I’ll try this', onPressed: onAccept),
          const SizedBox(height: LiltSpacing.xs),
          LiltButtonRow(
            children: [
              if (canSwap) LiltButton(label: 'Something else', kind: LiltButtonKind.text, onPressed: onSwap),
              LiltButton(label: 'Not today', kind: LiltButtonKind.text, onPressed: onNotToday),
            ],
          ),
          // "1 of 3" only when there is more than one option to step through.
          if (total >= 2)
            Padding(
              padding: const EdgeInsets.only(top: LiltSpacing.xs),
              child: Center(
                child: Text(
                  '$position of $total',
                  style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A compact card for another followed activity (frame 2.3): outlined "I'll try this" and a text "Not today".
class CompactCard extends StatelessWidget {
  const CompactCard({
    super.key,
    required this.option,
    required this.relation,
    required this.today,
    required this.onAccept,
    required this.onNotToday,
  });

  final TodayOption option;
  final String relation;
  final String today;
  final VoidCallback onAccept;
  final VoidCallback onNotToday;

  @override
  Widget build(BuildContext context) {
    final action = option.ranked.action;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityTag(activity: action.activity, relation: relation),
          const SizedBox(height: LiltSpacing.md),
          _OptionText(
            title: action.title,
            suggested: option.slot == null ? null : suggestedLabel(option.slot!, today),
            reason: option.ranked.reason.text,
          ),
          const SizedBox(height: LiltSpacing.md),
          LiltButtonRow(
            children: [
              LiltButton(label: 'I’ll try this', kind: LiltButtonKind.secondary, onPressed: onAccept),
              LiltButton(label: 'Not today', kind: LiltButtonKind.text, onPressed: onNotToday),
            ],
          ),
        ],
      ),
    );
  }
}

/// An option the person accepted: it is in today's plan (frame 2.5). The planned card has no button yet; telling
/// Lilt how it went comes with the Reflection sheet.
class PlannedCard extends StatelessWidget {
  const PlannedCard({super.key, required this.offer, required this.today});

  final StoredOffer offer;
  final String today;

  @override
  Widget build(BuildContext context) {
    final o = offer.offer;
    final when = [
      o.suggestedDay == today ? 'Today' : shortDate(o.suggestedDay),
      if (o.suggestedTime != null) o.suggestedTime!,
    ].join(' ');
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityTag(activity: offer.action.activity, trailing: 'Planned'),
          const SizedBox(height: LiltSpacing.md),
          Semantics(
            header: true,
            child: Text(offer.action.title, style: LiltText.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
          ),
          const SizedBox(height: LiltSpacing.xs),
          Text('$when · ${offer.action.durationMin} min', style: LiltText.label.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

String? _slotLabel(StoredOffer offer, String today) {
  final time = offer.offer.suggestedTime;
  if (time == null) return null;
  final slot = SuggestedSlot(
    day: offer.offer.suggestedDay,
    minute: int.parse(time.substring(0, 2)) * 60 + int.parse(time.substring(3)),
    code: _codeFor(time),
  );
  return suggestedLabel(slot, today);
}

/// The slot a stored clock time belongs to (the clock times are fixed, docs/data-model.md).
String _codeFor(String clock) => switch (clock) {
      '07:00' => 'early_morning',
      '12:30' => 'lunch',
      '18:30' => 'after_work',
      _ => 'weekends',
    };
