enum Gender { male, female, unknown }

class PetModel {
  final String petId;
  final String petName;
  final DateTime birthdate;
  final Gender gender;
  final DateTime createdAt;
  final String petRaceId;
  final String petSpeciesId;

  const PetModel({
    required this.petId,
    required this.petName,
    required this.birthdate,
    required this.gender,
    required this.createdAt,
    required this.petRaceId,
    required this.petSpeciesId,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      petId: json['id_pet'],
      petName: json['pet_name'],
      birthdate: DateTime.parse(json['birthdate']),
      gender: _parseGender(json['gender']),
      createdAt: DateTime.parse(json['created_at']),
      petRaceId: json['pet_race_id'],
      petSpeciesId: json['pet_species_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pet': petId,
      'pet_name': petName,
      'birthdate': birthdate.toIso8601String().split('T').first,
      'gender': _genderToString(gender),
      'created_at': createdAt.toIso8601String(),
      'pet_race_id': petRaceId,
      'pet_species_id': petSpeciesId,
    };
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
