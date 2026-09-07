import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';

/// Fills the paywall while the purchase is confirmed server-side.
class PaywallConfirmingWidget extends StatelessWidget {
  const PaywallConfirmingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PaywallMemoriesWidget(isAnimated: true),
          const SizedBox(height: AppSpacing.xl),
          Text(
            premiumConfirmingTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.title02,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            premiumConfirmingSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Lottie.asset(
            'assets/animation/logo_animation.json',
            height: 80,
            repeat: true,
            frameRate: FrameRate(60),
            renderCache: RenderCache.raster,
          ),
        ],
      ),
    );
  }
}
