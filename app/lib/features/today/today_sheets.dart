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
