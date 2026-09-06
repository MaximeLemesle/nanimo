import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';

/// Lands here right after a purchase, replacing the paywall rather than
/// stacking on it: going back must never return to the offers.
///
/// [isConfirmed] says whether `users.subscription_status` has actually flipped.
/// When it has not, the page keeps the thanks but drops the premium call to
/// action, because the quota triggers would refuse the action anyway and the
/// user would meet an error seconds after paying.
class PremiumWelcomePage extends StatefulWidget {
  final bool isConfirmed;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const PremiumWelcomePage({
    super.key,
    required this.isConfirmed,
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
    if (!widget.isConfirmed) return;
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
    final confirmed = widget.isConfirmed;

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
                      const PaywallMemoriesWidget(),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        confirmed ? premiumWelcomeTitle : premiumPendingTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title01,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        confirmed
                            ? premiumWelcomeSubtitle
                            : premiumPendingSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.text
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (confirmed) _benefits() else _pendingNotice(),
                      const Spacer(),
                      ButtonWidget(
                        label: confirmed
                            ? premiumWelcomeCta
                            : premiumPendingCta,
                        fullWidth: true,
                        onPressed:
                            confirmed ? widget.onPrimary : widget.onSecondary,
                      ),
                      if (confirmed)
                        TextButton(
                          onPressed: widget.onSecondary,
                          child: Text(
                            premiumWelcomeSecondaryCta,
                            style: AppTextStyles.textSmall
                                .copyWith(color: AppColors.textSecondary),
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
                        style: AppTextStyles.text
                            .copyWith(color: AppColors.textSecondary),
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

  Widget _pendingNotice() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        premiumPendingNotice,
        textAlign: TextAlign.center,
        style: AppTextStyles.textSmall,
      ),
    );
  }
}
