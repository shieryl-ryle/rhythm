import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme.dart';

class LiltTab {
  const LiltTab({required this.label, required this.icon, required this.activeIcon});

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// The four tabs, in order (docs/sitemap.md §1): Today, Discover, Together, My rhythm.
const liltTabs = [
  LiltTab(label: 'Today', icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today),
  LiltTab(label: 'Discover', icon: Icons.place_outlined, activeIcon: Icons.place),
  LiltTab(label: 'Together', icon: Icons.groups_outlined, activeIcon: Icons.groups),
  LiltTab(label: 'My rhythm', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart),
];

/// The bottom navigation bar: 80 dp, an active pill behind the icon, 12 sp labels. Labels grow with the system
/// text size up to 16 sp (1.33x) and then stop; they never wrap, break or ellipsise. The icon, the pill and the
/// accessible name carry the destination at larger sizes. This is the one documented exception to 200% text.
class LiltNavBar extends StatelessWidget {
  const LiltNavBar({super.key, required this.index, required this.onSelect, this.tabs = liltTabs});

  final int index;
  final ValueChanged<int> onSelect;
  final List<LiltTab> tabs;

  static const _labelSize = 12.0;
  static const _maxLabelScale = 16 / 12;

  @override
  Widget build(BuildContext context) {
    final scale = math.min(MediaQuery.textScalerOf(context).scale(1), _maxLabelScale);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: LiltColors.surface,
        border: Border(top: BorderSide(color: LiltColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == index,
                    label: tabs[i].label,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () => onSelect(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 32,
                            decoration: ShapeDecoration(
                              color: i == index ? LiltColors.selected : Colors.transparent,
                              shape: const StadiumBorder(),
                            ),
                            child: Icon(
                              i == index ? tabs[i].activeIcon : tabs[i].icon,
                              size: 22,
                              color: LiltColors.ink,
                            ),
                          ),
                          const SizedBox(height: LiltSpacing.xs),
                          Text(
                            tabs[i].label,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.visible,
                            textScaler: TextScaler.noScaling,
                            style: LiltText.label.copyWith(
                              fontSize: _labelSize * scale,
                              fontWeight: i == index ? FontWeight.w600 : FontWeight.w500,
                              color: i == index ? LiltColors.ink : LiltColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
