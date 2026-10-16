import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

/// Explains why before the one-shot system prompt (NAN-107).
class NotificationPrimingSheet extends StatelessWidget {
  final PrimingOffer offer;

  /// Pops with true for "Oui", false for "Plus tard"; a swipe pops with null.
  const NotificationPrimingSheet({super.key, required this.offer});

  static String question(PrimingOffer offer) {
    final date = DateFormatter.date(offer.dueDate).substring(0, 5);
    return offer.isVetVisit
        ? 'On te prévient la veille de la visite de ${offer.petName} du $date ?'
        : 'On te prévient avant le rappel de ${offer.petName} du $date ?';
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Activer les rappels',
      action: Column(
        children: [
          ButtonWidget(
            label: 'Oui, préviens-moi',
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: AppSpacing.sm),
          ButtonWidget(
            label: 'Plus tard',
            type: ButtonType.secondary,
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      children: [
        Text(question(offer), style: AppTextStyles.textBold),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Une notification, rien de plus. Tu peux les couper à tout moment dans les paramètres.',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
