import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_summary_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_vaccine_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_vet_visit_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_weight_graph_diary_card_widget.dart';

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
            title: Text('Carnet de santé', style: AppTextStyles.title02),
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              /// Summary health info card
              PetSummaryDiaryCardWidget(
                pet: state.selectedPet!,
                speciesName: state.speciesNameById[pet?.petSpeciesId] ?? '—',
                raceName: state.raceName ?? '—',
                weightLogs: state.weightLogs,
                diary: state.diary,
              ),

              const SizedBox(height: AppSpacing.lg),

              /// Vaccine list card
              PetVaccineDiaryCardWidget(
                vaccines: state.vaccines,
              ),

              const SizedBox(height: AppSpacing.lg),

              /// Vet visit recap card
              PetVetVisitDiaryCardWidget(
                visits: state.vetVisits,
              ),

              const SizedBox(height: AppSpacing.lg),

              /// Pet weight card
              PetWeightGraphDiaryCardWidget(
                weightLogs: state.weightLogs,
              ),

              const SizedBox(height: AppSpacing.lg),

              /// Disable for now
              // ButtonWidget(
              //   label: 'Exporter en PDF',
              //   icon: Icons.download,
              //   iconPosition: ButtonIcon.right,
              //   fullWidth: true,
              //   state: ButtonState.disabled,
              //   onPressed: null,
              // ),
            ],
          ),
        );
      },
    );
  }
}
