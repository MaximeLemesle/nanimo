part of 'edit_event_cubit.dart';

enum EditEventStatus { initial, loading, success, error }

class EditEventState extends Equatable {
  final EditEventStatus status;
  final EventModel? event;
  final List<EventImageModel> existingImages;
  final List<EventTypeModel> types;
  final String? selectedTypeId;
  final List<PetModel> pets;
  final List<String> selectedPetIds;
  final Map<String, String> iconsKey;
  final List<PetIconModel> icons;
  final String? error;

  const EditEventState({
    this.status = EditEventStatus.initial,
    this.event,
    this.existingImages = const [],
    this.types = const [],
    this.selectedTypeId,
    this.pets = const [],
    this.selectedPetIds = const [],
    this.iconsKey = const {},
    this.icons = const [],
    this.error,
  });

  bool get isLoaded => event != null && types.isNotEmpty;
  /// What each pet looks like: its chosen catalogue icon, else its species one.
  Map<String, PetPortrait> get portraits => PetIconResolver.portraitsByPet(
        pets: pets,
        icons: icons,
        speciesIconKeys: iconsKey,
      );


  EditEventState copyWith({
    EditEventStatus? status,
    EventModel? event,
    List<EventImageModel>? existingImages,
    List<EventTypeModel>? types,
    String? selectedTypeId,
    List<PetModel>? pets,
    List<String>? selectedPetIds,
    Map<String, String>? iconsKey,
    List<PetIconModel>? icons,
    String? error,
  }) {
    return EditEventState(
      status: status ?? this.status,
      event: event ?? this.event,
      existingImages: existingImages ?? this.existingImages,
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
  List<Object?> get props => [
        status,
        event,
        existingImages,
        types,
        selectedTypeId,
        pets,
        selectedPetIds,
        iconsKey,
        icons,
        error,
      ];
}
