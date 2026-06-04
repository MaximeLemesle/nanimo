import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_font_weight.dart';

class AppTextStyles {
  /// Headings ///
  static TextStyle title01 = GoogleFonts.gluten(
    fontSize: AppFontSize.xxl,
    fontWeight: AppFontWeight.black,
    color: AppColors.textPrimary,
  );

  static TextStyle title02 = GoogleFonts.gluten(
    fontSize: AppFontSize.xl,
    fontWeight: AppFontWeight.extraBold,
    color: AppColors.textPrimary,
  );

  static TextStyle title03 = GoogleFonts.comfortaa(
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Texts ///
  static TextStyle text = GoogleFonts.geologica(
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.light,
    color: AppColors.textPrimary,
  );

  static TextStyle textBold = GoogleFonts.geologica(
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle textSmall = GoogleFonts.geologica(
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.light,
    color: AppColors.textPrimary,
  );

  static TextStyle textSmallBold = GoogleFonts.geologica(
    fontSize: AppFontSize.sm,
    fontWeight: AppFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle textLabel = GoogleFonts.geologica(
    fontSize: AppFontSize.xs,
    fontWeight: AppFontWeight.light,
    fontStyle: FontStyle.italic,
    color: AppColors.textPrimary,
  );

  /// Numbers ///
  static TextStyle numberBig = GoogleFonts.comfortaa(
    fontSize: AppFontSize.lg,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle numberSmall = GoogleFonts.comfortaa(
    fontSize: AppFontSize.md,
    fontWeight: AppFontWeight.bold,
    color: AppColors.textPrimary,
  );
}
