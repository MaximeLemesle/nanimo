import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

class PaywallMemoriesWidget extends StatelessWidget {
  const PaywallMemoriesWidget({super.key});

  static const double height = 120;
  static const double _cardWidth = 116;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _polaroid(
            asset: 'assets/icons/species/rabbit.png',
            tint: AppColors.backgroundTertiary,
            angle: -0.17,
            offset: const Offset(-74, 10),
            scale: 0.86,
          ),
          _polaroid(
            asset: 'assets/icons/species/cat.png',
            tint: AppColors.backgroundSecondary,
            angle: 0.16,
            offset: const Offset(74, 10),
            scale: 0.86,
          ),
          _polaroid(
            asset: 'assets/icons/species/dog.png',
            tint: AppColors.backgroundPrimary,
            angle: -0.03,
            offset: const Offset(0, -8),
            scale: 1,
          ),
        ],
      ),
    );
  }

  Widget _polaroid({
    required String asset,
    required Color tint,
    required double angle,
    required Offset offset,
    required double scale,
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: _cardWidth,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(22, 0, 0, 0),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm / 2),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: tint,
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
