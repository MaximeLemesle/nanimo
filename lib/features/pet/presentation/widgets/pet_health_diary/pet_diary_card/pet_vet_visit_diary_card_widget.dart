import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_edit_button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';

class PetVetVisitDiaryCardWidget extends StatelessWidget {
  final List<VetVisitModel> visits;

  const PetVetVisitDiaryCardWidget({super.key, required this.visits});

  @override
  Widget build(BuildContext context) {
    return PetDiaryCardWidget(
      title: 'Visites vétérinaires',
      children: [
        PetDiaryTableWidget(
          rows: [
            for (final visit in visits)
              PetDiaryRow(
                label: visit.title,
                subtitle: [
                  'Le ${DateFormatter.date(visit.visitedAt)}',
                  if (visit.vetName != null && visit.vetName!.isNotEmpty)
                    visit.vetName!,
                  if (visit.clinicName != null && visit.clinicName!.isNotEmpty)
                    visit.clinicName!,
                ].join(' - '),
                trailing: PetDiaryEditButtonWidget(
                  tooltip: 'Modifier la visite',
                  onPressed: () => _editVisit(context, visit),
                ),
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
                onSubmit: ({
                  required String title,
                  required DateTime visitedAt,
                  String? vetName,
                  String? clinicName,
                }) {
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

  /// Reuses the creation sheet with its `initial`, so both paths share validation and wording.
  void _editVisit(BuildContext context, VetVisitModel visit) {
    final cubit = context.read<PetDetailsCubit>();
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
