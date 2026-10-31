import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/red_flags.dart';
import '../../ui/ui.dart';
import '../support/support_providers.dart';
import 'rhythm_repository.dart';

/// What the person chose in the observation sheet.
sealed class ObservationChoice {
  const ObservationChoice();
}

/// It still fits as it is.
class ObservationKeep extends ObservationChoice {
  const ObservationKeep();
}

/// They said it in their own words.
class ObservationReworded extends ObservationChoice {
  const ObservationReworded(this.text);

  final String text;
}

/// What they typed matched the red-flag list (EQ-008): nothing is stored and the support message is shown (BR-003).
class ObservationFlagged extends ObservationChoice {
  const ObservationFlagged();
}

/// They do not want it any more.
class ObservationRemoved extends ObservationChoice {
  const ObservationRemoved();
}

/// S-105 (frame 6.3): the observation as the title, "Does this still fit you?", two choices, Save, and "Remove it".
/// The frame's refinement options ("Weekday evenings only") need data the app does not have, so the choices here
/// are the ones it can act on: keep it, or say it differently. Closing the sheet changes nothing (BR-010).
Future<ObservationChoice?> showObservationSheet(BuildContext context, Observation observation) {
  return showModalBottomSheet<ObservationChoice>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    barrierColor: LiltColors.scrim,
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (_) => _ObservationSheet(observation: observation),
  );
}

class _ObservationSheet extends ConsumerStatefulWidget {
  const _ObservationSheet({required this.observation});

  final Observation observation;

  @override
  ConsumerState<_ObservationSheet> createState() => _ObservationSheetState();
}

class _ObservationSheetState extends ConsumerState<_ObservationSheet> {
  late final TextEditingController _text = TextEditingController(text: widget.observation.text_);
  bool _reword = false;
  bool _done = false;
  bool _checkFailed = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _canSave => !_reword || (_text.text.trim().isNotEmpty && _text.text.trim().length <= maxObservationLength);

  void _finish(ObservationChoice choice) {
    // One tap only: a second quick tap must not pop whatever is under the sheet.
    if (_done) return;
    setState(() => _done = true);
    Navigator.of(context).pop(choice);
  }

  /// Their own words go through the red-flag check before anything is kept (EQ-008, BR-003). If the check cannot
  /// run the words are not used, and the sheet says so rather than doing nothing.
  Future<void> _save() async {
    if (!_reword) return _finish(const ObservationKeep());
    final typed = _text.text.trim();
    final RedFlagDetector detector;
    try {
      detector = await ref.read(redFlagDetectorProvider.future);
    } on Object {
      if (mounted) setState(() => _checkFailed = true);
      return;
    }
    if (!mounted) return;
    _finish(detector.check(typed) != null ? const ObservationFlagged() : ObservationReworded(typed));
  }

  @override
  Widget build(BuildContext context) {
    return LiltSheet(
      // The question is the title: the sentence can be up to 140 characters and would fill the sheet in display type.
      title: 'Does this still fit?',
      bodyBuilder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('“${widget.observation.text_}”', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
          const SizedBox(height: LiltSpacing.lg),
          LiltChoiceCard(
            title: 'It still fits',
            kind: LiltChoiceKind.radio,
            selected: !_reword,
            onTap: () => setState(() => _reword = false),
          ),
          const SizedBox(height: LiltSpacing.sm),
          LiltChoiceCard(
            title: 'Say it differently',
            kind: LiltChoiceKind.radio,
            selected: _reword,
            onTap: () => setState(() => _reword = true),
          ),
          if (_reword) ...[
            const SizedBox(height: LiltSpacing.md),
            TextField(
              controller: _text,
              autofocus: true,
              maxLength: maxObservationLength,
              maxLines: 3,
              minLines: 1,
              // Their own words about their body and habits: no suggestions and no keyboard learning (BR-015).
              autocorrect: false,
              enableSuggestions: false,
              enableIMEPersonalizedLearning: false,
              textInputAction: TextInputAction.done,
              style: LiltText.body,
              onChanged: (_) => setState(() => _checkFailed = false),
              decoration: InputDecoration(
                labelText: 'In your words',
                filled: true,
                fillColor: LiltColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(LiltRadius.md),
                  borderSide: const BorderSide(color: LiltColors.field),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(LiltRadius.md),
                  borderSide: const BorderSide(color: LiltColors.primary, width: 2),
                ),
              ),
            ),
          ],
          if (_checkFailed) ...[
            const SizedBox(height: LiltSpacing.md),
            Semantics(
              liveRegion: true,
              child: const Text('That did not work. Please try again.', style: LiltText.body),
            ),
          ],
          if (_reword) ...[
            const SizedBox(height: LiltSpacing.sm),
            Text('This changes the words only.', style: LiltText.label.copyWith(color: LiltColors.inkMuted)),
          ],
          const SizedBox(height: LiltSpacing.md),
          Center(
            child: LiltButton(
              label: 'Remove it',
              kind: LiltButtonKind.text,
              onPressed: () => _finish(const ObservationRemoved()),
            ),
          ),
        ],
      ),
      footer: LiltButton(label: 'Save', onPressed: !_canSave || _done ? null : _save),
    );
  }
}
