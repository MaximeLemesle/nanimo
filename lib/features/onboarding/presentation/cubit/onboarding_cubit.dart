import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/monitoring/error_reporter.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/utils/vaccine_schedule.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

part 'onboarding_state.dart';

typedef PendingVaccine = ({String name, DateTime? lastDate, DateTime? nextDate, int recurrence});

class OnboardingCubit extends Cubit<OnboardingState> {
  final ReferentialRepository _referentialRepository;

  OnboardingCubit({
    required ReferentialRepository referentialRepository,
  })  : _referentialRepository = referentialRepository,
        super(const OnboardingState());

  void setPetName(String name) {
    emit(state.copyWith(petName: name));
  }

  Future<void> selectSpecies(String speciesId) async {
    if (state.petSpeciesId == speciesId) return;
    emit(state.copyWith(
      petSpeciesId: speciesId,
      clearRaceId: true,
      races: const [],
    ));

    /// Fetch the list of race from the species
    await _fetchRaces(speciesId);
  }

  void setRace(String raceId) {
    emit(state.copyWith(petRaceId: raceId));
  }

  void setGender(Gender gender) {
    emit(state.copyWith(gender: gender));
  }

  void setBirthdate(DateTime date) {
    emit(state.copyWith(birthdate: date));
  }

  void nextStep() {
    if (state.currentStep == 1 && state.canGoToStep2) {
      _trackStepCompleted(1);
      emit(state.copyWith(currentStep: 2));
    } else if (state.currentStep == 2 && state.canGoToStep3) {
      _trackStepCompleted(2);
      emit(state.copyWith(currentStep: 3));
    } else if (state.currentStep == 3 && state.canFinish) {
      _trackStepCompleted(3);
      emit(state.copyWith(currentStep: 4));
      _loadVaccineSuggestions();
    }
  }

  void _trackStepCompleted(int step) {
    analytics.capture(
      AnalyticsEvents.onboardingStepCompleted,
      properties: {AnalyticsProperties.step: step},
    );
  }

  void setVaccineName(String name) => emit(state.copyWith(vaccineName: name));

  void setVaccineDate(DateTime date) => emit(state.copyWith(vaccineDate: date));

  void setVaccineNext({int? months}) => emit(state.copyWith(
        vaccineMonths: months,
        clearVaccineMonths: months == null,
        vaccineNextUnknown: months == null,
      ));

  /// Closes the vaccine step: with the vaccine to create, or skipped.
  PendingVaccine? finishVaccineStep({required bool skip}) {
    final vaccine = skip ? null : state.pendingVaccine;
    analytics.capture(
      AnalyticsEvents.onboardingStepCompleted,
      properties: {AnalyticsProperties.step: 'vaccine', AnalyticsProperties.skipped: vaccine == null},
    );
    return vaccine;
  }

  /// Suggestions only: the field stays free when the list cannot load.
  Future<void> _loadVaccineSuggestions() async {
    final speciesId = state.petSpeciesId;
    if (speciesId == null || state.vaccineSuggestions.isNotEmpty) return;
    try {
      final vaccines = await _referentialRepository.fetchRecommendedVaccinesBySpecies(speciesId);
      if (isClosed) return;
      emit(state.copyWith(vaccineSuggestions: [for (final v in vaccines) v.name]));
    } catch (_) {}
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  /// Called once per opening of the creation flow, not on each species fetch.
  void trackStarted({required bool inApp}) {
    analytics.capture(
      AnalyticsEvents.onboardingStarted,
      properties: {
        AnalyticsProperties.source: inApp ? OnboardingSource.addPet : OnboardingSource.onboarding,
      },
    );
  }

  void reset() {
    emit(const OnboardingState());
  }

  /// Fetch the list of available species
  Future<void> fetchSpecies() async {
    if (state.speciesStatus == ReferentialStatus.loading || state.speciesStatus == ReferentialStatus.loaded) {
      return;
    }
    emit(state.copyWith(
      speciesStatus: ReferentialStatus.loading,
      clearSpeciesError: true,
    ));
    try {
      final list = await _referentialRepository.fetchSpecies();
      emit(state.copyWith(
        speciesStatus: ReferentialStatus.loaded,
        species: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        speciesStatus: ReferentialStatus.error,
        speciesError: 'Impossible de charger les espèces.',
      ));
    }
    await _loadPetIcons();
  }

  /// Loaded apart from the species: icons are cosmetic, and losing them must
  /// not cost the species keys every avatar falls back on.
  Future<void> _loadPetIcons() async {
    try {
      final icons = await _referentialRepository.fetchIcons();
      if (isClosed) return;
      emit(state.copyWith(icons: icons));
    } catch (e, st) {
      errorReporter.captureException(
        e,
        stackTrace: st,
        hint: 'fetchIcons failed, portraits fall back to the species icon',
      );
    }
  }

  Future<void> _fetchRaces(String speciesId) async {
    emit(state.copyWith(
      racesStatus: ReferentialStatus.loading,
      clearRacesError: true,
    ));
    try {
      final list = await _referentialRepository.fetchRacesBySpecies(speciesId);
      emit(state.copyWith(
        racesStatus: ReferentialStatus.loaded,
        races: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        racesStatus: ReferentialStatus.error,
        racesError: 'Impossible de charger les races.',
      ));
    }
  }

  Future<void> retryRaces() async {
    if (state.petSpeciesId != null) await _fetchRaces(state.petSpeciesId!);
  }
}
