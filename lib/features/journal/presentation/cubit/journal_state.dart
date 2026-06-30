part of 'journal_cubit.dart';

enum JournalStatus { loading, loaded, error }

class JournalState extends Equatable {
  final JournalStatus status;
  final List<EventModel> events;
  final List<PetModel> pets;
  final List<EventTypeModel> types;
  final Map<String, List<String>> petIdsByEvent;
  final Map<String, List<String>> imagePathsByEvent;
  final Map<String, String> iconsKey;
  final Set<String> selectedPetIds;
  final Set<String> selectedTypeIds;
  final String? error;

  const JournalState({
    this.status = JournalStatus.loading,
    this.events = const [],
    this.pets = const [],
    this.types = const [],
    this.petIdsByEvent = const {},
    this.imagePathsByEvent = const {},
    this.iconsKey = const {},
    this.selectedPetIds = const {},
    this.selectedTypeIds = const {},
    this.error,
  });

  bool get hasActiveFilters =>
      selectedPetIds.isNotEmpty || selectedTypeIds.isNotEmpty;

  int get activeFilterCount => selectedPetIds.length + selectedTypeIds.length;

  List<EventModel> get filteredEvents {
    return events.where((event) {
      if (selectedTypeIds.isNotEmpty &&
          !selectedTypeIds.contains(event.eventTypeId)) {
        return false;
      }
      if (selectedPetIds.isNotEmpty) {
        final petIds = petIdsByEvent[event.eventId] ?? const [];
        if (!petIds.any(selectedPetIds.contains)) return false;
      }
      return true;
    }).toList();
  }

  JournalState copyWith({
    JournalStatus? status,
    List<EventModel>? events,
    List<PetModel>? pets,
    List<EventTypeModel>? types,
    Map<String, List<String>>? petIdsByEvent,
    Map<String, List<String>>? imagePathsByEvent,
    Map<String, String>? iconsKey,
    Set<String>? selectedPetIds,
    Set<String>? selectedTypeIds,
    String? error,
  }) {
    return JournalState(
      status: status ?? this.status,
      events: events ?? this.events,
      pets: pets ?? this.pets,
      types: types ?? this.types,
      petIdsByEvent: petIdsByEvent ?? this.petIdsByEvent,
      imagePathsByEvent: imagePathsByEvent ?? this.imagePathsByEvent,
      iconsKey: iconsKey ?? this.iconsKey,
      selectedPetIds: selectedPetIds ?? this.selectedPetIds,
      selectedTypeIds: selectedTypeIds ?? this.selectedTypeIds,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        events,
        pets,
        types,
        petIdsByEvent,
        imagePathsByEvent,
        iconsKey,
        selectedPetIds,
        selectedTypeIds,
        error,
      ];
}
