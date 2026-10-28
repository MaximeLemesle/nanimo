import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/deworming_bottom_sheet_widget.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_article_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_birthday_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_first_steps_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_header_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_memory_polaroid_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_pet_list_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_vet_visit_card_widget.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/presentation/pet_lock.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final creation = context.read<PetCreationCubit?>();
    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading ||
                (state.pets.isEmpty && _isPetOnItsWay(context))) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.pets.isEmpty) {
              return const Center(child: Text('Aucun animal pour le moment'));
            }

            final now = DateTime.now();
            final anniversary = state.anniversaryEvent(now: now);
            final memory = anniversary ?? state.latestEvent;

            // Not a lazy ListView: a card scrolled off would be rebuilt empty
            // on the way back up and make the page jump (NAN-121).
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.bottomBarInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeaderWidget(
                    userName: state.userName,
                    now: now,
                    onSettingsTap: () => context.push(RouteNames.settings),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  for (final birthday in state.birthdays(now: now))
                    HomeBirthdayCardWidget(
                      key: ValueKey('birthday:${birthday.pet.petId}'),
                      petId: birthday.pet.petId,
                      petName: birthday.pet.petName,
                      age: birthday.age,
                      portrait: state.portraits[birthday.pet.petId],
                      now: now,
                      onAddMemory: () {
                        _trackCard(HomeCard.birthday);
                        context.push(Uri(
                                path: RouteNames.createEvent,
                                queryParameters: {'petId': birthday.pet.petId})
                            .toString());
                      },
                    ),

                  if (state.pets.isNotEmpty)
                    HomeFirstStepsCardWidget(
                      petName: state.pets.first.petName,
                      hasDiary: state.diaries.any(
                          (diary) => diary.petId == state.pets.first.petId),
                      hasMemory: state.events.isNotEmpty,
                      onCompleteDiary: () =>
                          _completeDiary(context, state.pets.first.petId),
                      onAddMemory: () => context.push(RouteNames.createEvent),
                      onCompleted: () => _onFirstStepsCompleted(context),
                    ),

                  /// Display the last memory or the remember "X years ago"
                  if (memory != null) ...[
                    HomeMemoryPolaroidWidget(
                      event: memory,
                      yearsAgo: anniversary == null
                          ? null
                          : state.yearsAgo(anniversary, now: now),
                      imagePaths:
                          state.imagePathsByEvent[memory.eventId] ?? const [],
                      urlResolver: context.read<HomeCubit>().imageUrl,
                      onTap: () {
                        _trackCard(HomeCard.memory);
                        JournalEventDetailBottomSheetWidget.show(
                          context,
                          event: memory,
                          onEdit: () => context.push(
                              '${RouteNames.editEvent}/${memory.eventId}'),
                        );
                      },
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
                      _trackCard(HomeCard.pet);
                      context.read<PetDetailsCubit>().selectPet(petId);
                      context.push(RouteNames.pet);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  /// Booked vet appointments
                  HomeVetVisitCardWidget(
                    visits: state.upcomingVetVisits(now: now),
                    lastVisits: state.lastVetVisits(now: now),
                    portraits: state.portraits,
                    now: now,
                    onVisitTap: (petId) {
                      _trackCard(HomeCard.vetVisit);
                      context.read<PetDetailsCubit>().selectPet(petId);
                      context.push(RouteNames.healthDiary);
                    },
                    onAddPressed: () => _addVetVisit(context, state),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  /// Boosters and dewormings of the user's pets
                  HomeHealthCardWidget(
                    alerts: state.vaccineAlerts(now: now),
                    dewormings: state.dewormingAlerts(now: now),
                    petsWithoutDeworming: state.petsWithoutDeworming,
                    onDewormingTap: (petId) =>
                        _editDeworming(context, state, petId),
                    onDewormingDone: (petId) =>
                        _markDewormed(context, state, petId),
                    lastVaccinations: state.lastVaccinations(now: now),
                    portraits: state.portraits,
                    now: now,
                    onAlertTap: (petId) {
                      _trackCard(HomeCard.health);
                      context.read<PetDetailsCubit>().selectPet(petId);
                      context.push(RouteNames.healthDiary);
                    },
                    onAddPressed: () => _addVaccine(context, state),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  /// Display the latest article
                  HomeArticleCardWidget(article: state.article),
                ],
              ),
            );
          },
        ),
      ),
    );
    if (creation == null) return scaffold;

    /// Releases the loader once the onboarding pet has reached the screen,
    /// whichever of the cache and the creation lands last.
    void release() {
      if (context.read<HomeCubit>().state.pets.isNotEmpty) creation.petShown();
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) => previous.pets != current.pets,
          listener: (_, __) => release(),
        ),
        BlocListener<PetCreationCubit, PetCreationState>(
          bloc: creation,
          listenWhen: (previous, current) =>
              current.awaitedPetId != null &&
              previous.awaitedPetId != current.awaitedPetId,
          listener: (_, __) => release(),
        ),
      ],
      child: scaffold,
    );
  }

  void _trackCard(String card) {
    analytics.capture(AnalyticsEvents.homeCardTapped,
        properties: {AnalyticsProperties.card: card});
  }

  /// The trial is offered once the first steps are all done, after the confetti.
  static const _paywallDelay = Duration(seconds: 3);

  Future<void> _onFirstStepsCompleted(BuildContext context) async {
    HomeFirstStepsCardWidget.celebrate(context);
    await Future<void>.delayed(_paywallDelay);
    if (!context.mounted) return;
    if (!QuotaUpsell.offersUpgrade(context.read<SubscriptionCubit>().state)) {
      return;
    }
    QuotaUpsell.openPaywall(context, PaywallTrigger.firstSteps);
  }

  /// After signup the home shows before the onboarding pet is written.
  bool _isPetOnItsWay(BuildContext context) {
    final creation = context.read<PetCreationCubit?>();
    if (creation == null) return false;
    return context.watch<PetCreationCubit>().state.isPetOnItsWay;
  }

  /// NAN-116: the guided diary, which ends back on the home.
  void _completeDiary(BuildContext context, String petId) =>
      context.push('${RouteNames.healthDiaryWizard}/$petId');

  void _addVaccine(BuildContext context, HomeState state) {
    final petDetails = context.read<PetDetailsCubit>();
    BottomSheetWidget.show<void>(
      context,
      AddVaccineBottomSheetWidget(
        pets: state.pets,
        portraits: state.portraits,
        initialPetId: petDetails.state.selectedPetId ?? state.pets.first.petId,
        birthdate: state.pets.first.birthdate,
        onSubmit: ({
          required String vaccineName,
          DateTime? lastDate,
          DateTime? nextDate,
          required int recurrence,
          String? petId,
        }) {
          petDetails.addVaccine(
            vaccineName: vaccineName,
            lastDate: lastDate,
            nextDate: nextDate,
            recurrence: recurrence,
            petId: petId,
          );
        },
      ),
    );
  }

  void _editDeworming(BuildContext context, HomeState state, String petId) {
    final pet = state.pets.firstWhere((pet) => pet.petId == petId);
    final diary =
        state.diaries.where((diary) => diary.petId == petId).firstOrNull;
    final petDetails = context.read<PetDetailsCubit>();
    BottomSheetWidget.show<void>(
      context,
      DewormingBottomSheetWidget(
        petName: pet.petName,
        lastDeworming: diary?.lastDeworming,
        intervalMonths: diary?.dewormingInterval ??
            HealthDiaryModel.defaultDewormingIntervalMonths,
        onSubmit: (
                {required DateTime lastDeworming,
                required int intervalMonths}) =>
            petDetails.recordDeworming(petId,
                lastDeworming: lastDeworming, intervalMonths: intervalMonths),
      ),
    );
  }

  /// One tap, with an undo: the next one is counted from today.
  Future<void> _markDewormed(
      BuildContext context, HomeState state, String petId) async {
    final pet = state.pets.firstWhere((pet) => pet.petId == petId);
    final petDetails = context.read<PetDetailsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final now = DateTime.now();
    final previous = await petDetails.recordDeworming(petId,
        lastDeworming: DateTime(now.year, now.month, now.day));
    if (previous == null) return;
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text('Vermifuge de ${pet.petName} noté'),
        persist: false,
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () => petDetails.recordDeworming(petId,
              lastDeworming: previous.lastDeworming),
        ),
      ));
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
