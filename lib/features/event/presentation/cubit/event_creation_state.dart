part of 'event_creation_cubit.dart';

enum EventCreationStatus { initial, loading, success, error }

class EventCreationState extends Equatable {
  final EventCreationStatus status;
  final List<EventTypeModel> types;
  final String? selectedTypeId;
  final List<PetModel> pets;
  final List<String> selectedPetIds;
  final Map<String, String> iconsKey;
  final List<PetIconModel> icons;
  final String? error;

  const EventCreationState({
    this.status = EventCreationStatus.initial,
    this.types = const [],
    this.selectedTypeId,
    this.pets = const [],
    this.selectedPetIds = const [],
    this.iconsKey = const {},
    this.icons = const [],
    this.error,
  });
  /// What each pet looks like: its chosen catalogue icon, else its species one.
  Map<String, PetPortrait> get portraits => PetIconResolver.portraitsByPet(
        pets: pets,
        icons: icons,
        speciesIconKeys: iconsKey,
      );


  EventCreationState copyWith({
    EventCreationStatus? status,
    List<EventTypeModel>? types,
    String? selectedTypeId,
    List<PetModel>? pets,
    List<String>? selectedPetIds,
    Map<String, String>? iconsKey,
    List<PetIconModel>? icons,
    String? error,
  }) {
    return EventCreationState(
      status: status ?? this.status,
      types: types ?? this.types,
      selectedTypeId: selectedTypeId ?? this.selectedTypeId,
      pets: pets ?? this.pets,
      selectedPetIds: selectedPetIds ?? this.selectedPetIds,
      iconsKey: iconsKey ?? this.iconsKey,
      icons: icons ?? this.icons,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [status, types, selectedTypeId, pets, selectedPetIds, iconsKey, icons, error];
}
