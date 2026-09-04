class PetIconModel {
  final String petIconId;
  final String petIconName;
  final String assetPath;
  final bool isPremium;
  final String? petSpeciesId;
  final String? petRaceId;

  const PetIconModel({
    required this.petIconId,
    required this.petIconName,
    required this.assetPath,
    required this.isPremium,
    required this.petSpeciesId,
    required this.petRaceId,
  });

  factory PetIconModel.fromJson(Map<String, dynamic> json) {
    return PetIconModel(
      petIconId: json['id_pet_icon'] as String,
      petIconName: json['pet_icon_name'] as String,
      assetPath: json['asset_path'] as String,
      isPremium: json['is_premium'] as bool? ?? false,
      petSpeciesId: json['pet_species_id'] as String?,
      petRaceId: json['pet_race_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_pet_icon': petIconId,
        'pet_icon_name': petIconName,
        'asset_path': assetPath,
        'is_premium': isPremium,
        'pet_species_id': petSpeciesId,
        'pet_race_id': petRaceId,
      };
}
