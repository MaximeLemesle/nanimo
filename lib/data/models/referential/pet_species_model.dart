enum WeightUnit { kg, g }

class PetSpeciesModel {
  final String petSpeciesId;
  final String speciesName;
  final WeightUnit weightUnit;
  final String iconKey;

  const PetSpeciesModel({
    required this.petSpeciesId,
    required this.speciesName,
    required this.weightUnit,
    required this.iconKey,
  });

  factory PetSpeciesModel.fromJson(Map<String, dynamic> json) {
    return PetSpeciesModel(
      petSpeciesId: json['id_pet_species'],
      speciesName: json['species_name'],
      weightUnit: _parseWeightUnit(json['weight_unit']),
      iconKey: json['icon_key'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_pet_species': petSpeciesId,
        'species_name': speciesName,
        'weight_unit': _weightUnitToString(weightUnit),
        'icon_key': iconKey,
      };
}

WeightUnit _parseWeightUnit(String value) {
  switch (value) {
    case 'g':
      return WeightUnit.g;
    case 'kg':
    default:
      return WeightUnit.kg;
  }
}

String _weightUnitToString(WeightUnit unit) {
  switch (unit) {
    case WeightUnit.g:
      return 'g';
    case WeightUnit.kg:
      return 'kg';
  }
}
