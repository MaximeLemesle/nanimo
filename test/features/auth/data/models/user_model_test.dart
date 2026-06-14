import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_user': 'user-1',
        'user_name': 'Maxime',
        'mail': 'maxime@example.com',
        'subscription_status': 'premium',
        'subscription_expires_at': '2026-12-31T00:00:00.000Z',
        'id_subscription_config': 'cfg-2',
      };

      final model = UserModel.fromJson(json);

      expect(model.userId, 'user-1');
      expect(model.userName, 'Maxime');
      expect(model.mail, 'maxime@example.com');
      expect(model.subscriptionStatus, SubscriptionStatus.premium);
      expect(model.subscriptionExpiresAt,
          DateTime.parse('2026-12-31T00:00:00.000Z'));
      expect(model.subscriptionConfigId, 'cfg-2');
    });

    test('defaults to freemium for unknown status and null expiry', () {
      final json = {
        'id_user': 'user-2',
        'user_name': 'Free user',
        'mail': 'free@example.com',
        'subscription_status': 'something-else',
        'subscription_expires_at': null,
        'id_subscription_config': 'cfg-1',
      };

      final model = UserModel.fromJson(json);

      expect(model.subscriptionStatus, SubscriptionStatus.freemium);
      expect(model.subscriptionExpiresAt, isNull);
    });
  });

  group('UserModel.toJson', () {
    test('round-trips premium user through fromJson', () {
      final original = UserModel(
        userId: 'user-1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.premium,
        subscriptionConfigId: 'cfg-2',
        subscriptionExpiresAt: DateTime.parse('2026-12-31T00:00:00.000Z'),
      );

      final roundTripped = UserModel.fromJson(original.toJson());

      expect(roundTripped.userId, original.userId);
      expect(roundTripped.userName, original.userName);
      expect(roundTripped.mail, original.mail);
      expect(roundTripped.subscriptionStatus, original.subscriptionStatus);
      expect(roundTripped.subscriptionExpiresAt, original.subscriptionExpiresAt);
      expect(roundTripped.subscriptionConfigId, original.subscriptionConfigId);
    });

    test('serializes freemium status and null expiry', () {
      const original = UserModel(
        userId: 'user-2',
        userName: 'Free user',
        mail: 'free@example.com',
        subscriptionStatus: SubscriptionStatus.freemium,
        subscriptionConfigId: 'cfg-1',
      );

      final json = original.toJson();

      expect(json['subscription_status'], 'freemium');
      expect(json['subscription_expires_at'], isNull);
    });
  });
}
