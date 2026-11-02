import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/vet_visit_status_widget.dart';

/// A visit in the timeline: never a polaroid, its documents stay out of sight.
class JournalVetVisitCardWidget extends StatelessWidget {
  final VetVisitModel visit;
  final String? petName;
  final VoidCallback onTap;

  const JournalVetVisitCardWidget({
    super.key,
    required this.visit,
    required this.onTap,
    this.petName,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      'Visite véto',
      if (petName != null) petName!,
      DateFormatter.date(visit.visitedAt),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: RoundedBorderWidget(
        backgroundColor: AppColors.backgroundSurface,
        borderColor: AppColors.backgroundStroke,
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: AppColors.primary100, shape: BoxShape.circle),
              child: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(visit.title, style: AppTextStyles.textBold, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            VetVisitStatusWidget(visit: visit),
          ],
        ),
      ),
    );
  }
}
