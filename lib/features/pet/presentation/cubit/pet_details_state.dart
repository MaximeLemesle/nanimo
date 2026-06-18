part of 'pet_details_cubit.dart';

enum PetDetailsStatus { loading, loaded, error }

class PetDetailsState extends Equatable {
  final PetDetailsStatus status;
  final List<PetModel> pets;
  final String? selectedPetId;
  final Map<String, String> iconsKey;
  final Map<String, String> speciesNameById;
  final String? raceName;
  final HealthDiaryModel? diary;
  final List<HealthDiaryVaccineModel> vaccines;
  final List<HealthDiaryWeightLogModel> weightLogs;
  final List<VetVisitModel> vetVisits;
  final double? latestWeight;
  final String? error;

  const PetDetailsState({
    this.status = PetDetailsStatus.loading,
    this.pets = const [],
    this.selectedPetId,
    this.iconsKey = const {},
    this.speciesNameById = const {},
    this.raceName,
    this.diary,
    this.vaccines = const [],
    this.weightLogs = const [],
    this.vetVisits = const [],
    this.latestWeight,
    this.error,
  });

  PetModel? get selectedPet {
    for (final pet in pets) {
      if (pet.petId == selectedPetId) return pet;
    }
    return null;
  }

  static const Object _sentinel = Object();

  PetDetailsState copyWith({
    PetDetailsStatus? status,
    List<PetModel>? pets,
    Object? selectedPetId = _sentinel,
    Map<String, String>? iconsKey,
    Map<String, String>? speciesNameById,
    Object? raceName = _sentinel,
    Object? diary = _sentinel,
    List<HealthDiaryVaccineModel>? vaccines,
    List<HealthDiaryWeightLogModel>? weightLogs,
    List<VetVisitModel>? vetVisits,
    Object? latestWeight = _sentinel,
    Object? error = _sentinel,
  }) {
    return PetDetailsState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      selectedPetId: selectedPetId == _sentinel
          ? this.selectedPetId
          : selectedPetId as String?,
      iconsKey: iconsKey ?? this.iconsKey,
      speciesNameById: speciesNameById ?? this.speciesNameById,
      raceName: raceName == _sentinel ? this.raceName : raceName as String?,
      diary: diary == _sentinel ? this.diary : diary as HealthDiaryModel?,
      vaccines: vaccines ?? this.vaccines,
      weightLogs: weightLogs ?? this.weightLogs,
      vetVisits: vetVisits ?? this.vetVisits,
      latestWeight: latestWeight == _sentinel
          ? this.latestWeight
          : latestWeight as double?,
      error: error == _sentinel ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pets,
        selectedPetId,
        iconsKey,
        speciesNameById,
        raceName,
        diary,
        vaccines,
        weightLogs,
        vetVisits,
        latestWeight,
        error,
      ];
}
