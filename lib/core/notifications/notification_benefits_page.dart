import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

/// What the reminders bring, in the onboarding's style, before the system
/// prompt. Each line matches what ReminderPlanner actually schedules.
class NotificationBenefitsPage extends StatelessWidget {
  /// The system prompt was already refused: the button leads to the settings.
  final bool openSettings;

  /// Pops with true to go ahead, false or null otherwise.
  const NotificationBenefitsPage({super.key, this.openSettings = false});

  static const benefits = [
    (icon: '💉', text: 'N’oublie plus les vaccins', detail: ', un rappel 7 jours avant et la veille.'),
    (icon: '🩺', text: 'Un rappel la veille des visites à venir', detail: ', et 2 h avant le rendez-vous.'),
    (icon: '🎂', text: 'Fête son anniversaire', detail: ', une notification le jour le plus important !'),
  ];

  static Future<bool> show(BuildContext context, {bool openSettings = false}) async =>
      await Navigator.of(context, rootNavigator: true).push<bool>(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => NotificationBenefitsPage(openSettings: openSettings),
      )) ??
      false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                color: AppColors.textPrimary,
                tooltip: 'Fermer',
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      'Ne rate rien !',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title02,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Flexible(child: Image.asset('assets/notifications.png', fit: BoxFit.contain)),
                    const SizedBox(height: AppSpacing.xl),
                    for (final benefit in benefits)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(benefit.icon, style: TextStyle(fontSize: AppFontSize.lg)),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text.rich(TextSpan(
                                text: benefit.text,
                                style: AppTextStyles.textBold,
                                children: [TextSpan(text: benefit.detail, style: AppTextStyles.text)],
                              )),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
              child: ButtonWidget(
                label: openSettings ? 'Ouvrir les réglages' : 'Activer les notifications',
                fullWidth: true,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Plus tard', style: AppTextStyles.text.copyWith(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
