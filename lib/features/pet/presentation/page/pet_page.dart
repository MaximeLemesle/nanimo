import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_card/pet_card_item_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_card/pet_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_card/pet_health_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_park_header_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_card/pet_weight_card_widget.dart';

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  bool isTyphusDone = false;
  bool isCoryzaDone = false;
  bool isRageDone = false;
  bool isLeucoseDone = false;

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
            padding: EdgeInsets.zero,
            children: [
              PetParkHeaderWidget(
                pets: state.pets,
                selectedPetId: state.selectedPetId,
                iconsKey: state.iconsKey,
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
                            value: _genderLabel(pet.gender),
                          ),
                          PetCardItemWidget(
                            label: 'Poids',
                            value: state.latestWeight == null
                                ? '—'
                                : '${state.latestWeight?.toStringAsFixed(1).replaceAll('.', ',')} kg',
                          ),
                        ],
                      ),

                      /// Weight tracker card
                      PetWeightCardWidget(
                        logs: state.weightLogs,
                        onWeightSubmitted: (weight) => context
                            .read<PetDetailsCubit>()
                            .addWeightLog(weight),
                      ),

                      /// Health info card
                      PetHealthCardWidget(
                        diary: state.diary,
                        onFillPressed: () =>
                            context.push(RouteNames.healthDiary),
                      ),

                      /// Vaccines card
                      PetCardWidget(
                        label: 'Liste des vaccins',
                        backgroundColor: AppColors.backgroundSecondary,
                        isColumn: true,
                        items: [
                          PetCardItemWidget(
                            label: 'Obligatoire',
                            value: 'Typhus félin',
                            showCheckbox: true,
                            isChecked: isTyphusDone,
                            onCheckChanged: (value) =>
                                setState(() => isTyphusDone = value ?? false),
                          ),
                          PetCardItemWidget(
                            label: 'Obligatoire',
                            value: 'Coryza',
                            showCheckbox: true,
                            isChecked: isCoryzaDone,
                            onCheckChanged: (value) =>
                                setState(() => isCoryzaDone = value ?? false),
                          ),
                          PetCardItemWidget(
                            label: 'Recommandé',
                            value: 'Rage',
                            showCheckbox: true,
                            isChecked: isRageDone,
                            onCheckChanged: (value) =>
                                setState(() => isRageDone = value ?? false),
                          ),
                          PetCardItemWidget(
                            label: 'Optionnel',
                            value: 'Leucose féline',
                            showCheckbox: true,
                            isChecked: isLeucoseDone,
                            onCheckChanged: (value) =>
                                setState(() => isLeucoseDone = value ?? false),
                          ),
                        ],
                      ),

                      ButtonWidget(
                        label: 'Voir le carnet de santé',
                        fullWidth: true,
                        onPressed: () => context.push(RouteNames.healthDiary),
                      ),
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
