import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';

void main() {
  group('EventImageModel', () {
    test('fromJson maps all fields correctly', () {
      final json = {
        'id_event_image': 'img-1',
        'asset_path': 'journal-media/img-1.jpg',
        'event_id': 'evt-1',
      };

      final model = EventImageModel.fromJson(json);

      expect(model.eventImageId, 'img-1');
      expect(model.assetPath, 'journal-media/img-1.jpg');
      expect(model.eventId, 'evt-1');
    });

    test('toJson round-trips through fromJson', () {
      const original = EventImageModel(
        eventImageId: 'img-1',
        assetPath: 'journal-media/img-1.jpg',
        eventId: 'evt-1',
      );

      final roundTripped = EventImageModel.fromJson(original.toJson());

      expect(roundTripped.eventImageId, original.eventImageId);
      expect(roundTripped.assetPath, original.assetPath);
      expect(roundTripped.eventId, original.eventId);
    });
  });
}
