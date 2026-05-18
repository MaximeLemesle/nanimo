import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.backgroundSurface,
        onPrimary: AppColors.textInvert,
        onSurface: AppColors.textPrimary,
        error: Colors.red.shade700,
      ),
      textTheme: GoogleFonts.geologicaTextTheme(base.textTheme).copyWith(
        displayLarge: AppTextStyles.title01,
        displayMedium: AppTextStyles.title02,
        displaySmall: AppTextStyles.title03,
        titleLarge: AppTextStyles.textBold,
        titleMedium: AppTextStyles.textSmallBold,
        bodyLarge: AppTextStyles.text,
        bodyMedium: AppTextStyles.textSmall,
        labelSmall: AppTextStyles.textLabel,
      ),
    );
  }
}
