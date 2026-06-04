import 'package:isar/isar.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

part 'pet_cache.g.dart';

@Collection()
class PetCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String petId;

  late String petName;
  DateTime? birthdate;
  late String gender;
  String? petRaceId;
  String? petSpeciesId;
  late DateTime createdAt;

  PetCache();

  /// Maps a Supabase [json] row to a [PetCache] instance
  factory PetCache.fromJson(Map<String, dynamic> json) {
    return PetCache()
      ..petId = json['id_pet'] as String
      ..petName = json['pet_name'] as String
      ..birthdate = json['birthdate'] != null
          ? DateTime.parse(json['birthdate'] as String)
          : null
      ..gender = json['gender'] as String
      ..petRaceId = json['id_race'] as String?
      ..petSpeciesId = json['id_species'] as String?
      ..createdAt = DateTime.parse(json['created_at'] as String);
  }

  /// Builds a [PetCache] from a [PetModel]
  factory PetCache.fromModel(PetModel model) {
    return PetCache()
      ..petId = model.petId
      ..petName = model.petName
      ..birthdate = model.birthdate
      ..gender = _genderToString(model.gender)
      ..petRaceId = model.petRaceId
      ..petSpeciesId = model.petSpeciesId
      ..createdAt = model.createdAt;
  }

  /// Converts this cache row into the domain [PetModel]
  PetModel toModel() {
    return PetModel(
      petId: petId,
      petName: petName,
      birthdate: birthdate ?? DateTime.fromMillisecondsSinceEpoch(0),
      gender: _parseGender(gender),
      createdAt: createdAt,
      petRaceId: petRaceId ?? '',
      petSpeciesId: petSpeciesId ?? '',
    );
  }
}

Gender _parseGender(String value) {
  switch (value) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'unknown':
    default:
      return Gender.unknown;
  }
}

String _genderToString(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'male';
    case Gender.female:
      return 'female';
    case Gender.unknown:
      return 'unknown';
  }
}
