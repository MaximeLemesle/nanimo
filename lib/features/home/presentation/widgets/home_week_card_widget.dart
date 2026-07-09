import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

/// Week bento tile: memories captured over the last 7 days, one dot per day.
class HomeWeekCardWidget extends StatelessWidget {
  final int count;
  final Set<int> activeDays;
  final VoidCallback? onTap;

  const HomeWeekCardWidget({
    super.key,
    required this.count,
    required this.activeDays,
    this.onTap,
  });

  static const List<String> _dayLetters = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cette semaine',
              style: AppTextStyles.textLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$count',
              style: AppTextStyles.numberBig.copyWith(
                fontSize: AppFontSize.xxl,
                color: AppColors.primary700,
              ),
            ),
            Text(
              count == 0
                  ? 'Aucun souvenir'
                  : count == 1
                      ? 'souvenir capturé'
                      : 'souvenirs capturés',
              style: AppTextStyles.textSmall,
            ),
            const Spacer(),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var day = 1; day <= 7; day++)
                  _DayDot(
                    letter: _dayLetters[day - 1],
                    isActive: activeDays.contains(day),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String letter;
  final bool isActive;

  const _DayDot({required this.letter, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.backgroundSurface,
        shape: BoxShape.circle,
        border: isActive
            ? null
            : Border.all(color: AppColors.backgroundStroke),
      ),
      child: Text(
        letter,
        style: AppTextStyles.textSmallBold.copyWith(
          fontSize: 10,
          color: isActive ? AppColors.textInvert : AppColors.textSecondary,
        ),
      ),
    );
  }
}
