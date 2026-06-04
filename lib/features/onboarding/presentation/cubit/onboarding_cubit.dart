import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

part 'onboarding_state.dart';

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
      emit(state.copyWith(currentStep: 2));
    } else if (state.currentStep == 2 && state.canGoToStep3) {
      emit(state.copyWith(currentStep: 3));
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void reset() {
    emit(const OnboardingState());
  }

  /// Fetch the list of available species
  Future<void> fetchSpecies() async {
    if (state.speciesStatus == ReferentialStatus.loading ||
        state.speciesStatus == ReferentialStatus.loaded) {
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
