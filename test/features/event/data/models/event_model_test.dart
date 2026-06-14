import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

void main() {
  group('EventModel.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_event': 'evt-1',
        'title': 'First walk',
        'description': 'A nice walk',
        'created_at': '2026-01-02T10:00:00.000Z',
        'entry_date': '2026-01-02T00:00:00.000Z',
        'event_type_id': 'type-1',
      };

      final model = EventModel.fromJson(json);

      expect(model.eventId, 'evt-1');
      expect(model.title, 'First walk');
      expect(model.description, 'A nice walk');
      expect(model.createdAt, DateTime.parse('2026-01-02T10:00:00.000Z'));
      expect(model.entryDate, DateTime.parse('2026-01-02T00:00:00.000Z'));
      expect(model.eventTypeId, 'type-1');
    });

    test('handles null optional fields', () {
      final json = {
        'id_event': 'evt-2',
        'title': 'No details',
        'description': null,
        'created_at': null,
        'entry_date': null,
        'event_type_id': 'type-1',
      };

      final model = EventModel.fromJson(json);

      expect(model.description, isNull);
      expect(model.createdAt, isNull);
      expect(model.entryDate, isNull);
    });
  });

  group('EventModel.toJson', () {
    test('round-trips through fromJson', () {
      final original = EventModel(
        eventId: 'evt-1',
        title: 'First walk',
        description: 'A nice walk',
        createdAt: DateTime.parse('2026-01-02T10:00:00.000Z'),
        entryDate: DateTime.parse('2026-01-02T00:00:00.000Z'),
        eventTypeId: 'type-1',
      );

      final roundTripped = EventModel.fromJson(original.toJson());

      expect(roundTripped.eventId, original.eventId);
      expect(roundTripped.title, original.title);
      expect(roundTripped.description, original.description);
      expect(roundTripped.createdAt, original.createdAt);
      expect(roundTripped.entryDate, original.entryDate);
      expect(roundTripped.eventTypeId, original.eventTypeId);
    });

    test('serializes null dates as null', () {
      const original = EventModel(
        eventId: 'evt-2',
        title: 'No details',
        eventTypeId: 'type-1',
      );

      final json = original.toJson();

      expect(json['created_at'], isNull);
      expect(json['entry_date'], isNull);
      expect(json['description'], isNull);
    });
  });
}
