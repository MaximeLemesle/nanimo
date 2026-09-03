import 'package:isar/isar.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';

part 'pet_icon_cache.g.dart';

@Collection()
class PetIconCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String petIconId;

  late String petIconName;
  late String assetPath;
  late bool isPremium;

  @Index()
  String? petSpeciesId;

  PetIconCache();

  /// Maps a Supabase [json] row to a [PetIconCache] instance
  factory PetIconCache.fromJson(Map<String, dynamic> json) {
    return PetIconCache()
      ..petIconId = json['id_pet_icon'] as String
      ..petIconName = json['pet_icon_name'] as String
      ..assetPath = json['asset_path'] as String
      ..isPremium = json['is_premium'] as bool? ?? false
      ..petSpeciesId = json['pet_species_id'] as String?;
  }

  /// Builds a [PetIconCache] from a [PetIconModel]
  factory PetIconCache.fromModel(PetIconModel model) {
    return PetIconCache()
      ..petIconId = model.petIconId
      ..petIconName = model.petIconName
      ..assetPath = model.assetPath
      ..isPremium = model.isPremium
      ..petSpeciesId = model.petSpeciesId;
  }

  /// Converts this cache row into the domain [PetIconModel]
  PetIconModel toModel() {
    return PetIconModel(
      petIconId: petIconId,
      petIconName: petIconName,
      assetPath: assetPath,
      isPremium: isPremium,
      petSpeciesId: petSpeciesId,
    );
  }
}
