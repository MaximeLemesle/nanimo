import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  /// Health first: it is the pain point the app is installed for.
  static const benefits = [
    (icon: Icons.vaccines_outlined, label: 'Ne rate plus un rappel de vaccin'),
    (icon: Icons.menu_book_outlined, label: 'Son carnet de santé complet'),
    (icon: Icons.photo_library_outlined, label: 'Garde ses plus beaux souvenirs'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Nanimo',
                textAlign: TextAlign.center,
                style: textTheme.displayLarge?.copyWith(fontSize: 64),
              ),
              Text(
                'Chaque moment compte.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final benefit in benefits)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(benefit.icon, color: AppColors.primary600, size: 24),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(benefit.label, style: AppTextStyles.text),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              ButtonWidget(
                label: 'Commencer',
                onPressed: () => context.go(RouteNames.createPet),
                fullWidth: true,
              ),
              TextButton(
                onPressed: () => context.go(RouteNames.login),
                child: Text(
                  'J\'ai déjà un compte',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
