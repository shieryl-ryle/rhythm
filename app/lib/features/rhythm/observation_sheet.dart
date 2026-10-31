import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../../ui/ui.dart';
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

class _ObservationSheet extends StatefulWidget {
  const _ObservationSheet({required this.observation});

  final Observation observation;

  @override
  State<_ObservationSheet> createState() => _ObservationSheetState();
}

class _ObservationSheetState extends State<_ObservationSheet> {
  late final TextEditingController _text = TextEditingController(text: widget.observation.text_);
  bool _reword = false;
  bool _done = false;

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

  @override
  Widget build(BuildContext context) {
    return LiltSheet(
      title: widget.observation.text_,
      subtitle: 'Does this still fit you?',
      bodyBuilder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              onChanged: (_) => setState(() {}),
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
      footer: LiltButton(
        label: 'Save',
        onPressed: !_canSave || _done
            ? null
            : () => _finish(_reword ? ObservationReworded(_text.text.trim()) : const ObservationKeep()),
      ),
    );
  }
}
