import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/theme.dart';
import 'package:lilt/ui/ui.dart';

/// TC-044 (200% text) and TC-045 (48 dp targets) for each shared widget, once, so the screens that use them
/// inherit the result (docs/DESIGN.md, Build checks).
const _phone = Size(360, 800);
const _small = Size(320, 568);

Future<void> _pump(WidgetTester tester, Widget child,
    {Size size = _phone, double textScale = 1, bool settle = true}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildLiltTheme(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Scaffold(body: SafeArea(child: SingleChildScrollView(child: child))),
    ),
  );
  settle ? await tester.pumpAndSettle() : await tester.pump();
}

Widget _gallery({ValueChanged<String>? onChip}) => Padding(
      padding: const EdgeInsets.all(LiltSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiltHeader(onProfile: () {}, initial: 'S'),
          const SizedBox(height: LiltSpacing.lg),
          LiltButton(label: 'I’ll try this', onPressed: () {}),
          const SizedBox(height: LiltSpacing.sm),
          LiltButton(label: 'Pause for 1 week', onPressed: () {}, kind: LiltButtonKind.secondary),
          const SizedBox(height: LiltSpacing.sm),
          LiltButton(label: 'Delete everything', onPressed: () {}, kind: LiltButtonKind.secondary, danger: true),
          const SizedBox(height: LiltSpacing.sm),
          LiltButton(label: 'Something else', onPressed: () {}, kind: LiltButtonKind.text),
          const SizedBox(height: LiltSpacing.sm),
          LiltChipWrap(
            children: [
              LiltChip(label: '20 min', onTap: () => onChip?.call('20'), menu: true),
              LiltChip(label: 'Walking', onTap: () {}, selected: true, multi: true),
              LiltChip(label: 'Running', onTap: () {}, multi: true),
              LiltChip(label: 'Done', onTap: () {}, selected: true),
            ],
          ),
          const SizedBox(height: LiltSpacing.lg),
          LiltSegmented<int>(
            segments: const [
              LiltSegment(value: 3, label: '3 days'),
              LiltSegment(value: 7, label: '1 week'),
              LiltSegment(value: 14, label: '2 weeks'),
            ],
            value: 7,
            onChanged: (_) {},
          ),
          const SizedBox(height: LiltSpacing.lg),
          LiltNavBar(index: 0, onSelect: (_) {}),
        ],
      ),
    );

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final size in [_phone, _small]) {
      group('at ${(scale * 100).round()}% text on ${size.width.toInt()}×${size.height.toInt()}', () {
        testWidgets('nothing overflows', (tester) async {
          await _pump(tester, _gallery(), size: size, textScale: scale);
          expect(tester.takeException(), isNull);
        });

        testWidgets('tap targets are at least 48 dp and labelled', (tester) async {
          final handle = tester.ensureSemantics();
          await _pump(tester, _gallery(), size: size, textScale: scale);
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        });
      });
    }
  }

  testWidgets('text contrast meets the guideline', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester, _gallery());
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  group('LiltButton', () {
    testWidgets('is 48 dp tall and fires onPressed', (tester) async {
      var taps = 0;
      await _pump(tester, LiltButton(label: 'Go', onPressed: () => taps++));
      expect(tester.getSize(find.byType(FilledButton)).height, greaterThanOrEqualTo(48));
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });

    testWidgets('disabled does nothing; loading keeps its place and ignores taps', (tester) async {
      var taps = 0;
      await _pump(tester, LiltButton(label: 'Go', onPressed: null));
      await tester.tap(find.text('Go'), warnIfMissed: false);
      expect(taps, 0);

      await _pump(tester, LiltButton(label: 'Go', onPressed: () => taps++, loading: true), settle: false);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Go'), findsNothing);
      await tester.tap(find.byType(FilledButton));
      expect(taps, 0);
    });

    testWidgets('a danger secondary button is outlined, never filled', (tester) async {
      await _pump(tester, LiltButton(label: 'Delete', onPressed: () {}, kind: LiltButtonKind.secondary, danger: true));
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('a text button is 48 dp tall and not full width', (tester) async {
      await _pump(tester, LiltButton(label: 'Not today', onPressed: () {}, kind: LiltButtonKind.text));
      final size = tester.getSize(find.byType(TextButton));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, lessThan(_phone.width));
    });
  });

  group('keyboard focus ring (DESIGN.md: primary is the focus ring)', () {
    testWidgets('a button shows a 2 px primary border while focused', (tester) async {
      await _pump(tester, LiltButton(label: 'Go', onPressed: () {}));
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.style!.side!.resolve({WidgetState.focused})!.color, LiltColors.primary);
      expect(button.style!.side!.resolve({WidgetState.focused})!.width, 2);
      expect(button.style!.side!.resolve({}), isNull);
    });

    testWidgets('a secondary button keeps its own edge until focused', (tester) async {
      await _pump(tester, LiltButton(label: 'Go', onPressed: () {}, kind: LiltButtonKind.secondary));
      final side = tester.widget<OutlinedButton>(find.byType(OutlinedButton)).style!.side!;
      expect(side.resolve({})!.color, LiltColors.field);
      expect(side.resolve({WidgetState.focused})!.color, LiltColors.primary);
    });

    final focusable = <String, Widget>{
      'chip': LiltChip(label: 'Walking', onTap: () {}),
      'segmented control': LiltSegmented<int>(
        segments: const [LiltSegment(value: 1, label: 'One'), LiltSegment(value: 2, label: 'Two')],
        value: 1,
        onChanged: (_) {},
      ),
      'nav bar': LiltNavBar(index: 0, onSelect: (_) {}),
    };
    for (final entry in focusable.entries) {
      testWidgets('a ${entry.key} shows the ring when it takes keyboard focus', (tester) async {
        await _pump(tester, entry.value);
        expect(find.byKey(const Key('lilt-focus-ring')), findsNothing);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(find.byKey(const Key('lilt-focus-ring')), findsOneWidget);
      });
    }
  });

  group('LiltButton details', () {
    testWidgets('the loading spinner takes the label colour, so it never vanishes on a light button', (tester) async {
      Color spinner() => tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator)).color!;
      final cases = <(LiltButtonKind, bool, Color)>[
        (LiltButtonKind.primary, false, LiltColors.onPrimary),
        (LiltButtonKind.secondary, false, LiltColors.ink),
        (LiltButtonKind.secondary, true, LiltColors.danger),
        (LiltButtonKind.text, false, LiltColors.ink),
      ];
      for (final (kind, danger, expected) in cases) {
        await _pump(
          tester,
          LiltButton(label: 'Go', onPressed: () {}, kind: kind, danger: danger, loading: true),
          settle: false,
        );
        expect(spinner(), expected, reason: '${kind.name} danger=$danger');
      }
    });

    testWidgets('a flush text button puts its label on the content edge and keeps a 48 dp target', (tester) async {
      await _pump(
        tester,
        Padding(
          padding: const EdgeInsets.all(LiltSpacing.lg),
          child: LiltButton(label: 'Edit', onPressed: () {}, kind: LiltButtonKind.text, flush: true),
        ),
      );
      expect(tester.getTopLeft(find.text('Edit')).dx, closeTo(LiltSpacing.lg, 0.5));
      expect(tester.getSize(find.byType(TextButton)).height, greaterThanOrEqualTo(48));
      expect(tester.getSize(find.byType(TextButton)).width, greaterThanOrEqualTo(48));
    });

    test('only a text button can be flush', () {
      expect(() => LiltButton(label: 'x', onPressed: () {}, flush: true), throwsAssertionError);
    });

    test('button labels are 15 sp (Figma Label/L) and titles use the 34 sp display style', () {
      expect(LiltText.button.fontSize, 15);
      expect(LiltText.display.fontSize, 34);
    });
  });

  group('LiltChipWrap', () {
    testWidgets('keeps neighbouring hit areas at least 8 dp apart, also at 200% text', (tester) async {
      for (final scale in [1.0, 2.0]) {
        await _pump(
          tester,
          LiltChipWrap(
            children: [
              for (final label in ['20 min', 'Medium energy', 'Walking', 'Running', 'Swimming'])
                LiltChip(label: label, onTap: () {}, menu: true),
            ],
          ),
          textScale: scale,
        );
        final rects = [
          for (final e in find.byType(InkWell).evaluate()) tester.getRect(find.byWidget(e.widget)),
        ];
        expect(rects.length, 5);
        double gap(double aStart, double aEnd, double bStart, double bEnd) =>
            aStart >= bEnd ? aStart - bEnd : (bStart >= aEnd ? bStart - aEnd : -1);
        for (var i = 0; i < rects.length; i++) {
          for (var j = i + 1; j < rects.length; j++) {
            final gapX = gap(rects[i].left, rects[i].right, rects[j].left, rects[j].right);
            final gapY = gap(rects[i].top, rects[i].bottom, rects[j].top, rects[j].bottom);
            expect(gapX >= 8 || gapY >= 8, isTrue, reason: 'scale $scale: chips $i and $j');
          }
        }
      }
    });

    testWidgets('chip icons grow with the text', (tester) async {
      Future<double> tick(double scale) async {
        await _pump(tester, LiltChip(label: 'A', onTap: () {}, selected: true, multi: true), textScale: scale);
        return tester.widget<Icon>(find.byIcon(Icons.check)).size!;
      }

      expect(await tick(1), 16);
      expect(await tick(2), 32);
    });
  });

  group('LiltButtonRow', () {
    Widget row() => LiltButtonRow(children: [
          LiltButton(label: 'Something else', onPressed: () {}, kind: LiltButtonKind.text),
          LiltButton(label: 'Not today', onPressed: () {}, kind: LiltButtonKind.text),
        ]);

    // The widget-test font is wider than Geist, so these check the layout, not where a word wraps.
    testWidgets('side by side at normal size', (tester) async {
      await _pump(tester, row());
      final group = find.byType(LiltButtonRow);
      expect(find.descendant(of: group, matching: find.byType(Expanded)), findsNWidgets(2));
      expect(find.descendant(of: group, matching: find.byType(Column)), findsNothing);
    });

    testWidgets('stacks at large text, one button per row at full width', (tester) async {
      await _pump(tester, row(), textScale: 2);
      final group = find.byType(LiltButtonRow);
      expect(find.descendant(of: group, matching: find.byType(Expanded)), findsNothing);
      expect(
        tester.getTopLeft(find.text('Not today')).dy,
        greaterThan(tester.getBottomLeft(find.text('Something else')).dy),
      );
      expect(tester.getSize(find.byType(TextButton).first).width, closeTo(_phone.width, 1));
      expect(tester.takeException(), isNull);
    });
  });

  group('LiltChip', () {
    testWidgets('looks 32 dp tall with a 48 dp hit area, the same selected or not', (tester) async {
      await _pump(
        tester,
        Row(children: [
          LiltChip(label: 'A', onTap: () {}),
          LiltChip(label: 'B', onTap: () {}, selected: true),
        ]),
      );
      for (final label in ['A', 'B']) {
        final visual = find.ancestor(of: find.text(label), matching: find.byType(Container)).first;
        expect(tester.getSize(visual).height, 32, reason: label);
        expect(tester.getSize(find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first).height, 48);
      }
      expect(tester.getSize(find.ancestor(of: find.text('A'), matching: find.byType(InkWell)).first).width,
          greaterThanOrEqualTo(48));
    });

    testWidgets('a tick means multiple choice: only a selected multi chip shows one', (tester) async {
      await _pump(
        tester,
        Column(children: [
          LiltChip(label: 'multi on', onTap: () {}, selected: true, multi: true),
          LiltChip(label: 'multi off', onTap: () {}, multi: true),
          LiltChip(label: 'single on', onTap: () {}, selected: true),
          LiltChip(label: 'menu', onTap: () {}, selected: true, multi: true, menu: true),
        ]),
      );
      Finder tickIn(String label) => find.descendant(
            of: find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first,
            matching: find.byIcon(Icons.check),
          );
      expect(tickIn('multi on'), findsOneWidget);
      expect(tickIn('multi off'), findsNothing);
      expect(tickIn('single on'), findsNothing);
      expect(tickIn('menu'), findsNothing);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('reports selected to assistive technology', (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester, LiltChip(label: 'Done', onTap: () {}, selected: true));
      expect(tester.getSemantics(find.text('Done')), matchesSemantics(
        label: 'Done',
        isButton: true,
        isSelected: true,
        isEnabled: true,
        hasEnabledState: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ));
      handle.dispose();
    });
  });

  group('LiltSegmented', () {
    Widget control(void Function(int) onChanged) => LiltSegmented<int>(
          segments: const [
            LiltSegment(value: 3, label: '3 days'),
            LiltSegment(value: 7, label: '1 week'),
            LiltSegment(value: 14, label: '2 weeks'),
          ],
          value: 7,
          onChanged: onChanged,
        );

    testWidgets('is one row at normal size, 48 dp tall, and selects on tap', (tester) async {
      int? picked;
      await _pump(tester, control((v) => picked = v));
      expect(tester.getSize(find.byType(LiltSegmented<int>)).height, greaterThanOrEqualTo(48));
      // One row: the segments sit side by side. (The test font is wider than Geist, so compare layout, not
      // the text's own position.)
      final segmented = find.byType(LiltSegmented<int>);
      expect(find.descendant(of: segmented, matching: find.byType(Row)), findsOneWidget);
      expect(find.descendant(of: segmented, matching: find.byType(Column)), findsNothing);
      await tester.tap(find.text('2 weeks'));
      expect(picked, 14);
    });

    testWidgets('stacks one option per row at large text', (tester) async {
      await _pump(tester, control((_) {}), textScale: 2);
      final segmented = find.byType(LiltSegmented<int>);
      expect(find.descendant(of: segmented, matching: find.byType(Column)), findsOneWidget);
      expect(tester.getTopLeft(find.text('2 weeks')).dy, greaterThan(tester.getTopLeft(find.text('3 days')).dy + 40));
      expect(tester.takeException(), isNull);
    });
  });

  group('LiltNavBar', () {
    testWidgets('has the four tabs, is 80 dp, and selects', (tester) async {
      var picked = -1;
      await _pump(tester, LiltNavBar(index: 0, onSelect: (i) => picked = i));
      for (final label in ['Today', 'Discover', 'Together', 'My rhythm']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(tester.getSize(find.byType(LiltNavBar)).height, greaterThanOrEqualTo(80));
      await tester.tap(find.text('Together'));
      expect(picked, 2);
    });

    testWidgets('labels grow with the system text up to 16 sp and then stop; they never wrap', (tester) async {
      double size(WidgetTester t) => t.widget<Text>(find.text('My rhythm')).style!.fontSize!;
      await _pump(tester, LiltNavBar(index: 0, onSelect: (_) {}), textScale: 1);
      expect(size(tester), 12);
      await _pump(tester, LiltNavBar(index: 0, onSelect: (_) {}), textScale: 2);
      expect(size(tester), closeTo(16, 1e-9));
      expect(tester.getSize(find.text('My rhythm')).height, lessThan(24));
      expect(tester.takeException(), isNull);
    });
  });

  group('LiltHeader', () {
    testWidgets('signed out shows a person icon, never an initial; the button is named Settings', (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester, LiltHeader(onProfile: () {}));
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.bySemanticsLabel('Settings'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('signed in shows the initial and opens Settings', (tester) async {
      var opened = false;
      await _pump(tester, LiltHeader(onProfile: () => opened = true, initial: 'shieryl'));
      expect(find.text('S'), findsOneWidget);
      await tester.tap(find.text('S'));
      expect(opened, isTrue);
    });
  });

  group('showLiltSheet', () {
    Future<void> open(WidgetTester tester, {Widget? footer, int lines = 3, double scale = 1, Size size = _phone}) async {
      await _pump(
        tester,
        Builder(
          builder: (context) => LiltButton(
            label: 'Open',
            onPressed: () => showLiltSheet<void>(
              context,
              title: 'Not today?',
              subtitle: 'That’s okay. What would help?',
              footer: footer,
              bodyBuilder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (var i = 0; i < lines; i++) Text('Row $i', style: LiltText.body)],
              ),
            ),
          ),
        ),
        size: size,
        textScale: scale,
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows the title, a 48 dp close, and closes', (tester) async {
      await open(tester);
      expect(find.text('Not today?'), findsOneWidget);
      expect(tester.getSize(find.byTooltip('Close')).shortestSide, greaterThanOrEqualTo(48));
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Not today?'), findsNothing);
    });

    testWidgets('is never taller than 90% of the screen, and a short sheet does not scroll', (tester) async {
      await open(tester, lines: 2);
      expect(tester.getSize(find.byType(LiltSheet)).height, lessThan(_phone.height * 0.9));
      expect(find.byType(Scrollable).evaluate().where((e) => e.widget is Scrollable && (e.widget as Scrollable).axisDirection == AxisDirection.down).length, greaterThanOrEqualTo(1));
    });

    testWidgets('tall content scrolls while the close and the footer stay pinned and visible', (tester) async {
      await open(
        tester,
        lines: 60,
        scale: 2,
        size: _small,
        footer: LiltButton(label: 'Save changes', onPressed: () {}),
      );
      final sheet = tester.getRect(find.byType(LiltSheet));
      expect(sheet.height, lessThanOrEqualTo(_small.height * 0.9 + 1));
      expect(tester.getRect(find.text('Save changes')).bottom, lessThanOrEqualTo(_small.height));
      expect(tester.getRect(find.byTooltip('Close')).top, greaterThanOrEqualTo(sheet.top));
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('the equalizer bars keep the fixed ratio and a name for assistive technology', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester, const EqualizerBars(height: 100));
    expect(tester.getSize(find.byType(EqualizerBars)).height, 100);
    expect(find.bySemanticsLabel('Lilt'), findsOneWidget);
    handle.dispose();
  });
}
