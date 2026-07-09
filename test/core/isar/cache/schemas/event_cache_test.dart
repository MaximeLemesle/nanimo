import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';

void main() {
  group('EventCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_event': 'event-uuid',
        'title': 'First Walk',
        'description': 'Great walk in the park',
        'created_at': '2024-06-01T08:00:00.000Z',
        'entry_date': '2024-06-01',
        'event_type_id': 'type-uuid',
      };

      final cache = EventCache.fromJson(json);

      expect(cache.eventId, 'event-uuid');
      expect(cache.title, 'First Walk');
      expect(cache.description, 'Great walk in the park');
      expect(cache.createdAt, DateTime.parse('2024-06-01T08:00:00.000Z'));
      expect(cache.entryDate, DateTime.parse('2024-06-01'));
      expect(cache.eventTypeId, 'type-uuid');
    });

    test('handles null optional fields', () {
      final json = {
        'id_event': 'event-uuid',
        'title': 'Quick note',
        'description': null,
        'created_at': '2024-06-01T08:00:00.000Z',
        'entry_date': '2024-06-01',
        'event_type_id': null,
        'user_id': 'user-uuid',
      };

      final cache = EventCache.fromJson(json);

      expect(cache.description, isNull);
      expect(cache.eventTypeId, '');
    });
  });
}
