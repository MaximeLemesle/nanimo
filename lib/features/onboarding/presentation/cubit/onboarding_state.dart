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

  /// Optional vaccine step, onboarding only (NAN-105).
  final String vaccineName;
  final DateTime? vaccineDate;
  final int? vaccineMonths;
  final bool vaccineNextUnknown;
  final List<String> vaccineSuggestions;

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
    this.vaccineName = '',
    this.vaccineDate,
    this.vaccineMonths,
    this.vaccineNextUnknown = false,
    this.vaccineSuggestions = const [],
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
    String? vaccineName,
    DateTime? vaccineDate,
    int? vaccineMonths,
    bool? vaccineNextUnknown,
    List<String>? vaccineSuggestions,
    bool clearVaccineMonths = false,
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
      vaccineName: vaccineName ?? this.vaccineName,
      vaccineDate: vaccineDate ?? this.vaccineDate,
      vaccineMonths: clearVaccineMonths ? null : (vaccineMonths ?? this.vaccineMonths),
      vaccineNextUnknown: vaccineNextUnknown ?? this.vaccineNextUnknown,
      vaccineSuggestions: vaccineSuggestions ?? this.vaccineSuggestions,
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

  /// A past date needs to know when the next booster is due.
  bool get vaccineAsksNext => vaccineDate != null && !VaccineSchedule.isUpcoming(vaccineDate!);

  bool get isVaccineComplete =>
      vaccineName.trim().isNotEmpty &&
      vaccineDate != null &&
      (!vaccineAsksNext || vaccineMonths != null || vaccineNextUnknown);

  /// The vaccine to create with the pet, null while incomplete.
  PendingVaccine? get pendingVaccine {
    if (!isVaccineComplete) return null;
    final resolved = VaccineSchedule.resolve(
      date: vaccineDate!,
      monthsUntilNext: vaccineNextUnknown ? null : vaccineMonths,
    );
    return (
      name: vaccineName.trim(),
      lastDate: resolved.lastDate,
      nextDate: resolved.nextDate,
      recurrence: resolved.recurrence,
    );
  }

  /// What the pet being created looks like: the icon drawn for its breed when
  /// the catalogue has one, its species icon otherwise. Null until a species
  /// is picked and its referential is loaded.
  PetPortrait? get portrait {
    final iconKey = _speciesIconKey;
    if (iconKey == null) return null;
    return PetPortrait(iconKey: iconKey, assetPath: _icon?.assetPath);
  }

  /// Catalogue icon stamped on the pet when it is created.
  String? get petIconId => _icon?.petIconId;

  PetIconModel? get _icon => PetIconResolver.defaultIcon(
        icons: icons,
        petRaceId: petRaceId,
        speciesIconKey: _speciesIconKey,
      );

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
        vaccineName,
        vaccineDate,
        vaccineMonths,
        vaccineNextUnknown,
        vaccineSuggestions,
      ];
}
