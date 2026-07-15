import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';

void main() {
  group('UserCache.fromJson', () {
    test('maps all non-null fields correctly', () {
      final json = {
        'id_user': 'abc-123',
        'user_name': 'Alice',
        'mail': 'alice@example.com',
        'subscription_status': 'freemium',
        'subscription_expires_at': '2026-12-31T00:00:00.000Z',
      };

      final cache = UserCache.fromJson(json);

      expect(cache.userId, 'abc-123');
      expect(cache.userName, 'Alice');
      expect(cache.mail, 'alice@example.com');
      expect(cache.subscriptionStatus, 'freemium');
      expect(cache.subscriptionExpiresAt, DateTime.parse('2026-12-31T00:00:00.000Z'));
    });

    test('handles null optional fields', () {
      final json = {
        'id_user': 'abc-123',
        'user_name': null,
        'mail': 'alice@example.com',
        'subscription_status': 'freemium',
        'subscription_expires_at': null,
      };

      final cache = UserCache.fromJson(json);

      expect(cache.userName, isNull);
      expect(cache.subscriptionExpiresAt, isNull);
    });
  });
}
