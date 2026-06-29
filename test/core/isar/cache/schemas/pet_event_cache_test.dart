import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_event_cache.dart';

void main() {
  group('PetEventCache', () {
    test('fromJson maps the pet and event ids', () {
      final cache = PetEventCache.fromJson({
        'pet_id': 'pet-uuid',
        'event_id': 'event-uuid',
      });

      expect(cache.petId, 'pet-uuid');
      expect(cache.eventId, 'event-uuid');
      expect(cache.petEventId, 'pet-uuid|event-uuid');
    });

    test('fromIds builds a deterministic composite key', () {
      final cache =
          PetEventCache.fromIds(petId: 'p1', eventId: 'e1');

      expect(cache.petEventId, 'p1|e1');
      expect(cache.petId, 'p1');
      expect(cache.eventId, 'e1');
    });
  });
}
