import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import 'today_logic.dart';

/// The time chip's list (frame 2.3: "20 min"). Picking one closes the sheet and applies to today only.
Future<void> showTimeSheet(BuildContext context, {required int current, required ValueChanged<int> onPick}) {
  return showLiltSheet<void>(
    context,
    title: 'How much time?',
    bodyBuilder: (sheet) => Column(
      children: [
        for (final minutes in TodayChips.timeChoices)
          LiltListRow(
            title: '$minutes min',
            chevron: false,
            selected: minutes == current,
            onTap: () {
              Navigator.of(sheet).pop();
              onPick(minutes);
            },
          ),
      ],
    ),
  );
}

/// The energy chip's list (frame 2.3: "Medium energy").
Future<void> showEnergySheet(BuildContext context, {required Energy current, required ValueChanged<Energy> onPick}) {
  return showLiltSheet<void>(
    context,
    title: 'How much energy?',
    bodyBuilder: (sheet) => Column(
      children: [
        for (final energy in Energy.values)
          LiltListRow(
            title: '${energyLabel(energy)} energy',
            chevron: false,
            selected: energy == current,
            onTap: () {
              Navigator.of(sheet).pop();
              onPick(energy);
            },
          ),
      ],
    ),
  );
}

String energyLabel(Energy energy) => switch (energy) {
      Energy.low => 'Low',
      Energy.medium => 'Medium',
      Energy.high => 'High',
    };

/// S-103 "Not today?" (frame 3.3): the paths that are built so far, then the pause. "Move it to later" and
/// "My plan fell through" are not here until their sheets exist (no dead rows). Pause is reachable in two taps
/// from Today (BR-006), is never counted or shown as a miss, and "1 week" is preselected.
Future<void> showNotTodaySheet(
  BuildContext context, {
  required bool lighterAvailable,
  required VoidCallback onLighter,
  required void Function(int days) onPause,
}) {
  return showLiltSheet<void>(
    context,
    title: 'Not today?',
    // With no path above the pause, "What would help?" would point at a single choice, so it is left out.
    subtitle: lighterAvailable ? 'That’s okay. What would help?' : 'That’s okay.',
    bodyBuilder: (sheet) => _NotTodayBody(
      lighterAvailable: lighterAvailable,
      onLighter: () {
        Navigator.of(sheet).pop();
        onLighter();
      },
      onPause: (days) {
        Navigator.of(sheet).pop();
        onPause(days);
      },
    ),
  );
}

class _NotTodayBody extends StatefulWidget {
  const _NotTodayBody({required this.lighterAvailable, required this.onLighter, required this.onPause});

  final bool lighterAvailable;
  final VoidCallback onLighter;
  final void Function(int days) onPause;

  @override
  State<_NotTodayBody> createState() => _NotTodayBodyState();
}

class _NotTodayBodyState extends State<_NotTodayBody> {
  int _days = 7;

  static String _label(int days) => switch (days) {
        3 => '3 days',
        7 => '1 week',
        _ => '2 weeks',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.lighterAvailable)
          LiltListRow(
            title: 'Something lighter',
            subtitle: 'A shorter, easier option',
            onTap: widget.onLighter,
          ),
        if (widget.lighterAvailable) const SizedBox(height: LiltSpacing.xl),
        Semantics(
          header: true,
          child: Text(
            widget.lighterAvailable ? 'Or pause for a while' : 'Pause for a while',
            style: LiltText.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: LiltSpacing.xs),
        Text('Reminders stop. Your progress stays.', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
        const SizedBox(height: LiltSpacing.md),
        LiltSegmented<int>(
          segments: const [
            LiltSegment(value: 3, label: '3 days'),
            LiltSegment(value: 7, label: '1 week'),
            LiltSegment(value: 14, label: '2 weeks'),
          ],
          value: _days,
          onChanged: (d) => setState(() => _days = d),
        ),
        const SizedBox(height: LiltSpacing.md),
        LiltButton(
          label: 'Pause for ${_label(_days)}',
          kind: LiltButtonKind.secondary,
          onPressed: () => widget.onPause(_days),
        ),
      ],
    );
  }
}

