import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_font_weight.dart';

class AppTextStyles {
  /// Headings ///
  static TextStyle title01 = const TextStyle(
    fontFamily: 'Gluten',
    fontSize: AppFontSize.xxl,
    fontWeight: AppFontWeight.black,
    color: AppColors.textPrimary,
  );

  static TextStyle title02 = const TextStyle(
    fontFamily: 'Gluten',
    fontSize: AppFontSize.xl,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
  );

  static TextStyle title03 = const TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Texts ///
  static TextStyle text = const TextStyle(
    fontFamily: 'Geologica',
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.light,
    color: AppColors.textPrimary,
  );

  static TextStyle textBold = const TextStyle(
    fontFamily: 'Geologica',
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle textSmall = const TextStyle(
    fontFamily: 'Geologica',
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.light,
    color: AppColors.textPrimary,
  );

  static TextStyle textSmallBold = const TextStyle(
    fontFamily: 'Geologica',
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle textLabel = const TextStyle(
    fontFamily: 'Geologica',
    fontSize: AppFontSize.xs,
    fontWeight: AppFontWeight.light,
    fontStyle: FontStyle.italic,
    color: AppColors.textPrimary,
  );

  /// Numbers ///
  static TextStyle numberBig = const TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle numberSmall = const TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );
}
