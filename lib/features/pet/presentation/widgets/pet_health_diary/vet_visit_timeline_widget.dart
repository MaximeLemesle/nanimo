import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/health_card_widget.dart';

/// Vet visits card: chronological timeline of visits plus an add action.
class VetVisitTimelineWidget extends StatelessWidget {
  final List<VetVisitModel> visits;
  final VoidCallback onAdd;

  const VetVisitTimelineWidget({
    super.key,
    required this.visits,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return HealthCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (visits.isEmpty)
            Text(
              'Aucune visite vétérinaire enregistrée pour le moment.',
              style: AppTextStyles.textSmall
                  .copyWith(color: AppColors.textSecondary),
            )
          else
            for (var i = 0; i < visits.length; i++) ...[
              if (i > 0)
                const Divider(
                    height: AppSpacing.lg, color: AppColors.backgroundStroke),
              _buildRow(visits[i]),
            ],
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: 'Ajouter une visite',
            type: ButtonType.secondary,
            iconPosition: ButtonIcon.left,
            icon: Icons.add,
            fullWidth: true,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(VetVisitModel visit) {
    final details = [
      'Le ${DateFormatter.date(visit.visitedAt)}',
      if (visit.vetName != null && visit.vetName!.isNotEmpty) visit.vetName!,
      if (visit.clinicName != null && visit.clinicName!.isNotEmpty)
        visit.clinicName!,
    ].join(' - ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(visit.title, style: AppTextStyles.textBold),
        const SizedBox(height: AppSpacing.xs),
        Text(
          details,
          style: AppTextStyles.textLabel.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
