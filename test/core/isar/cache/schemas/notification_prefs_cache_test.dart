import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/notification_prefs_cache.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';

void main() {
  group('NotificationPrefsCache', () {
    test('fromModel keeps the user id and every flag', () {
      const model = NotificationPrefsModel(
        pushEnabled: false,
        vaccineReminders: true,
        vetReminders: false,
        dewormingReminders: true,
        anniversaryReminders: false,
      );

      final cache = NotificationPrefsCache.fromModel('user-1', model);

      expect(cache.userId, 'user-1');
      expect(cache.pushEnabled, isFalse);
      expect(cache.vaccineReminders, isTrue);
      expect(cache.vetReminders, isFalse);
      expect(cache.dewormingReminders, isTrue);
      expect(cache.anniversaryReminders, isFalse);
    });

    test('toModel round-trips fromModel', () {
      const model = NotificationPrefsModel(
        pushEnabled: false,
        dewormingReminders: false,
      );

      final roundTrip =
          NotificationPrefsCache.fromModel('user-1', model).toModel();

      expect(roundTrip, model);
    });
  });

  group('NotificationPrefsModel', () {
    test('defaults enable everything', () {
      expect(NotificationPrefsModel.defaults.pushEnabled, isTrue);
      expect(NotificationPrefsModel.defaults.vaccineReminders, isTrue);
      expect(NotificationPrefsModel.defaults.vetReminders, isTrue);
      expect(NotificationPrefsModel.defaults.dewormingReminders, isTrue);
      expect(NotificationPrefsModel.defaults.anniversaryReminders, isTrue);
    });

    test('copyWith only touches the given flag', () {
      final updated =
          NotificationPrefsModel.defaults.copyWith(vetReminders: false);

      expect(updated.vetReminders, isFalse);
      expect(updated.pushEnabled, isTrue);
      expect(updated.vaccineReminders, isTrue);
    });
  });
}
