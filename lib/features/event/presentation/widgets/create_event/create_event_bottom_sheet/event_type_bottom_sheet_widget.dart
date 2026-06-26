import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/event_type_styles.dart';

class EventTypeBottomSheetWidget extends StatelessWidget {
  final List<EventTypeModel> types;
  final String? selectedTypeId;

  const EventTypeBottomSheetWidget({
    super.key,
    required this.types,
    required this.selectedTypeId,
  });

  /// Opens the sheet and resolves with the chosen event type id.
  static Future<String?> show(
    BuildContext context, {
    required List<EventTypeModel> types,
    required String? selectedTypeId,
  }) {
    return BottomSheetWidget.show<String>(
      context,
      EventTypeBottomSheetWidget(types: types, selectedTypeId: selectedTypeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Choisir un type',
      scrollable: true,
      children: [
        if (types.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              'Aucun type disponible pour le moment.',
              style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
            ),
          )
        else
          for (final type in types) _buildRow(context, type),
      ],
    );
  }

  Widget _buildRow(BuildContext context, EventTypeModel type) {
    final style = EventTypeStyle.fromCode(type.code);
    final isSelected = type.eventTypeId == selectedTypeId;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => Navigator.of(context).pop(type.eventTypeId),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected ? style.accent : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: style.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Image.asset(
                  style.iconAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(style.icon, color: style.accent, size: 22),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(type.name, style: AppTextStyles.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
