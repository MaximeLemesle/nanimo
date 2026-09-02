import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nanimo/config/theme/app_colors.dart';

/// Streamline icon names
class AppIcons {
  static const home = 'home';
  static const homeSolid = 'home-solid';
  static const openBook = 'open-book';
  static const openBookSolid = 'open-book-solid';
  static const pet = 'cat-1';
  static const add = 'add-1';
  static const logout = 'logout-1';
  static const settings = 'cog';
  static const user = 'user-circle-single';
  static const mail = 'mail-send-envelope';
  static const calendar = 'blank-calendar';
  static const vaccine = 'syringe';
  static const weight = 'justice-scale-1';
  static const notification = 'ringing-bell-notification';
  static const delete = 'recycle-bin-2';
  static const star = 'star-1';
  static const petPawSolid = 'pet-paw-solid';
  static const petPawSolid2 = 'pet-paw-solid-2';
  static const addCalendar = 'add-calendar';
  static const addSquare = 'add-square';
  static const crown = 'crown';
}

/// Renders a Streamline SVG from `assets/icons/ui/`.
class AppIconWidget extends StatelessWidget {
  final String name;
  final double size;
  final Color color;

  const AppIconWidget(
    this.name, {
    super.key,
    this.size = 24,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/ui/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
