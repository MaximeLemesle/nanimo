import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/showcase_frame.dart';

/// The reminders: what Nanimo calls the owner about, floating over the
/// notification settings.
class RemindersShowcaseWidget extends StatelessWidget {
  const RemindersShowcaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseCanvas(
      children: [
        Positioned(left: 52, top: 150, width: 216, height: 260, child: ShowcasePhone(child: _settings())),
        Positioned(
          left: 0,
          top: 0,
          child: _reminder(const Icon(Icons.vaccines_rounded, color: AppColors.primary, size: 20), 'Vaccin à venir',
              'Dans 3 jours', 'Rappel annuel'),
        ),
        Positioned(
          right: 0,
          top: 36,
          child: _reminder(Image.asset('assets/icons/species/dog-jack_russell_terrier.png', width: 22),
              'Visite véto', 'Dans 1 semaine', 'Contrôle de routine'),
        ),
        Positioned(
          left: 0,
          top: 92,
          child: _reminder(const Icon(Icons.medication_rounded, color: AppColors.primary, size: 20), 'Vermifuge',
              'Dans 5 jours', 'Penser au traitement'),
        ),
        Positioned(
          right: 0,
          top: 128,
          child: _reminder(Image.asset('assets/icons/event_types/birthday.png', width: 22), 'Anniversaire 🎉',
              'Dans 2 jours', 'Joyeux anniversaire !'),
        ),
      ],
    );
  }

  Widget _reminder(Widget icon, String title, String when, String detail) {
    return ShowcaseCard(
      width: 150,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: icon,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, style: AppTextStyles.textBold.copyWith(fontSize: 11)),
                Text(when, style: AppTextStyles.textLabel.copyWith(fontSize: 9, color: AppColors.primary)),
                Text(detail,
                    maxLines: 1, style: AppTextStyles.textLabel.copyWith(fontSize: 8, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settings() {
    Widget toggle(String label) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.textLabel.copyWith(fontSize: 10))),
              Container(
                width: 26,
                height: 15,
                padding: const EdgeInsets.all(2),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.full)),
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: const BoxDecoration(color: AppColors.backgroundSurface, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notifications', style: AppTextStyles.textBold.copyWith(fontSize: 13)),
        const SizedBox(height: AppSpacing.xs),
        toggle('Rappels santé et anniversaires'),
        toggle('Vaccins'),
        toggle('Visites vétérinaires'),
        toggle('Vermifuges'),
        toggle('Anniversaires'),
      ],
    );
  }
}
