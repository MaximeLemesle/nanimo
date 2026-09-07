import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_edit_button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_selection_hint_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';

class PetVetVisitDiaryCardWidget extends StatefulWidget {
  final List<VetVisitModel> visits;

  const PetVetVisitDiaryCardWidget({super.key, required this.visits});

  @override
  State<PetVetVisitDiaryCardWidget> createState() => _PetVetVisitDiaryCardWidgetState();
}

class _PetVetVisitDiaryCardWidgetState extends State<PetVetVisitDiaryCardWidget> {
  bool _isSelecting = false;

  @override
  void didUpdateWidget(PetVetVisitDiaryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Nothing left to pick.
    if (widget.visits.isEmpty && _isSelecting) _isSelecting = false;
  }

  @override
  Widget build(BuildContext context) {
    return PetDiaryCardWidget(
      title: 'Visites vétérinaires',
      action: widget.visits.isEmpty
          ? null
          : PetDiaryEditButtonWidget(
              isSelecting: _isSelecting,
              tooltip: _isSelecting ? 'Annuler la modification' : 'Modifier une visite',
              onPressed: () => setState(() => _isSelecting = !_isSelecting),
            ),
      children: [
        if (_isSelecting) const PetDiarySelectionHintWidget(label: 'Choisis la visite à modifier'),
        PetDiaryTableWidget(
          rows: [
            for (final visit in widget.visits)
              PetDiaryRow(
                label: visit.title,
                subtitle: [
                  'Le ${DateFormatter.date(visit.visitedAt)}',
                  if (visit.vetName != null && visit.vetName!.isNotEmpty) visit.vetName!,
                  if (visit.clinicName != null && visit.clinicName!.isNotEmpty) visit.clinicName!,
                ].join(' - '),
                trailing: _isSelecting
                    ? const Icon(Icons.chevron_right_rounded, color: AppColors.primary)
                    : null,
                onTap: _isSelecting ? () => _editVisit(context, visit) : null,
              ),
          ],
          emptyLabel: 'Aucune visite vétérinaire enregistrée pour le moment.',
        ),
        const SizedBox(height: AppSpacing.md),
        ButtonWidget(
          label: 'Ajouter une visite',
          type: ButtonType.secondary,
          icon: Icons.add,
          iconPosition: ButtonIcon.left,
          fullWidth: true,
          onPressed: () {
            BottomSheetWidget.show<void>(
              context,
              AddVetVisitBottomSheetWidget(
                onSubmit: ({required String title, required DateTime visitedAt, String? vetName, String? clinicName}) {
                  context.read<PetDetailsCubit>().addVetVisit(
                        title: title,
                        visitedAt: visitedAt,
                        vetName: vetName,
                        clinicName: clinicName,
                      );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _editVisit(BuildContext context, VetVisitModel visit) {
    final cubit = context.read<PetDetailsCubit>();
    setState(() => _isSelecting = false);
    BottomSheetWidget.show<void>(
      context,
      AddVetVisitBottomSheetWidget(
        initial: visit,
        onSubmit: ({required String title, required DateTime visitedAt, String? vetName, String? clinicName}) {
          cubit.updateVetVisit(
            VetVisitModel(
              vetVisitId: visit.vetVisitId,
              title: title,
              visitedAt: visitedAt,
              vetName: vetName,
              clinicName: clinicName,
              petId: visit.petId,
            ),
          );
        },
      ),
    );
  }
}
