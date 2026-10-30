import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../ui/ui.dart';
import 'demo_seed.dart';
import 'settings_providers.dart';

enum _Export { idle, working, done, failed }

/// S-008 Settings & My Data, the first version: get support, export, delete everything, and in a demo build
/// the synthetic people. Reminders, "edit my starting point" and sharing come with the screens they open.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  _Export _export = _Export.idle;
  bool _busy = false;

  Future<void> _runExport() async {
    if (_export == _Export.working) return;
    setState(() => _export = _Export.working);
    try {
      await ref.read(exportMyDataProvider)();
      if (mounted) setState(() => _export = _Export.done);
    } on Object {
      if (mounted) setState(() => _export = _Export.failed);
    }
  }

  Future<void> _confirmDelete() async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteDialog(),
    );
    if (delete != true || _busy || !mounted) return;
    setState(() => _busy = true);
    // Deleting sends the person back to the consent screen (BR-014, BR-017).
    await ref.read(deleteEverythingProvider)();
  }

  Future<void> _loadDemo(DemoPersona persona) async {
    if (_busy) return;
    setState(() => _busy = true);
    await ref.read(loadDemoProvider)(persona);
    if (!mounted) return;
    setState(() => _busy = false);
    context.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    final demo = ref.watch(demoBuildProvider);
    final demoLoaded = ref.watch(demoDataLoadedProvider).valueOrNull ?? false;

    final exportNote = switch (_export) {
      _Export.idle => 'Everything on this phone, as one file of text',
      _Export.working => 'Exporting…',
      _Export.done => 'Copied. Paste it into a note or a file to keep it.',
      _Export.failed => 'That didn’t work. Try again.',
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(LiltSpacing.xs, LiltSpacing.xs, LiltSpacing.lg, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    onPressed: () => context.canPop() ? context.pop() : context.go('/today'),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(header: true, child: const Text('Settings', style: LiltText.display)),
                    const SizedBox(height: LiltSpacing.lg),
                    if (demoLoaded) ...[
                      const DemoBanner(),
                      const SizedBox(height: LiltSpacing.lg),
                    ],
                    LiltListRow(
                      title: 'Need support?',
                      subtitle: 'Help from people, any time',
                      onTap: () => context.push('/support'),
                    ),
                    LiltListRow(
                      title: 'Export my data',
                      subtitle: exportNote,
                      chevron: false,
                      onTap: _export == _Export.working ? null : _runExport,
                    ),
                    LiltListRow(
                      title: 'Delete everything',
                      subtitle: 'Removes all data from this phone',
                      divider: false,
                      onTap: _busy ? null : _confirmDelete,
                    ),
                    if (demo) ...[
                      const SizedBox(height: LiltSpacing.section),
                      Semantics(header: true, child: Text('Demo build', style: LiltText.body.copyWith(fontWeight: FontWeight.w600))),
                      const SizedBox(height: LiltSpacing.xs),
                      Text(
                        'Loads invented people, not real data. It replaces what is on this phone.',
                        style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: LiltSpacing.sm),
                      for (final p in DemoPersona.values)
                        LiltListRow(
                          title: 'Load demo data: ${p.label}',
                          subtitle: p.story,
                          onTap: _busy ? null : () => _loadDemo(p),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The destructive dialog (docs/DESIGN.md): the safe choice is the one filled button, and the destructive one
/// is outlined in the danger colour. The body scrolls at large text and the buttons stay in place.
class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: LiltColors.surface,
      insetPadding: const EdgeInsets.all(LiltSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(LiltSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(header: true, child: const Text('Delete everything?', style: LiltText.display)),
                    const SizedBox(height: LiltSpacing.md),
                    Text(
                      'This removes everything Lilt has saved on this phone: your starting point, plans, answers and notes. It can’t be undone.',
                      style: LiltText.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: LiltSpacing.lg),
            LiltButton(label: 'Keep my data', onPressed: () => Navigator.of(context).pop(false)),
            const SizedBox(height: LiltSpacing.sm),
            LiltButton(
              label: 'Delete everything',
              kind: LiltButtonKind.secondary,
              danger: true,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Demo data": shown above the tab bar on every main screen while synthetic data is loaded.
class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 32),
        padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.lg, vertical: LiltSpacing.xs),
        color: LiltColors.selected,
        child: Text(
          'Demo data · invented, not a real person',
          style: LiltText.label.copyWith(color: LiltColors.ink, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
