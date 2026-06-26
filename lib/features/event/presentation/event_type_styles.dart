import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';

enum EventCardStyle { simple, soft, festive }

/// TODO: make this cleaner when style is defined
class EventTypeStyle {
  final Color accent;
  final Color surface;
  final IconData icon;
  final String iconAsset;
  final EventCardStyle cardStyle;

  const EventTypeStyle({
    required this.accent,
    required this.surface,
    required this.icon,
    required this.iconAsset,
    required this.cardStyle,
  });

  static const EventTypeStyle balade = EventTypeStyle(
    accent: AppColors.primary,
    surface: AppColors.backgroundSurface,
    icon: Icons.directions_walk,
    iconAsset: 'assets/icons/event_types/balade.png',
    cardStyle: EventCardStyle.simple,
  );

  static const EventTypeStyle calin = EventTypeStyle(
    accent: AppColors.secondary400,
    surface: AppColors.secondary50,
    icon: Icons.favorite,
    iconAsset: 'assets/icons/event_types/calin.png',
    cardStyle: EventCardStyle.soft,
  );

  static const EventTypeStyle anniversaire = EventTypeStyle(
    accent: AppColors.tertiary500,
    surface: AppColors.tertiary50,
    icon: Icons.cake,
    iconAsset: 'assets/icons/event_types/birthday.png',
    cardStyle: EventCardStyle.festive,
  );

  static const Map<String, EventTypeStyle> _byCode = {
    'balade': balade,
    'calin': calin,
    'anniversaire': anniversaire,
  };

  static EventTypeStyle fromCode(String? code) => _byCode[code] ?? balade;
}
