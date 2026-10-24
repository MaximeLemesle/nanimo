import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/showcase_frame.dart';

/// The health diary as the store screenshots show it: the pet page on a
/// phone, its weight, health facts, vaccines and last visit floating around.
class HealthShowcaseWidget extends StatelessWidget {
  const HealthShowcaseWidget({super.key});

  static const _weights = [5.6, 5.4, 5.5, 5.3, 5.3];

  @override
  Widget build(BuildContext context) {
    return ShowcaseCanvas(
      children: [
        Positioned(
          left: 62,
          top: 0,
          width: 196,
          height: 370,
          child: ShowcasePhone(child: _petPage()),
        ),
        Positioned(left: 0, top: 118, child: _weightCard()),
        Positioned(left: 0, top: 236, child: _healthCard()),
        Positioned(right: 0, top: 46, child: _vaccinesCard()),
        Positioned(right: 0, bottom: 8, child: _visitCard()),
      ],
    );
  }

  Widget _petPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/icons/species/cat-europeen.png', width: 28, height: 28),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text('Saïko', style: AppTextStyles.title03.copyWith(fontSize: 18))),
            Text('6 ans', style: AppTextStyles.textLabel.copyWith(fontSize: 9)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(12)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: ShowcaseField(value: 'Chat', label: 'Espèce')),
                Expanded(child: ShowcaseField(value: 'Européen', label: 'Race')),
              ]),
              SizedBox(height: AppSpacing.xs),
              Row(children: [
                Expanded(child: ShowcaseField(value: 'Femelle', label: 'Genre')),
                Expanded(child: ShowcaseField(value: '5,3 kg', label: 'Poids')),
              ]),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const ShowcaseSparkline(points: _weights, height: 48),
      ],
    );
  }

  Widget _weightCard() {
    return ShowcaseCard(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Poids', style: AppTextStyles.textLabel.copyWith(fontSize: 10)),
          const ShowcaseSparkline(points: _weights, height: 28),
          Row(
            children: [
              Expanded(child: Text('5,3 kg', maxLines: 1, style: AppTextStyles.textBold.copyWith(fontSize: 14))),
              const ShowcasePill(label: 'Stable', background: AppColors.primary100, foreground: AppColors.primary700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _healthCard() {
    return const ShowcaseCard(
      width: 120,
      color: AppColors.tertiary100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: ShowcaseField(value: 'Oui', label: 'Stérilisée')),
            Expanded(child: ShowcaseField(value: 'Oui', label: 'Puce')),
          ]),
          SizedBox(height: AppSpacing.xs),
          Row(children: [
            Expanded(child: ShowcaseField(value: '05/06', label: 'Vermifuge')),
            Expanded(child: ShowcaseField(value: '22/03', label: 'Visite')),
          ]),
        ],
      ),
    );
  }

  Widget _vaccinesCard() {
    Widget row(String name, ShowcasePill pill) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(child: Text(name, style: AppTextStyles.textBold.copyWith(fontSize: 11))),
              pill,
            ],
          ),
        );

    return ShowcaseCard(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vaccins', style: AppTextStyles.textLabel.copyWith(fontSize: 10)),
          row('Leucose', const ShowcasePill(label: 'Dans 29 j', background: AppColors.tertiary100, foreground: AppColors.tertiary700)),
          row('Coryza', const ShowcasePill(label: 'Terminé', background: AppColors.primary100, foreground: AppColors.primary700)),
          row('Rage', const ShowcasePill(label: 'Terminé', background: AppColors.primary100, foreground: AppColors.primary700)),
        ],
      ),
    );
  }

  Widget _visitCard() {
    return ShowcaseCard(
      width: 168,
      child: Row(
        children: [
          const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dernière visite vétérinaire', style: AppTextStyles.textLabel.copyWith(fontSize: 9)),
                Text('Cystite', style: AppTextStyles.textBold.copyWith(fontSize: 13)),
                Text('07/03/2025 · Clinique des Pins',
                    style: AppTextStyles.textLabel.copyWith(fontSize: 8, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
