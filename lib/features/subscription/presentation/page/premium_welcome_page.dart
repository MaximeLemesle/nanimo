import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';

/// Lands here right after a purchase
class PremiumWelcomePage extends StatefulWidget {
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const PremiumWelcomePage({
    super.key,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  State<PremiumWelcomePage> createState() => _PremiumWelcomePageState();
}

class _PremiumWelcomePageState extends State<PremiumWelcomePage> {
  /// Same palette and same shot as the pet creation celebration, so the two
  /// happy moments of the app feel like the same app.
  static const _confettiColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
    AppColors.primary300,
    AppColors.tertiary300,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _launchConfetti();
    });
  }

  void _launchConfetti() {
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 60,
        angle: 60,
        spread: 55,
        x: 0,
        y: 0.7,
        colors: _confettiColors,
      ),
    );
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 60,
        angle: 120,
        spread: 55,
        x: 1,
        y: 0.7,
        colors: _confettiColors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      const PaywallMemoriesWidget(isAnimated: true),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        premiumWelcomeTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title01,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        premiumWelcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _benefits(),
                      const Spacer(),
                      ButtonWidget(
                        label: premiumWelcomeCta,
                        fullWidth: true,
                        onPressed: widget.onPrimary,
                      ),
                      TextButton(
                        onPressed: widget.onSecondary,
                        child: Text(
                          premiumWelcomeSecondaryCta,
                          style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      Text(
                        premiumWelcomeNotice,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textSmall.copyWith(
                          fontSize: 10,
                          height: 1.35,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reuses the paywall promises so the page says exactly what was bought.
  Widget _benefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: paywallBenefits
          .map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '${benefit.subtitle} ',
                        style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: benefit.title,
                            style: AppTextStyles.textBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
