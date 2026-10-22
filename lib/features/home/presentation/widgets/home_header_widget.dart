import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? userName;
  final DateTime now;
  final VoidCallback? onSettingsTap;

  const HomeHeaderWidget({
    super.key,
    required this.now,
    this.userName,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormatter.weekdayDayMonth(now).toUpperCase(),
                  style: AppTextStyles.numberSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: AppFontSize.xs,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (onSettingsTap != null)
                IconButton(
                  onPressed: onSettingsTap,
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: AppColors.textSecondary,
                  ),
                  tooltip: 'Paramètres',
                ),
            ],
          ),
        ),
        Text(
          userName == null ? 'Ton carnet' : 'Carnet de $userName',
          style: AppTextStyles.title02,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
