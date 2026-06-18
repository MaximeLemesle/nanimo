import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/add_vaccine_modal_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/add_vet_visit_modal_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/edit_health_diary_modal_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/health_summary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/vaccine_list_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/vet_visit_timeline_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/weight_chart_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_card/pet_card_modal/update_weight_modal_widget.dart';

class PetHealthDiaryPage extends StatelessWidget {
  const PetHealthDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PetDetailsCubit, PetDetailsState>(
      listenWhen: (previous, current) =>
          previous.error != current.error && current.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(state.error!)));
        context.read<PetDetailsCubit>().clearError();
      },
      builder: (context, state) {
        final pet = state.selectedPet;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text('Carnet de santé', style: AppTextStyles.title02),
          ),
          body: pet == null
              ? Center(child: Text('Aucun animal', style: AppTextStyles.text))
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _section(
                      'Récapitulatif',
                      HealthSummaryCardWidget(
                        rows: _summaryRows(state, pet),
                        onEdit: () => _openDiaryModal(context, state.diary),
                      ),
                    ),
                    _section(
                      'Vaccins',
                      VaccineListWidget(
                        vaccines: state.vaccines,
                        onAdd: () => _openVaccineModal(context),
                        onTapVaccine: (v) => _openVaccineModal(context, v),
                      ),
                    ),
                    _section(
                      'Visites vétérinaires',
                      VetVisitTimelineWidget(
                        visits: state.vetVisits,
                        onAdd: () => _openVetVisitModal(context),
                      ),
                    ),
                    _section(
                      'Évolution du poids',
                      WeightChartCardWidget(
                        logs: state.weightLogs,
                        onUpdate: () => _openWeightModal(context),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ButtonWidget(
                      label: 'Exporter en PDF',
                      icon: Icons.download,
                      iconPosition: ButtonIcon.right,
                      fullWidth: true,
                      state: ButtonState.disabled,
                      onPressed: null,
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _section(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.textSmallBold
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }

  List<({String label, String value})> _summaryRows(
    PetDetailsState state,
    PetModel pet,
  ) {
    final diary = state.diary;
    final weight = state.weightLogs.isEmpty
        ? '—'
        : '${state.weightLogs.last.weight.toStringAsFixed(1).replaceAll('.', ',')} kg';
    return [
      (label: 'Espèce', value: state.speciesNameById[pet.petSpeciesId] ?? '—'),
      (label: 'Race', value: state.raceName ?? '—'),
      (label: 'Genre', value: _genderLabel(pet.gender)),
      (label: 'Âge', value: DateFormatter.ageDetailed(pet.birthdate)),
      (label: 'Poids', value: weight),
      (
        label: 'Numéro de puce',
        value: (diary?.isChipped == true && diary?.chipNumber != null)
            ? diary!.chipNumber!
            : '—',
      ),
      (
        label: 'Stérilisée',
        value: diary?.isSterilized == null
            ? '—'
            : (diary!.isSterilized! ? 'Oui' : 'Non'),
      ),
    ];
  }

  void _openDiaryModal(BuildContext context, HealthDiaryModel? diary) {
    final cubit = context.read<PetDetailsCubit>();
    _showSheet(
      context,
      EditHealthDiaryModalWidget(
        diary: diary,
        onSubmit: ({
          required bool isSterilized,
          required bool isChipped,
          String? chipNumber,
          DateTime? lastDeworming,
          DateTime? lastVetAppointment,
        }) {
          cubit.updateDiary(
            isSterilized: isSterilized,
            isChipped: isChipped,
            chipNumber: chipNumber,
            lastDeworming: lastDeworming,
            lastVetAppointment: lastVetAppointment,
          );
        },
      ),
    );
  }

  void _openVaccineModal(
    BuildContext context, [
    HealthDiaryVaccineModel? existing,
  ]) {
    final cubit = context.read<PetDetailsCubit>();
    _showSheet(
      context,
      AddVaccineModalWidget(
        initial: existing,
        onSubmit: ({
          required String vaccineName,
          required DateTime lastDate,
          required DateTime nextDate,
        }) {
          if (existing == null) {
            cubit.addVaccine(
              vaccineName: vaccineName,
              lastDate: lastDate,
              nextDate: nextDate,
            );
          } else {
            cubit.updateVaccine(
              HealthDiaryVaccineModel(
                healthDiaryVaccineId: existing.healthDiaryVaccineId,
                vaccineName: vaccineName,
                lastDate: lastDate,
                nextDate: nextDate,
                recurrence: existing.recurrence,
                doseNumber: existing.doseNumber,
                totalDoseNumber: existing.totalDoseNumber,
                healthDiaryId: existing.healthDiaryId,
              ),
            );
          }
        },
      ),
    );
  }

  void _openVetVisitModal(BuildContext context) {
    final cubit = context.read<PetDetailsCubit>();
    _showSheet(
      context,
      AddVetVisitModalWidget(
        onSubmit: ({
          required String title,
          required DateTime visitedAt,
          String? vetName,
          String? clinicName,
        }) {
          cubit.addVetVisit(
            title: title,
            visitedAt: visitedAt,
            vetName: vetName,
            clinicName: clinicName,
          );
        },
      ),
    );
  }

  void _openWeightModal(BuildContext context) {
    final cubit = context.read<PetDetailsCubit>();
    _showSheet(
      context,
      UpdateWeightModalWidget(onSubmit: cubit.addWeightLog),
    );
  }

  void _showSheet(BuildContext context, Widget child) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => child,
    );
  }

  String _genderLabel(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Mâle';
      case Gender.female:
        return 'Femelle';
      case Gender.unknown:
        return 'Inconnu';
    }
  }
}
