part of 'event_creation_cubit.dart';

enum EventCreationStatus { initial, loading, success, error }

class EventCreationState extends Equatable {
  final EventCreationStatus status;
  final List<EventTypeModel> types;
  final String? selectedTypeId;
  final List<PetModel> pets;
  final List<String> selectedPetIds;
  final Map<String, String> iconsKey;
  final String? error;

  const EventCreationState({
    this.status = EventCreationStatus.initial,
    this.types = const [],
    this.selectedTypeId,
    this.pets = const [],
    this.selectedPetIds = const [],
    this.iconsKey = const {},
    this.error,
  });

  EventCreationState copyWith({
    EventCreationStatus? status,
    List<EventTypeModel>? types,
    String? selectedTypeId,
    List<PetModel>? pets,
    List<String>? selectedPetIds,
    Map<String, String>? iconsKey,
    String? error,
  }) {
    return EventCreationState(
      status: status ?? this.status,
      types: types ?? this.types,
      selectedTypeId: selectedTypeId ?? this.selectedTypeId,
      pets: pets ?? this.pets,
      selectedPetIds: selectedPetIds ?? this.selectedPetIds,
      iconsKey: iconsKey ?? this.iconsKey,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [status, types, selectedTypeId, pets, selectedPetIds, iconsKey, error];
}
