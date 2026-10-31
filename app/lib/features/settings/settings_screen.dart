import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../ui/ui.dart';
import 'demo_seed.dart';
import 'settings_providers.dart';

enum _Export { idle, working, done, failed }

/// What the person asked for and could not get, so the row can say so and be tried again.
enum _Failed { none, delete, demo }

/// S-008 Settings & My Data, the first version: get support, export, delete everything, and in a demo build
/// the synthetic people. Reminders, "edit my starting point" and sharing come with the screens they open.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  _Export _export = _Export.idle;
  _Failed _failed = _Failed.none;
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
      builder: (_) => const _ConfirmDialog(
        title: 'Delete everything?',
        body:
            'This removes everything Lilt has saved on this phone: your starting point, plans, answers and notes. It can’t be undone.',
        keepLabel: 'Keep my data',
        actionLabel: 'Delete everything',
        danger: true,
      ),
    );
    if (delete != true || _busy || !mounted) return;
    setState(() {
      _busy = true;
      _failed = _Failed.none;
    });
    try {
      // Deleting sends the person back to the consent screen (BR-014, BR-017).
      await ref.read(deleteEverythingProvider)();
    } on Object {
      // Nothing is removed when a step fails (docs/data-model.md), so say so and let them try again.
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = _Failed.delete;
        });
      }
    }
  }

  Future<void> _loadDemo(DemoPersona persona) async {
    if (_busy) return;
    final load = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'Load ${persona.label}?',
        body: 'This replaces everything on this phone with invented data for ${persona.label}.',
        keepLabel: 'Keep what I have',
        actionLabel: 'Load demo data',
        danger: false,
      ),
    );
    if (load != true || !mounted) return;
    setState(() {
      _busy = true;
      _failed = _Failed.none;
    });
    try {
      await ref.read(loadDemoProvider)(persona);
      if (!mounted) return;
      setState(() => _busy = false);
      context.go('/today');
    } on Object {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = _Failed.demo;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final demo = ref.watch(demoBuildProvider);
    final demoLoaded = ref.watch(demoDataLoadedProvider).valueOrNull ?? false;

    final exportNote = switch (_export) {
      _Export.idle => 'Copies everything on this phone as text',
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
            if (demoLoaded) const DemoBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.sm, LiltSpacing.lg, LiltSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(header: true, child: const Text('Settings', style: LiltText.display)),
                    const SizedBox(height: LiltSpacing.lg),
                    LiltListRow(
                      title: 'Need support?',
                      subtitle: 'Help from people, any time',
                      onTap: () => context.push('/support'),
                    ),
                    LiltListRow(
                      title: 'Export my data',
                      subtitle: exportNote,
                      chevron: false,
                      liveRegion: true,
                      divider: false,
                      trailing: Icon(_export == _Export.done ? Icons.check : Icons.copy_outlined, color: LiltColors.ink),
                      onTap: _export == _Export.working ? null : _runExport,
                    ),
                    // Its own group, so a thumb aimed at Export does not land on it.
                    const SizedBox(height: LiltSpacing.xl),
                    LiltListRow(
                      title: 'Delete everything',
                      subtitle: _failed == _Failed.delete ? 'That didn’t work. Nothing was removed. Try again.' : 'Removes all data from this phone',
                      chevron: false,
                      liveRegion: true,
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
                          subtitle: _failed == _Failed.demo ? 'That didn’t work. Try again.' : p.story,
                          chevron: false,
                          liveRegion: true,
                          divider: p != DemoPersona.values.last,
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

/// A confirmation dialog (docs/DESIGN.md): the safe choice is the one filled button, and the other is outlined,
/// in the danger colour when it destroys something. The body scrolls at large text, with a visible scroll bar, and
/// the buttons stay in place.
class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.keepLabel,
    required this.actionLabel,
    required this.danger,
  });

  final String title;
  final String body;
  final String keepLabel;
  final String actionLabel;
  final bool danger;

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
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(header: true, child: Text(title, style: LiltText.display.copyWith(fontSize: 28))),
                      const SizedBox(height: LiltSpacing.md),
                      Text(body, style: LiltText.body),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: LiltSpacing.lg),
            LiltButton(label: keepLabel, onPressed: () => Navigator.of(context).pop(false)),
            const SizedBox(height: LiltSpacing.md),
            LiltButton(
              label: actionLabel,
              kind: LiltButtonKind.secondary,
              danger: danger,
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
