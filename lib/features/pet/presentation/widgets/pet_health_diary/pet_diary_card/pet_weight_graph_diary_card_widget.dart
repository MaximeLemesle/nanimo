import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_edit_button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_selection_hint_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/weight_chart_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

class PetWeightGraphDiaryCardWidget extends StatefulWidget {
  final List<HealthDiaryWeightLogModel> weightLogs;

  /// Floor of the date picker of the weight sheet.
  final DateTime birthdate;

  /// The record is still read, nothing is written.
  final bool readOnly;

  const PetWeightGraphDiaryCardWidget({
    super.key,
    required this.weightLogs,
    required this.birthdate,
    this.readOnly = false,
  });

  @override
  State<PetWeightGraphDiaryCardWidget> createState() => _PetWeightGraphDiaryCardWidgetState();
}

class _PetWeightGraphDiaryCardWidgetState extends State<PetWeightGraphDiaryCardWidget> {
  bool _isSelecting = false;

  @override
  void didUpdateWidget(PetWeightGraphDiaryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Nothing left to pick.
    if (widget.weightLogs.isEmpty && _isSelecting) _isSelecting = false;
  }

  @override
  Widget build(BuildContext context) {
    return PetDiaryCardWidget(
      title: 'Évolution du poids',
      action: widget.weightLogs.isEmpty || widget.readOnly
          ? null
          : PetDiaryEditButtonWidget(
              isSelecting: _isSelecting,
              tooltip: _isSelecting ? 'Annuler la modification' : 'Modifier une pesée',
              onPressed: () => setState(() => _isSelecting = !_isSelecting),
            ),
      children: [
        WeightChartWidget(logs: widget.weightLogs),
        const SizedBox(height: AppSpacing.md),
        if (_isSelecting) ...[
          const PetDiarySelectionHintWidget(
            label: 'Choisis la pesée à modifier',
          ),

          /// The two-line summary carries no single log to pick, so the
          /// history takes its place while the section is armed.
          PetDiaryTableWidget(
            rows: [
              for (final log in widget.weightLogs.reversed)
                PetDiaryRow(
                  label: '${WeightFormatter.label(log.weight)} le ${DateFormatter.date(log.loggedAt)}',
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                  ),
                  onTap: () => _editWeightLog(context, log),
                ),
            ],
          ),
        ] else
          PetDiaryTableWidget(
            rows: [
              PetDiaryRow(
                label: 'Poids naissance',
                value: widget.weightLogs.isEmpty ? '—' : WeightFormatter.label(widget.weightLogs.first.weight),
              ),
              PetDiaryRow(
                label: 'Dernier poids',
                value: widget.weightLogs.isEmpty ? '—' : WeightFormatter.label(widget.weightLogs.last.weight),
              ),
            ],
          ),
        if (!widget.readOnly) ...[
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: 'Ajouter une pesée',
            icon: Icons.add,
            iconPosition: ButtonIcon.right,
            fullWidth: true,
            onPressed: () {
              BottomSheetWidget.show<void>(
                context,
                AddWeightBottomSheetWidget(
                  birthdate: widget.birthdate,
                  onSubmit: context.read<PetDetailsCubit>().addWeightLog,
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _editWeightLog(BuildContext context, HealthDiaryWeightLogModel log) {
    final cubit = context.read<PetDetailsCubit>();
    setState(() => _isSelecting = false);
    BottomSheetWidget.show<void>(
      context,
      AddWeightBottomSheetWidget(
        birthdate: widget.birthdate,
        initial: log,
        onDelete: () => cubit.deleteWeightLog(log.healthDiaryWeightLogId),
        onSubmit: (weight, loggedAt, {String? petId}) {
          cubit.updateWeightLog(
            HealthDiaryWeightLogModel(
              healthDiaryWeightLogId: log.healthDiaryWeightLogId,
              weight: weight,
              loggedAt: loggedAt,
              petId: log.petId,
            ),
          );
        },
      ),
    );
  }
}
