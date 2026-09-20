import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_article_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_header_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_memory_polaroid_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_pet_list_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_vet_visit_card_widget.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/presentation/pet_lock.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.pets.isEmpty) {
              return const Center(child: Text('Aucun animal pour le moment'));
            }

            final now = DateTime.now();
            final anniversary = state.anniversaryEvent(now: now);
            final memory = anniversary ?? state.latestEvent;

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.bottomBarInset,
              ),
              children: [
                HomeHeaderWidget(
                  userName: state.userName,
                  now: now,
                  onSettingsTap: () => context.push(RouteNames.settings),
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Display the last memory or the remember "X years ago"
                if (memory != null) ...[
                  HomeMemoryPolaroidWidget(
                    event: memory,
                    yearsAgo: anniversary == null ? null : state.yearsAgo(anniversary, now: now),
                    imagePaths: state.imagePathsByEvent[memory.eventId] ?? const [],
                    urlResolver: context.read<HomeCubit>().imageUrl,
                    onTap: () => JournalEventDetailBottomSheetWidget.show(
                      context,
                      event: memory,
                      onEdit: () => context.push('${RouteNames.editEvent}/${memory.eventId}'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                /// List of the user's pets
                HomePetListWidget(
                  pets: state.pets,
                  portraits: state.portraits,
                  lockedPetIds: PetLock.lockedPetIds(
                    state.pets,
                    context.watch<SubscriptionCubit>().state,
                  ),
                  onPetTap: (petId) {
                    context.read<PetDetailsCubit>().selectPet(petId);
                    context.push(RouteNames.pet);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Booked vet appointments
                HomeVetVisitCardWidget(
                  visits: state.upcomingVetVisits(now: now),
                  portraits: state.portraits,
                  now: now,
                  onVisitTap: (petId) {
                    context.read<PetDetailsCubit>().selectPet(petId);
                    context.push(RouteNames.healthDiary);
                  },
                  onAddPressed: () => _addVetVisit(context, state),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                /// List of vaccine alerts for the user's pets
                HomeHealthCardWidget(
                  alerts: state.vaccineAlerts(now: now),
                  portraits: state.portraits,
                  onAlertTap: (petId) {
                    context.read<PetDetailsCubit>().selectPet(petId);
                    context.push(RouteNames.healthDiary);
                  },
                  onAddPressed: () => _addVaccine(context, state),
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Display the latest article
                const HomeArticleCardWidget(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// The home is a multi-animal screen, so the sheet carries its own selector.
  void _addVaccine(BuildContext context, HomeState state) {
    final petDetails = context.read<PetDetailsCubit>();
    BottomSheetWidget.show<void>(
      context,
      AddVaccineBottomSheetWidget(
        pets: state.pets,
        portraits: state.portraits,
        initialPetId: petDetails.state.selectedPetId ?? state.pets.first.petId,
        birthdate: state.pets.first.birthdate,
        upcomingOnly: true,
        onSubmit: ({
          required String vaccineName,
          DateTime? lastDate,
          required DateTime nextDate,
          String? petId,
        }) {
          petDetails.addVaccine(
            vaccineName: vaccineName,
            lastDate: lastDate,
            nextDate: nextDate,
            petId: petId,
          );
        },
      ),
    );
  }

  /// The home is a multi-animal screen, so the sheet carries its own selector.
  void _addVetVisit(BuildContext context, HomeState state) {
    final petDetails = context.read<PetDetailsCubit>();
    BottomSheetWidget.show<void>(
      context,
      AddVetVisitBottomSheetWidget(
        pets: state.pets,
        portraits: state.portraits,
        initialPetId: petDetails.state.selectedPetId ?? state.pets.first.petId,
        birthdate: state.pets.first.birthdate,
        upcomingOnly: true,
        onSubmit: ({
          required String title,
          required DateTime visitedAt,
          String? vetName,
          String? clinicName,
          String? petId,
        }) {
          petDetails.addVetVisit(
            title: title,
            visitedAt: visitedAt,
            vetName: vetName,
            clinicName: clinicName,
            petId: petId,
          );
        },
      ),
    );
  }
}
