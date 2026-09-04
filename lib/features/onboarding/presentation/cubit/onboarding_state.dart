part of 'onboarding_cubit.dart';

enum ReferentialStatus { idle, loading, loaded, error }

class OnboardingState extends Equatable {
  final int currentStep;

  /// Nullable attributes of PetModel for the pet creation
  final String petName;
  final String? petSpeciesId;
  final String? petRaceId;
  final Gender? gender;
  final DateTime? birthdate;

  final ReferentialStatus speciesStatus;
  final List<PetSpeciesModel> species;
  final String? speciesError;
  final ReferentialStatus racesStatus;
  final List<PetRaceModel> races;
  final String? racesError;
  final List<PetIconModel> icons;

  const OnboardingState({
    this.currentStep = 1,
    this.petName = '',
    this.petSpeciesId,
    this.petRaceId,
    this.gender,
    this.birthdate,
    this.speciesStatus = ReferentialStatus.idle,
    this.species = const [],
    this.speciesError,
    this.racesStatus = ReferentialStatus.idle,
    this.races = const [],
    this.racesError,
    this.icons = const [],
  });

  OnboardingState copyWith({
    int? currentStep,
    String? petName,
    String? petSpeciesId,
    String? petRaceId,
    Gender? gender,
    DateTime? birthdate,
    ReferentialStatus? speciesStatus,
    List<PetSpeciesModel>? species,
    String? speciesError,
    ReferentialStatus? racesStatus,
    List<PetRaceModel>? races,
    String? racesError,
    List<PetIconModel>? icons,
    bool clearRaceId = false,
    bool clearSpeciesError = false,
    bool clearRacesError = false,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      petName: petName ?? this.petName,
      petSpeciesId: petSpeciesId ?? this.petSpeciesId,
      petRaceId: clearRaceId ? null : (petRaceId ?? this.petRaceId),
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      speciesStatus: speciesStatus ?? this.speciesStatus,
      species: species ?? this.species,
      speciesError:
          clearSpeciesError ? null : (speciesError ?? this.speciesError),
      racesStatus: racesStatus ?? this.racesStatus,
      races: races ?? this.races,
      racesError: clearRacesError ? null : (racesError ?? this.racesError),
      icons: icons ?? this.icons,
    );
  }

  /// Step 1 → Step 2 : name and species selected
  bool get canGoToStep2 =>
      petName.trim().length >= 2 &&
      petSpeciesId != null &&
      petSpeciesId!.isNotEmpty;

  /// Step 2 → Step 3: gender, race and birthdate are set
  bool get canGoToStep3 =>
      gender != null && petRaceId != null && birthdate != null;

  /// Step 3 → Signup
  bool get canFinish => canGoToStep2 && canGoToStep3;

  /// What the pet being created looks like: the icon drawn for its breed when
  /// the catalogue has one, its species icon otherwise. Null until a species
  /// is picked and its referential is loaded.
  PetPortrait? get portrait {
    final iconKey = _speciesIconKey;
    if (iconKey == null) return null;
    return PetPortrait(
      iconKey: iconKey,
      assetPath: PetIconResolver.findByRace(icons, petRaceId)?.assetPath,
    );
  }

  String? get _speciesIconKey {
    for (final item in species) {
      if (item.petSpeciesId == petSpeciesId) return item.iconKey;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        currentStep,
        petName,
        petSpeciesId,
        petRaceId,
        gender,
        birthdate,
        speciesStatus,
        species,
        speciesError,
        racesStatus,
        races,
        racesError,
        icons,
      ];
}
