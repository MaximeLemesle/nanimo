import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

class JournalEmptyStateWidget extends StatelessWidget {
  static const message = "Aucun moment n'est disponible";
  static const guidedMessage = 'Garde ici les moments partagés avec ton animal : une balade, une première fois, une photo.';

  /// Set only when the journal is truly empty, not narrowed by a filter.
  final VoidCallback? onAdd;

  const JournalEmptyStateWidget({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final onAdd = this.onAdd;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              onAdd == null ? message : guidedMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
            ),
            if (onAdd != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ButtonWidget(
                label: 'Ajouter un souvenir',
                icon: Icons.add,
                iconPosition: ButtonIcon.left,
                onPressed: onAdd,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
