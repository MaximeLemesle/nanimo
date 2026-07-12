import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? userName;
  final DateTime now;

  const HomeHeaderWidget({
    super.key,
    required this.now,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormatter.weekdayDayMonth(now).toUpperCase(),
          style: AppTextStyles.numberSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: AppFontSize.xs,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          userName == null ? 'Ton board' : 'Board de $userName',
          style: AppTextStyles.title02,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
