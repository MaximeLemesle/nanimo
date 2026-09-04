import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/gender_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_item_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card/pet_health_info_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card/pet_health_onboarding_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_park_header_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card/pet_weight_card_widget.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

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
        if (state.status == PetDetailsStatus.loading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final pet = state.selectedPet;
        if (pet == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text('Aucun animal', style: AppTextStyles.text),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.bottomBarInset),
            children: [
              PetParkHeaderWidget(
                pets: state.pets,
                selectedPetId: state.selectedPetId,
                portraits: state.portraits,
                onSelect: (id) => context.read<PetDetailsCubit>().selectPet(id),
              ),
              Transform.translate(
                offset: const Offset(0, -AppRadius.lg),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    spacing: AppSpacing.lg,
                    children: [
                      /// Pet name + age
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              pet.petName,
                              style: AppTextStyles.title01,
                            ),
                          ),
                          Text(
                            DateFormatter.age(pet.birthdate),
                            style: AppTextStyles.numberBig,
                          ),
                        ],
                      ),

                      /// Identity card
                      PetCardWidget(
                        label: 'Identité',
                        items: [
                          PetCardItemWidget(
                            label: 'Espèce',
                            value:
                                state.speciesNameById[pet.petSpeciesId] ?? '—',
                          ),
                          PetCardItemWidget(
                            label: 'Race',
                            value: state.raceName ?? '—',
                          ),
                          PetCardItemWidget(
                            label: 'Genre',
                            value: GenderFormatter.label(pet.gender),
                          ),
                          PetCardItemWidget(
                            label: 'Poids',
                            value: state.latestWeight == null
                                ? '—'
                                : '${state.latestWeight?.toStringAsFixed(1).replaceAll('.', ',')} kg',
                          ),
                        ],
                      ),

                      if (!state.hasHealthData)

                        /// Display onboarding card if no health data
                        PetHealthOnboardingCardWidget(
                          onFillPressed: () {
                            BottomSheetWidget.show<void>(
                              context,
                              CreateHealthDiaryBottomSheetWidget(
                                petName: pet.petName,
                                birthdate: pet.birthdate,
                                recommendedVaccines: state.recommendedVaccines,
                                onSubmit: ({
                                  double? birthWeight,
                                  DateTime? birthWeightDate,
                                  bool? isSterilized,
                                  bool? isChipped,
                                  String? chipNumber,
                                  DateTime? lastDeworming,
                                  required List<VaccineEntry> vaccines,
                                  required List<VetVisitEntry> vetVisits,
                                }) {
                                  context
                                      .read<PetDetailsCubit>()
                                      .createHealthDiary(
                                        birthWeight: birthWeight,
                                        birthWeightDate: birthWeightDate,
                                        isSterilized: isSterilized,
                                        isChipped: isChipped,
                                        chipNumber: chipNumber,
                                        lastDeworming: lastDeworming,
                                        vaccines: vaccines,
                                        vetVisits: vetVisits,
                                      );
                                  context.push(RouteNames.healthDiary);
                                },
                              ),
                            );
                          },
                        )
                      else ...[
                        /// Weight tracker card
                        PetWeightCardWidget(
                          logs: state.weightLogs,
                          onWeightSubmitted: (weight, loggedAt, {petId}) =>
                              context.read<PetDetailsCubit>().addWeightLog(
                                    weight,
                                    loggedAt,
                                    petId: petId,
                                  ),
                        ),

                        /// Health info card
                        PetHealthInfoCardWidget(
                          diary: state.diary,
                          onFillPressed: () =>
                              context.push(RouteNames.healthDiary),
                        ),

                        /// Vaccines card
                        PetCardWidget(
                          label: 'Liste des vaccins',
                          backgroundColor: AppColors.backgroundSecondary,
                          isColumn: true,
                          items: state.vaccines.isEmpty
                              ? [
                                  PetCardItemWidget(
                                    label:
                                        'Aucun vaccin enregistré pour le moment',
                                    value: '—',
                                  )
                                ]
                              : state.vaccines
                                  .map(
                                    (vaccine) => PetCardItemWidget(
                                      label:
                                          'Prochain rappel : ${DateFormatter.date(vaccine.nextDate)}',
                                      value: vaccine.vaccineName,
                                    ),
                                  )
                                  .toList(),
                        ),

                        ButtonWidget(
                          label: 'Voir le carnet de santé',
                          fullWidth: true,
                          onPressed: () => context.push(RouteNames.healthDiary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
