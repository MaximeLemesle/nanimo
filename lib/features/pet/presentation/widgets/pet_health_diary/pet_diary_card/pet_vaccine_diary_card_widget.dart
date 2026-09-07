import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_edit_button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_selection_hint_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/vaccine_status_badge_widget.dart';

class PetVaccineDiaryCardWidget extends StatefulWidget {
  final List<HealthDiaryVaccineModel> vaccines;

  const PetVaccineDiaryCardWidget({super.key, required this.vaccines});

  @override
  State<PetVaccineDiaryCardWidget> createState() => _PetVaccineDiaryCardWidgetState();
}

class _PetVaccineDiaryCardWidgetState extends State<PetVaccineDiaryCardWidget> {
  bool _isSelecting = false;

  @override
  void didUpdateWidget(PetVaccineDiaryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Nothing left to pick.
    if (widget.vaccines.isEmpty && _isSelecting) _isSelecting = false;
  }

  @override
  Widget build(BuildContext context) {
    return PetDiaryCardWidget(
      title: 'Vaccins',
      action: widget.vaccines.isEmpty
          ? null
          : PetDiaryEditButtonWidget(
              isSelecting: _isSelecting,
              tooltip: _isSelecting ? 'Annuler la modification' : 'Modifier un vaccin',
              onPressed: () => setState(() => _isSelecting = !_isSelecting),
            ),
      children: [
        if (_isSelecting) const PetDiarySelectionHintWidget(label: 'Choisis le vaccin à modifier'),
        PetDiaryTableWidget(
          rows: [
            for (final vaccine in widget.vaccines)
              PetDiaryRow(
                label: vaccine.vaccineName,
                subtitle: vaccineStatusFor(vaccine.nextDate) == VaccineStatus.done
                    ? 'Dernier rappel le ${DateFormatter.date(vaccine.lastDate)}'
                    : 'Prochain rappel le ${DateFormatter.date(vaccine.nextDate)}',

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VaccineStatusBadgeWidget(nextDate: vaccine.nextDate),
                    if (_isSelecting) ...[
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                    ],
                  ],
                ),
                onTap: _isSelecting ? () => _editVaccine(context, vaccine) : null,
              ),
          ],
          emptyLabel: 'Aucun vaccin enregistré pour le moment.',
        ),
        const SizedBox(height: AppSpacing.md),
        ButtonWidget(
          label: 'Ajouter un vaccin',
          type: ButtonType.secondary,
          icon: Icons.add,
          iconPosition: ButtonIcon.left,
          fullWidth: true,
          onPressed: () {
            BottomSheetWidget.show<void>(
              context,
              AddVaccineBottomSheetWidget(
                onSubmit: ({required String vaccineName, required DateTime lastDate, required DateTime nextDate}) {
                  context.read<PetDetailsCubit>().addVaccine(
                        vaccineName: vaccineName,
                        lastDate: lastDate,
                        nextDate: nextDate,
                      );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _editVaccine(BuildContext context, HealthDiaryVaccineModel vaccine) {
    final cubit = context.read<PetDetailsCubit>();
    setState(() => _isSelecting = false);
    BottomSheetWidget.show<void>(
      context,
      AddVaccineBottomSheetWidget(
        initial: vaccine,
        onSubmit: ({required String vaccineName, required DateTime lastDate, required DateTime nextDate}) {
          cubit.updateVaccine(
            HealthDiaryVaccineModel(
              healthDiaryVaccineId: vaccine.healthDiaryVaccineId,
              vaccineName: vaccineName,
              lastDate: lastDate,
              nextDate: nextDate,
              recurrence: vaccine.recurrence,
              doseNumber: vaccine.doseNumber,
              totalDoseNumber: vaccine.totalDoseNumber,
              healthDiaryId: vaccine.healthDiaryId,
            ),
          );
        },
      ),
    );
  }
}
