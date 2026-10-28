import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/enums.dart';
import '../../ui/ui.dart';
import '../../domain/red_flags.dart';
import '../support/support_providers.dart';
import 'setup_copy.dart';

/// What the search returns: a library activity, or `other` with the name the person typed.
class ActivityPick {
  const ActivityPick(this.kind, {this.customName});

  final ActivityKind kind;
  final String? customName;
}

/// The longest activity name a person can type.
const maxCustomNameLength = 40;

/// Whether [entry] matches what was typed: the name, the one-line description or a keyword contains it.
bool matchesQuery(ActivityEntry entry, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return entry.label.toLowerCase().contains(q) ||
      entry.blurb.toLowerCase().contains(q) ||
      entry.keywords.any((k) => k.contains(q));
}

/// Frame 1.6 and 9.1: search the activities, with "Not listed? Add it yourself" as the only free text in setup.
/// What is typed is checked for red flags before it is used (BR-003, EQ-008). A hit shows the support message
/// (S-090), the text is cleared and nothing is returned or stored.
class ActivitySearchScreen extends ConsumerStatefulWidget {
  const ActivitySearchScreen({super.key});

  @override
  ConsumerState<ActivitySearchScreen> createState() => _ActivitySearchScreenState();
}

class _ActivitySearchScreenState extends ConsumerState<ActivitySearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _addYourself() async {
    final typed = _controller.text.trim();
    if (typed.isEmpty) return;
    final RedFlagDetector detector;
    try {
      detector = await ref.read(redFlagDetectorProvider.future);
    } on Object {
      // The check could not run, so the text is not used (BR-003 fails closed). Say so instead of doing nothing.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That did not work. Please try again.')),
        );
      }
      return;
    }
    if (!mounted) return;
    if (detector.check(typed) != null) {
      // BR-003: no suggestion, nothing stored. Clear the field and show the support message.
      _controller.clear();
      await context.push('/support');
      return;
    }
    Navigator.of(context).pop(ActivityPick(ActivityKind.other, customName: typed));
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text;
    final matches = [for (final e in activityCatalogue) if (matchesQuery(e, query)) e];
    final typed = query.trim();
    final exact = activityCatalogue.any((e) => e.label.toLowerCase() == typed.toLowerCase());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.lg),
          child: ListView(
            children: [
              const SizedBox(height: LiltSpacing.sm),
              Container(
                constraints: const BoxConstraints(minHeight: 56),
                decoration: ShapeDecoration(
                  color: LiltColors.surface,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: _focus.hasFocus ? LiltColors.primary : LiltColors.field,
                      width: _focus.hasFocus ? 2 : 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Back',
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        autofocus: true,
                        maxLength: maxCustomNameLength,
                        // This field can hold sensitive words: no suggestions and no keyboard learning (BR-015).
                        autocorrect: false,
                        enableSuggestions: false,
                        enableIMEPersonalizedLearning: false,
                        textInputAction: TextInputAction.search,
                        style: LiltText.body,
                        decoration: const InputDecoration(
                          hintText: 'Search activities',
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    if (query.isNotEmpty)
                      IconButton(
                        onPressed: _controller.clear,
                        tooltip: 'Clear',
                        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: LiltSpacing.lg),
              if (matches.isEmpty && typed.isNotEmpty) ...[
                // Frame 9.14: say what happened, then the way forward.
                Semantics(
                  liveRegion: true,
                  child: Text(
                    'No activities match “${_shortened(typed)}”',
                    style: LiltText.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: LiltSpacing.xs),
                Text(
                  'Check the spelling, or add it yourself.',
                  style: LiltText.body.copyWith(color: LiltColors.inkMuted),
                ),
                LiltButton(
                  label: 'Add “${_shortened(typed)}” yourself',
                  kind: LiltButtonKind.text,
                  flush: true,
                  onPressed: _addYourself,
                ),
              ] else
                Text(
                  query.isEmpty ? 'Activities' : 'Matches',
                  style: LiltText.label.copyWith(color: LiltColors.inkMuted),
                ),
              const SizedBox(height: LiltSpacing.sm),
              for (final e in matches)
                LiltListRow(
                  title: e.label,
                  subtitle: e.blurb,
                  onTap: () => Navigator.of(context).pop(ActivityPick(e.kind)),
                ),
              if (typed.isNotEmpty && !exact && matches.isNotEmpty) ...[
                const SizedBox(height: LiltSpacing.sm),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Not listed?', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
                    LiltButton(
                      label: 'Add “${_shortened(typed)}” yourself',
                      kind: LiltButtonKind.text,
                      flush: true,
                      onPressed: _addYourself,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A long typed name is cut for the heading and the button, so they stay on a couple of lines.
String _shortened(String text) => text.length <= 24 ? text : '${text.substring(0, 23).trimRight()}…';
