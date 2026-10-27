import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'equalizer_bars.dart';

/// The top of the main screens: the Lilt mark on the left and the profile button on the right, which opens
/// Settings (S-008). Signed in to Together it shows the initial of the display name; signed out ([initial] null)
/// a neutral person icon, never a made-up initial. The button is a 40 dp circle with a 48 dp target.
///
/// The mark here is the three equalizer bars. The full wordmark is an exported SVG from Figma (docs/DESIGN.md,
/// Brand motion) and is swapped in when it is added to the app.
class LiltHeader extends StatelessWidget {
  const LiltHeader({super.key, required this.onProfile, this.initial});

  final VoidCallback onProfile;
  final String? initial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.lg),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            const EqualizerBars(height: 28),
            const Spacer(),
            Semantics(
              button: true,
              label: 'Settings',
              excludeSemantics: true,
              child: InkWell(
                onTap: onProfile,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: LiltColors.grid1, shape: BoxShape.circle),
                      child: initial == null || initial!.isEmpty
                          ? const Icon(Icons.person_outline, size: 22, color: LiltColors.ink)
                          : Text(initial!.characters.first.toUpperCase(), style: LiltText.label),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
