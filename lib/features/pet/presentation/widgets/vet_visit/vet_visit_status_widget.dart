import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';

/// « À venir », « À compléter », then the document count once filled in.
class VetVisitStatusWidget extends StatelessWidget {
  final VetVisitModel visit;
  final DateTime? now;

  const VetVisitStatusWidget({super.key, required this.visit, this.now});

  @override
  Widget build(BuildContext context) {
    final at = now ?? DateTime.now();
    final badge = visit.isUpcoming(at)
        ? _badge('À venir', AppColors.tertiary100, AppColors.tertiary700)
        : visit.needsCompletion(at)
            ? _badge('À compléter', AppColors.secondary100, AppColors.secondary700)
            : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (visit.documentCount > 0) ...[
          Semantics(
            label: '${visit.documentCount} ${visit.documentCount > 1 ? 'documents' : 'document'}',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file_rounded, size: 18, color: AppColors.textSecondary),
                Text('${visit.documentCount}', style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (badge != null) const SizedBox(width: AppSpacing.sm),
        ],
        if (badge != null) badge,
      ],
    );
  }

  static Widget _badge(String label, Color background, Color foreground) {
    return RoundedBorderWidget(
      backgroundColor: background,
      fullWidth: false,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Text(label, style: AppTextStyles.textSmall.copyWith(color: foreground)),
    );
  }
}
