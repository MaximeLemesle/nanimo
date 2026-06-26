import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';

void main() {
  group('EventTypeModel', () {
    test('fromJson maps all fields correctly', () {
      final json = {
        'id_event_type': 'type-1',
        'name': 'Balades',
        'code': 'balade',
        'is_premium': false,
      };

      final model = EventTypeModel.fromJson(json);

      expect(model.eventTypeId, 'type-1');
      expect(model.name, 'Balades');
      expect(model.code, 'balade');
      expect(model.isPremium, false);
    });

    test('fromJson tolerates a null code (legacy rows)', () {
      final json = {
        'id_event_type': 'type-1',
        'name': 'Souvenir',
        'code': null,
        'is_premium': false,
      };

      expect(EventTypeModel.fromJson(json).code, isNull);
    });

    test('toJson round-trips through fromJson', () {
      const original = EventTypeModel(
        eventTypeId: 'type-2',
        name: 'Câlins',
        code: 'calin',
        isPremium: true,
      );

      final roundTripped = EventTypeModel.fromJson(original.toJson());

      expect(roundTripped.eventTypeId, original.eventTypeId);
      expect(roundTripped.name, original.name);
      expect(roundTripped.code, original.code);
      expect(roundTripped.isPremium, original.isPremium);
    });
  });
}
