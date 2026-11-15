import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import '../starting_point/setup_copy.dart';
import 'rhythm_grid.dart';
import 'reflection_copy.dart';
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
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.sm, vertical: LiltSpacing.xs),
      decoration: ShapeDecoration(color: LiltColors.selected, shape: const StadiumBorder()),
      child: Text(
        activityLabel(activity, null),
        style: LiltText.label.copyWith(fontSize: 12, color: LiltColors.primary),
      ),
    );
    final muted = LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400);
    if (MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
      // Large text: the pill, then what it says about the person, then the status, one under the other.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.centerLeft, child: pill),
          if (relation != null) ...[const SizedBox(height: LiltSpacing.xs), Text(relation!, style: muted)],
          if (trailing != null) ...[const SizedBox(height: LiltSpacing.xs), Text(trailing!, style: muted)],
        ],
      );
    }
    return Row(
      children: [
        pill,
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

/// "Why this?" and "Edit", two quiet links under the reason (frame 2.3). Neither plans anything.
class _OptionLinks extends StatelessWidget {
  const _OptionLinks({required this.title, required this.onWhy, required this.onEdit});

  final String title;
  final VoidCallback? onWhy;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    if (onWhy == null && onEdit == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: LiltSpacing.xs),
      child: Wrap(
        spacing: LiltSpacing.lg,
        children: [
          if (onWhy != null)
            LiltButton(
              label: 'Why this?',
              kind: LiltButtonKind.text,
              flush: true,
              semanticLabel: 'Why this suggestion? $title',
              onPressed: onWhy,
            ),
          if (onEdit != null)
            LiltButton(
              label: 'Edit',
              kind: LiltButtonKind.text,
              flush: true,
              semanticLabel: 'Edit $title',
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}

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
    this.onWhy,
    this.onEdit,
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
  final VoidCallback? onWhy;
  final VoidCallback? onEdit;

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
          _OptionLinks(title: offer.action.title, onWhy: onWhy, onEdit: onEdit),
          const SizedBox(height: LiltSpacing.lg),
          LiltButton(label: 'I’ll try this', onPressed: onAccept),
          const SizedBox(height: LiltSpacing.sm),
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
    this.onWhy,
    this.onEdit,
  });

  final TodayOption option;
  final String relation;
  final String today;
  final VoidCallback onAccept;
  final VoidCallback onNotToday;
  final VoidCallback? onWhy;
  final VoidCallback? onEdit;

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
          _OptionLinks(title: action.title, onWhy: onWhy, onEdit: onEdit),
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

/// "What changes next" (frame 2.6): one sentence under an answered card, with a left rule and not a grey box
/// (docs/DESIGN.md). It stays on the page, so it can be read slowly or read aloud, and it is worked out from the
/// stored answer, so it is still there after a restart. A live region, so it is announced once when it appears.
class WhatChangesNext extends StatelessWidget {
  const WhatChangesNext({super.key, required this.planned});

  final PlannedItem planned;

  @override
  Widget build(BuildContext context) {
    final r = planned.reflection;
    final sentence = whatChangesNext(status: r.status, enjoyment: r.enjoyment, barrier: r.barrier);
    return Semantics(
      liveRegion: true,
      container: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: LiltColors.primary),
            const SizedBox(width: LiltSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What changes next', style: LiltText.label.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: LiltSpacing.xs),
                  Text(sentence, style: LiltText.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Something in the plan (frame 2.5, 2.6). Planned and not yet answered, today: "How did it go?" is the one
/// primary. Answered: the answer shows, with "Change my answer". From an earlier day and still open: a quieter
/// "How did it go?". Later: no button. Nothing here says overdue or missed (BR-007, BR-009).
class PlannedCard extends StatelessWidget {
  const PlannedCard({
    super.key,
    required this.planned,
    required this.today,
    this.onReflect,
    this.onNotToday,
  });

  final PlannedItem planned;
  final String today;

  /// Opens the Reflection sheet. Null when it is not time to reflect yet.
  final VoidCallback? onReflect;

  /// Opens the Not today sheet, so the pause is reachable from the planned state (BR-006).
  final VoidCallback? onNotToday;

  @override
  Widget build(BuildContext context) {
    final item = planned.item;
    final status = planned.reflection.status;
    final isToday = item.plannedDay == today;
    final isEarlier = item.plannedDay.compareTo(today) < 0;
    final when = [
      isToday ? 'Today' : weekdayDate(item.plannedDay),
      if (item.plannedTime != null) item.plannedTime!,
    ].join(' ');
    final minutes = item.durationMin == null ? '' : ' · ${item.durationMin} min';

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityTag(activity: item.activity, trailing: statusLabel(status)),
          const SizedBox(height: LiltSpacing.md),
          Semantics(
            header: true,
            child: Text(item.title, style: LiltText.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
          ),
          const SizedBox(height: LiltSpacing.xs),
          Text(
            planned.isOpen ? '$when$minutes' : affirmation(status),
            style: LiltText.label.copyWith(fontWeight: FontWeight.w400),
          ),
          if (planned.isOpen && onReflect != null && (isToday || isEarlier)) ...[
            const SizedBox(height: LiltSpacing.lg),
            LiltButton(
              label: 'How did it go?',
              kind: isToday ? LiltButtonKind.primary : LiltButtonKind.secondary,
              onPressed: onReflect,
            ),
          ],
          if (planned.isOpen && isToday && onNotToday != null)
            LiltButton(label: 'Not today', kind: LiltButtonKind.text, flush: true, onPressed: onNotToday),
          if (!planned.isOpen && onReflect != null)
            LiltButton(label: 'Change my answer', kind: LiltButtonKind.text, flush: true, onPressed: onReflect),
        ],
      ),
    );
  }
}

String? _slotLabel(StoredOffer offer, String today) {
  final slot = storedSlot(offer);
  return slot == null ? null : suggestedLabel(slot, today);
}

/// The slot a stored offer was suggested for, or null when the person gave no free time.
SuggestedSlot? storedSlot(StoredOffer offer) {
  final time = offer.offer.suggestedTime;
  if (time == null) return null;
  return SuggestedSlot(
    day: offer.offer.suggestedDay,
    minute: int.parse(time.substring(0, 2)) * 60 + int.parse(time.substring(3)),
    code: _codeFor(time),
  );
}

/// The slot a stored clock time belongs to (the clock times are fixed, docs/data-model.md).
String _codeFor(String clock) => switch (clock) {
      '07:00' => 'early_morning',
      '12:30' => 'lunch',
      '18:30' => 'after_work',
      _ => 'weekends',
    };
