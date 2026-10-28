import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import 'reflection_copy.dart';

/// What the person answered in the sheet.
class ReflectionAnswer {
  const ReflectionAnswer({required this.status, this.enjoyment, this.barrier});

  final ReflectionStatus status;
  final int? enjoyment;
  final Barrier? barrier;
}

/// S-101 "How did it go?" (frame 3.11): Done, Partly or Didn't get to it, then the optional follow-ups for that
/// answer, then Save. Two taps for the common case: pick one, Save (F-003: at most 3). Closing the sheet leaves the
/// reflection `unknown` (BR-009). [initial] fills the sheet when the person changes an answer.
Future<ReflectionAnswer?> showReflectionSheet(
  BuildContext context, {
  required String activityTitle,
  ReflectionAnswer? initial,
  ReflectionStatus? preselect,
  Set<ReflectionStatus>? allowed,
}) {
  return showModalBottomSheet<ReflectionAnswer>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    barrierColor: LiltColors.scrim,
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (_) => _ReflectionSheet(
      activityTitle: activityTitle,
      initial: initial,
      preselect: preselect,
      allowed: allowed,
    ),
  );
}

class _ReflectionSheet extends StatefulWidget {
  const _ReflectionSheet({required this.activityTitle, this.initial, this.preselect, this.allowed});

  final String activityTitle;
  final ReflectionAnswer? initial;
  final ReflectionStatus? preselect;

  /// The answers offered. A person who already answered can keep or raise it, not lower it (BR-007, EQ-011).
  final Set<ReflectionStatus>? allowed;

  @override
  State<_ReflectionSheet> createState() => _ReflectionSheetState();
}

class _ReflectionSheetState extends State<_ReflectionSheet> {
  ReflectionStatus? _status;
  Barrier? _barrier;
  int? _enjoyment;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _status = widget.initial?.status ?? widget.preselect;
    _barrier = widget.initial?.barrier;
    _enjoyment = widget.initial?.enjoyment;
  }

  bool get _asksBarrier => _status == ReflectionStatus.partly || _status == ReflectionStatus.skipped;
  bool get _asksEnjoyment => _status == ReflectionStatus.completed || _status == ReflectionStatus.partly;

  void _pick(ReflectionStatus status) {
    setState(() {
      _status = status;
      // A follow-up that is not asked for this answer is dropped, so a changed answer never keeps a stale one.
      if (!_asksBarrier) _barrier = null;
      if (!_asksEnjoyment) _enjoyment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    return LiltSheet(
      title: 'How did it go?',
      subtitle: widget.activityTitle,
      bodyBuilder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final choice in reflectionChoices.where((c) => widget.allowed?.contains(c.status) ?? true)) ...[
            LiltChoiceCard(
              title: choice.label,
              kind: LiltChoiceKind.radio,
              selected: status == choice.status,
              onTap: () => _pick(choice.status),
            ),
            const SizedBox(height: LiltSpacing.sm),
          ],
          if (_asksBarrier) ...[
            const SizedBox(height: LiltSpacing.lg),
            _Heading('What got in the way? (optional)'),
            const SizedBox(height: LiltSpacing.md),
            // One answer, so no tick (DESIGN.md Selection); "Prefer not to say" is one of the options.
            LiltChipWrap(
              children: [
                for (final (barrier, label) in barrierChoices)
                  LiltChip(
                    label: label,
                    selected: _barrier == barrier,
                    onTap: () => setState(() => _barrier = _barrier == barrier ? null : barrier),
                  ),
              ],
            ),
          ],
          if (_asksEnjoyment) ...[
            const SizedBox(height: LiltSpacing.lg),
            _Heading('How was it? (optional)'),
            const SizedBox(height: LiltSpacing.md),
            _Enjoyment(value: _enjoyment, onChanged: (v) => setState(() => _enjoyment = v)),
          ],
        ],
      ),
      footer: LiltButton(
        label: 'Save',
        onPressed: status == null || _saved
            ? null
            : () {
                // One tap only: a second quick tap must not close the screen under the sheet.
                setState(() => _saved = true);
                Navigator.of(context).pop(ReflectionAnswer(status: status, enjoyment: _enjoyment, barrier: _barrier));
              },
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Semantics(header: true, child: Text(text, style: LiltText.body.copyWith(fontWeight: FontWeight.w600)));
}

/// Not for me, Okay, Enjoyed it: a segmented control, and a second tap on the chosen one clears it (optional).
class _Enjoyment extends StatelessWidget {
  const _Enjoyment({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    // A segmented control always has one selected segment, so "nothing chosen" is shown by selecting none of them.
    return LiltSegmented<int?>(
      segments: [for (final (v, label) in enjoymentChoices) LiltSegment<int?>(value: v, label: label)],
      value: value,
      onChanged: (v) => onChanged(v == value ? null : v),
    );
  }
}
