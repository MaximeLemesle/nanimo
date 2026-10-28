import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';

/// The vaccine sheets of the selected pet, shared by the pet page and the diary.
abstract final class VaccineSheets {
  static void add(BuildContext context, {required DateTime birthdate}) {
    final cubit = context.read<PetDetailsCubit>();
    BottomSheetWidget.show<void>(
      context,
      AddVaccineBottomSheetWidget(
        birthdate: birthdate,
        onSubmit: ({required String vaccineName, DateTime? lastDate, DateTime? nextDate, required int recurrence, String? petId}) {
          cubit.addVaccine(
            vaccineName: vaccineName,
            lastDate: lastDate,
            nextDate: nextDate,
            recurrence: recurrence,
          );
        },
      ),
    );
  }

  static void edit(BuildContext context, {required DateTime birthdate, required HealthDiaryVaccineModel vaccine}) {
    final cubit = context.read<PetDetailsCubit>();
    BottomSheetWidget.show<void>(
      context,
      AddVaccineBottomSheetWidget(
        birthdate: birthdate,
        initial: vaccine,
        onDelete: () => cubit.deleteVaccine(vaccine.healthDiaryVaccineId),
        onSubmit: ({required String vaccineName, DateTime? lastDate, DateTime? nextDate, required int recurrence, String? petId}) {
          cubit.updateVaccine(
            HealthDiaryVaccineModel(
              healthDiaryVaccineId: vaccine.healthDiaryVaccineId,
              vaccineName: vaccineName,
              lastDate: lastDate,
              nextDate: nextDate,
              recurrence: recurrence,
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
