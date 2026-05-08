class PetIconModel {
  final String petIconId;
  final String petIconName;
  final String assetPath;
  final bool isPremium;
  final String petSpeciesId;

  const PetIconModel({
    required this.petIconId,
    required this.petIconName,
    required this.assetPath,
    required this.isPremium,
    required this.petSpeciesId,
  });

  factory PetIconModel.fromJson(Map<String, dynamic> json) {
    return PetIconModel(
      petIconId: json['id_pet_icon'],
      petIconName: json['pet_icon_name'],
      assetPath: json['asset_path'],
      isPremium: json['is_premium'],
      petSpeciesId: json['pet_species_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_pet_icon': petIconId,
        'pet_icon_name': petIconName,
        'asset_path': assetPath,
        'is_premium': isPremium,
        'pet_species_id': petSpeciesId,
      };
}
