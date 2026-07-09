import 'package:isar/isar.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';

part 'pet_species_cache.g.dart';

@Collection()
class PetSpeciesCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String petSpeciesId;

  late String speciesName;
  late String weightUnit;
  late String iconKey;

  PetSpeciesCache();

  /// Maps a Supabase [json] row to a [PetSpeciesCache] instance
  factory PetSpeciesCache.fromJson(Map<String, dynamic> json) {
    return PetSpeciesCache()
      ..petSpeciesId = json['id_pet_species'] as String
      ..speciesName = json['species_name'] as String
      ..weightUnit = json['weight_unit'] as String
      ..iconKey = json['icon_key'] as String;
  }

  /// Builds a [PetSpeciesCache] from a [PetSpeciesModel]
  factory PetSpeciesCache.fromModel(PetSpeciesModel model) {
    return PetSpeciesCache()
      ..petSpeciesId = model.petSpeciesId
      ..speciesName = model.speciesName
      ..weightUnit = model.weightUnit == WeightUnit.g ? 'g' : 'kg'
      ..iconKey = model.iconKey;
  }

  /// Converts this cache row into the domain [PetSpeciesModel]
  PetSpeciesModel toModel() {
    return PetSpeciesModel(
      petSpeciesId: petSpeciesId,
      speciesName: speciesName,
      weightUnit: WeightFormatter.parseWeightUnit(weightUnit),
      iconKey: iconKey,
    );
  }
}
