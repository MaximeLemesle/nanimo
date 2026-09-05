part of 'edit_pet_cubit.dart';

enum EditPetStatus { initial, loading, success, deleting, deleted, error }

class EditPetState extends Equatable {
  final EditPetStatus status;
  final PetModel? pet;
  final List<PetRaceModel> races;
  final List<PetIconModel> icons;
  final String? speciesName;
  final String? speciesIconKey;
  final int eventCount;
  final String? error;

  const EditPetState({
    this.status = EditPetStatus.initial,
    this.pet,
    this.races = const [],
    this.icons = const [],
    this.speciesName,
    this.speciesIconKey,
    this.eventCount = 0,
    this.error,
  });

  bool get isLoaded => pet != null && races.isNotEmpty;

  /// What the pet looks like right now: its stamped icon, else its breed's,
  /// else the generic species drawing.
  PetPortrait? get portrait {
    final current = pet;
    final iconKey = speciesIconKey;
    if (current == null || iconKey == null) return null;

    final icon = PetIconResolver.findById(icons, current.petIconId) ??
        PetIconResolver.findByRace(icons, current.petRaceId);
    return PetPortrait(iconKey: iconKey, assetPath: icon?.assetPath);
  }

  EditPetState copyWith({
    EditPetStatus? status,
    PetModel? pet,
    List<PetRaceModel>? races,
    List<PetIconModel>? icons,
    String? speciesName,
    String? speciesIconKey,
    int? eventCount,
    String? error,
  }) {
    return EditPetState(
      status: status ?? this.status,
      pet: pet ?? this.pet,
      races: races ?? this.races,
      icons: icons ?? this.icons,
      speciesName: speciesName ?? this.speciesName,
      speciesIconKey: speciesIconKey ?? this.speciesIconKey,
      eventCount: eventCount ?? this.eventCount,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pet,
        races,
        icons,
        speciesName,
        speciesIconKey,
        eventCount,
        error,
      ];
}
