import 'package:isar/isar.dart';

part 'pet_cache.g.dart';

@Collection()
class PetCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idPet;

  late String petName;
  DateTime? birthdate;
  late String gender;
  String? idRace;
  String? idSpecies;
  String? idIcon;
  late DateTime createdAt;

  PetCache();

  /// Maps a Supabase [json] row to a [PetCache] instance
  factory PetCache.fromJson(Map<String, dynamic> json) {
    return PetCache()
      ..idPet = json['id_pet'] as String
      ..petName = json['pet_name'] as String
      ..birthdate = json['birthdate'] != null
          ? DateTime.parse(json['birthdate'] as String)
          : null
      ..gender = json['gender'] as String
      ..idRace = json['id_race'] as String?
      ..idSpecies = json['id_species'] as String?
      ..idIcon = json['id_icon'] as String?
      ..createdAt = DateTime.parse(json['created_at'] as String);
  }
}
