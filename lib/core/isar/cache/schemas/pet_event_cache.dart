import 'package:isar/isar.dart';

part 'pet_event_cache.g.dart';

@Collection()
class PetEventCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String petEventId;

  @Index()
  late String petId;

  @Index()
  late String eventId;

  PetEventCache();

  factory PetEventCache.fromJson(Map<String, dynamic> json) {
    return PetEventCache.fromIds(
      petId: json['pet_id'] as String,
      eventId: json['event_id'] as String,
    );
  }

  factory PetEventCache.fromIds({
    required String petId,
    required String eventId,
  }) {
    return PetEventCache()
      ..petEventId = '$petId|$eventId'
      ..petId = petId
      ..eventId = eventId;
  }
}
