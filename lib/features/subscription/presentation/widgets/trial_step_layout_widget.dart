import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

/// Shared frame of the trial screens: title, a visual, the reassurance that
/// nothing is charged now, and one way forward.
class TrialStepLayoutWidget extends StatelessWidget {
  final Widget title;
  final String? subtitle;
  final Widget visual;
  final String ctaLabel;
  final VoidCallback onContinue;
  final bool showBack;

  const TrialStepLayoutWidget({
    super.key,
    required this.title,
    required this.visual,
    required this.ctaLabel,
    required this.onContinue,
    this.subtitle,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 48,
                child: showBack
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: AppColors.textPrimary,
                          tooltip: 'Retour',
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      )
                    : null,
              ),
              DefaultTextStyle.merge(
                textAlign: TextAlign.center,
                style: AppTextStyles.title02,
                child: title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Expanded(child: Center(child: visual)),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_rounded, color: AppColors.primary, size: 22),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(child: Text('Aucun paiement maintenant', style: AppTextStyles.textBold)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ButtonWidget(label: ctaLabel, fullWidth: true, onPressed: onContinue),
            ],
          ),
        ),
      ),
    );
  }
}
