import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/showcase_frame.dart';

/// The journal: a timeline of memories on the phone, the calendar and one
/// opened memory floating beside it.
class MemoriesShowcaseWidget extends StatelessWidget {
  const MemoriesShowcaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseCanvas(
      children: [
        Positioned(left: 8, top: 0, width: 196, height: 370, child: ShowcasePhone(child: _timeline())),
        Positioned(right: 0, top: 24, child: _calendarCard()),
        Positioned(right: 0, bottom: 10, child: _memoryCard()),
      ],
    );
  }

  Widget _timeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toggle(),
        const SizedBox(height: AppSpacing.sm),
        _entry('07 septembre à 16h39', 'Télétravail 😸', 'Toujours à côté de moi pendant que je bosse.',
            'assets/icons/species/cat-europeen.png', AppColors.primary100),
        const SizedBox(height: AppSpacing.sm),
        _entry('31 août à 16h40', 'Sieste et ☀️', 'Une petite ronflette au soleil sur la terrasse.',
            'assets/icons/species/dog-jack_russell_terrier.png', AppColors.tertiary100),
      ],
    );
  }

  Widget _toggle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.backgroundStroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.full)),
              child: Text('timeline',
                  textAlign: TextAlign.center, style: AppTextStyles.textLabel.copyWith(fontSize: 9, color: AppColors.textInvert)),
            ),
          ),
          Expanded(
            child: Text('calendrier', textAlign: TextAlign.center, style: AppTextStyles.textLabel.copyWith(fontSize: 9)),
          ),
        ],
      ),
    );
  }

  Widget _entry(String date, String title, String text, String icon, Color background) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text(date, style: AppTextStyles.textLabel.copyWith(fontSize: 8, color: AppColors.textSecondary))),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _polaroid(icon, background, 64),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, style: AppTextStyles.textBold.copyWith(fontSize: 12)),
                  Text(text, maxLines: 3, style: AppTextStyles.textLabel.copyWith(fontSize: 8, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _polaroid(String icon, Color background, double size) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Container(
        width: size,
        height: size,
        color: background,
        padding: const EdgeInsets.all(6),
        child: Image.asset(icon),
      ),
    );
  }

  Widget _calendarCard() {
    const marked = {3, 7, 12, 13, 18, 24, 28};
    return ShowcaseCard(
      width: 128,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Septembre 2026', style: AppTextStyles.textBold.copyWith(fontSize: 11)),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 2,
            runSpacing: 2,
            children: [
              for (var day = 1; day <= 30; day++)
                Container(
                  width: 14,
                  height: 14,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: marked.contains(day) ? AppColors.primary100 : null,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text('$day', style: AppTextStyles.textLabel.copyWith(fontSize: 7)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memoryCard() {
    return ShowcaseCard(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sieste et ☀️', style: AppTextStyles.textBold.copyWith(fontSize: 13)),
          Text('31 août à 16h40', style: AppTextStyles.textLabel.copyWith(fontSize: 8, color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              _polaroid('assets/icons/species/dog-jack_russell_terrier.png', AppColors.tertiary100, 44),
              const SizedBox(width: AppSpacing.xs),
              _polaroid('assets/icons/species/cat-europeen.png', AppColors.secondary100, 44),
            ],
          ),
        ],
      ),
    );
  }
}
