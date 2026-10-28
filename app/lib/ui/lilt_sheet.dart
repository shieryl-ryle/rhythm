import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Opens a bottom sheet (docs/DESIGN.md Interaction rules, Sheets): the screen behind stays visible under a 32%
/// scrim, the top radius is 28 dp with a 1 px `sheet-line` edge, it is never taller than 90% of the screen, and
/// there is a 48 dp close (×) as well as swipe.
///
/// When the content is taller than the sheet (200% text, a short phone) the close stays pinned, the body
/// scrolls, and [footer] stays pinned under a 1 dp divider. Only a button that is the sheet's one primary
/// belongs in [footer]; a menu sheet has none. With a field focused the footer sits above the keyboard.
Future<T?> showLiltSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder bodyBuilder,
  String? subtitle,
  Widget? footer,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    // On the root navigator, so a sheet sits on the bottom edge of the screen over the tab bar and the scrim
    // covers everything (docs/DESIGN.md, Sheets).
    useRootNavigator: true,
    useSafeArea: true,
    barrierColor: LiltColors.scrim,
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (context) => LiltSheet(title: title, subtitle: subtitle, footer: footer, bodyBuilder: bodyBuilder),
  );
}

class LiltSheet extends StatelessWidget {
  const LiltSheet({
    super.key,
    required this.title,
    required this.bodyBuilder,
    this.subtitle,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final WidgetBuilder bodyBuilder;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final maxHeight = (media.size.height - media.padding.top) * 0.9;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: keyboard),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          // A 1 px `sheet-line` edge keeps the sheet visible over the scrim; its bottom edge is off screen.
          color: LiltColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(LiltRadius.sheet)),
            side: BorderSide(color: LiltColors.sheetLine),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: LiltSpacing.sm),
              ExcludeSemantics(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LiltColors.grid1,
                    borderRadius: BorderRadius.circular(LiltRadius.pill),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LiltSpacing.xl, right: LiltSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(title, style: LiltText.display),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Close',
                      color: LiltColors.primary,
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    LiltSpacing.xl,
                    0,
                    LiltSpacing.xl,
                    footer == null ? LiltSpacing.xxl - LiltSpacing.xs + media.padding.bottom : LiltSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subtitle != null) ...[
                        Text(subtitle!, style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
                        const SizedBox(height: LiltSpacing.lg),
                      ],
                      Builder(builder: bodyBuilder),
                    ],
                  ),
                ),
              ),
              if (footer != null) ...[
                const Divider(height: 1, thickness: 1, color: LiltColors.line),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    LiltSpacing.xl,
                    LiltSpacing.lg,
                    LiltSpacing.xl,
                    LiltSpacing.xxl - LiltSpacing.xs + media.padding.bottom,
                  ),
                  child: footer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
