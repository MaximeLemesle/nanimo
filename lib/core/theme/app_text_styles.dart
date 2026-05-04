import 'package:flutter/material.dart';
import 'package:nanimo/core/theme/app_colors.dart';
import 'package:nanimo/core/theme/app_font_size.dart';
import 'package:nanimo/core/theme/app_font_weight.dart';

class AppTextStyles {
  static const String fontTitle = 'Gluten';
  static const String fontBody = 'Geologica';
  static const String fontNumber = 'Comfortaa';

  /// Headings ///
  static const TextStyle title01 = TextStyle(
    fontFamily: fontTitle,
    fontSize: AppFontSize.xxl,
    fontWeight: AppFontWeight.black,
    color: AppColors.textPrimary,
  );

  static const TextStyle title02 = TextStyle(
    fontFamily: fontTitle,
    fontSize: AppFontSize.xl,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
  );

  static const TextStyle title03 = TextStyle(
    fontFamily: fontBody,
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
  );

  /// Texts ///
  static const TextStyle text = TextStyle(
    fontFamily: fontBody,
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.light,
    color: AppColors.textPrimary,
  );

  static const TextStyle textBold = TextStyle(
    fontFamily: fontBody,
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static const TextStyle textSmall = TextStyle(
    fontFamily: fontBody,
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.light,
    color: AppColors.textPrimary,
  );

  static const TextStyle textSmallBold = TextStyle(
    fontFamily: fontBody,
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static const TextStyle textLabel = TextStyle(
    fontFamily: fontBody,
    fontSize: AppFontSize.xs,
    fontWeight: AppFontWeight.light,
    fontStyle: FontStyle.italic,
    color: AppColors.textPrimary,
  );

  /// Numbers ///
  static const TextStyle numberBig = TextStyle(
    fontFamily: fontNumber,
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle numberSmall = TextStyle(
    fontFamily: fontNumber,
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Buttons ///
}