class PetRaceModel {
  final String petRaceId;
  final String raceName;
  final String petSpeciesId;

  const PetRaceModel({
    required this.petRaceId,
    required this.raceName,
    required this.petSpeciesId,
  });

  factory PetRaceModel.fromJson(Map<String, dynamic> json) {
    return PetRaceModel(
      petRaceId: json['id_pet_race'],
      raceName: json['pet_race_name'],
      petSpeciesId: json['pet_species_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_pet_race': petRaceId,
        'pet_race_name': raceName,
        'pet_species_id': petSpeciesId,
      };
}