/// S-107 "Why this suggestion?" (frame 3.2): every reason that applies, from the rules in EQ-004 (BR-004), and
/// where the ideas come from. Nothing here is a claim the app cannot back up with something the person did or said.
Future<void> showWhySheet(BuildContext context, {required List<String> reasons}) {
  return showLiltSheet<void>(
    context,
    title: 'Why this suggestion?',
    bodyBuilder: (sheet) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final reason in reasons)
          Padding(
            padding: const EdgeInsets.only(bottom: LiltSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(child: Text('•', style: LiltText.body)),
                const SizedBox(width: LiltSpacing.md),
                Expanded(child: Text(reason, style: LiltText.body)),
              ],
            ),
          ),
        Text(
          'Ideas come from a reviewed library of activities, ranked by what you’ve told us.',
          style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: LiltSpacing.lg),
        LiltButton(label: 'Got it', onPressed: () => Navigator.of(sheet).pop()),
      ],
    ),
  );
}

/// S-102 "Adjust this" (frame 3.3): how long, and when. "Save changes" plans it as chosen, which is the person's
/// own tap (BR-005); closing the sheet plans nothing. Returns what was chosen, or null when the sheet was closed.
/// Saving without changing anything plans the suggestion as it was, not as an edit.
Future<OfferEdit?> showEditSheet(
  BuildContext context, {
  required String title,
  required int ideaMinutes,
  required SuggestedSlot? suggested,
  required Set<String> freeTimes,
  required DateTime now,
}) {
  return showLiltSheet<OfferEdit>(
    context,
    title: 'Adjust this',
    subtitle: title,
    bodyBuilder: (sheet) => _EditBody(
      ideaMinutes: ideaMinutes,
      suggested: suggested,
      freeTimes: freeTimes,
      now: now,
      onSave: (edit) => Navigator.of(sheet).pop(edit),
    ),
  );
}

class _EditBody extends StatefulWidget {
  const _EditBody({
    required this.ideaMinutes,
    required this.suggested,
    required this.freeTimes,
    required this.now,
    required this.onSave,
  });

  final int ideaMinutes;
  final SuggestedSlot? suggested;
  final Set<String> freeTimes;
  final DateTime now;
  final ValueChanged<OfferEdit> onSave;

  @override
  State<_EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<_EditBody> {
  late int _minutes = widget.ideaMinutes;
  late final List<WhenChoice> _choices =
      whenChoices(suggested: widget.suggested, freeTimes: widget.freeTimes, now: widget.now);
  late WhenChoice _when = _choices.first;
  WhenChoice? _picked;

  Future<void> _pick() async {
    final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 12, minute: 30));
    if (t == null || !mounted) return;
    setState(() {
      _picked = pickedWhen(t.hour * 60 + t.minute, widget.now);
      _when = _picked!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final whens = [..._choices, if (_picked != null && !_choices.contains(_picked)) _picked!];
    final unchanged = _minutes == widget.ideaMinutes && _when == _choices.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text('How long', style: LiltText.body.copyWith(fontWeight: FontWeight.w600))),
        const SizedBox(height: LiltSpacing.sm),
        LiltChipWrap(
          children: [
            for (final m in durationChoices(widget.ideaMinutes))
              LiltChip(label: '$m min', selected: m == _minutes, onTap: () => setState(() => _minutes = m)),
          ],
        ),
        const SizedBox(height: LiltSpacing.xl),
        Semantics(header: true, child: Text('When', style: LiltText.body.copyWith(fontWeight: FontWeight.w600))),
        const SizedBox(height: LiltSpacing.sm),
        LiltChipWrap(
          children: [
            for (final w in whens) LiltChip(label: w.label, selected: w == _when, onTap: () => setState(() => _when = w)),
          ],
        ),
        LiltButton(label: 'Pick a time ›', kind: LiltButtonKind.text, flush: true, onPressed: _pick),
        const SizedBox(height: LiltSpacing.md),
        LiltButton(
          label: 'Save changes',
          onPressed: () => widget.onSave(
            OfferEdit(durationMin: _minutes, day: _when.day, time: _when.time, changed: !unchanged),
          ),
        ),
      ],
    );
  }
}
