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
      };

      final model = UserModel.fromJson(json);

      expect(model.userId, 'user-1');
      expect(model.userName, 'Maxime');
      expect(model.mail, 'maxime@example.com');
      expect(model.subscriptionStatus, SubscriptionStatus.premium);
      expect(model.subscriptionExpiresAt,
          DateTime.parse('2026-12-31T00:00:00.000Z'));
    });

    test('defaults to freemium for unknown status and null expiry', () {
      final json = {
        'id_user': 'user-2',
        'user_name': 'Free user',
        'mail': 'free@example.com',
        'subscription_status': 'something-else',
        'subscription_expires_at': null,
      };

      final model = UserModel.fromJson(json);

      expect(model.subscriptionStatus, SubscriptionStatus.freemium);
      expect(model.subscriptionExpiresAt, isNull);
    });
  });

  group('UserModel.planName', () {
    test('matches the subscription_config plan_name of each status', () {
      const freemium = UserModel(
        userId: 'user-1',
        userName: 'Free user',
        mail: 'free@example.com',
        subscriptionStatus: SubscriptionStatus.freemium,
      );
      const premium = UserModel(
        userId: 'user-2',
        userName: 'Paid user',
        mail: 'paid@example.com',
        subscriptionStatus: SubscriptionStatus.premium,
      );

      expect(freemium.planName, 'freemium');
      expect(premium.planName, 'premium');
    });
  });

  group('UserModel.toJson', () {
    test('round-trips premium user through fromJson', () {
      final original = UserModel(
        userId: 'user-1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.premium,
        subscriptionExpiresAt: DateTime.parse('2026-12-31T00:00:00.000Z'),
      );

      final roundTripped = UserModel.fromJson(original.toJson());

      expect(roundTripped.userId, original.userId);
      expect(roundTripped.userName, original.userName);
      expect(roundTripped.mail, original.mail);
      expect(roundTripped.subscriptionStatus, original.subscriptionStatus);
      expect(roundTripped.subscriptionExpiresAt, original.subscriptionExpiresAt);
    });

    test('serializes freemium status and null expiry', () {
      const original = UserModel(
        userId: 'user-2',
        userName: 'Free user',
        mail: 'free@example.com',
        subscriptionStatus: SubscriptionStatus.freemium,
      );

      final json = original.toJson();

      expect(json['subscription_status'], 'freemium');
      expect(json['subscription_expires_at'], isNull);
    });
  });

  // NAN-083: nothing read the expiry date, so a lost revocation event granted
  // premium for life.
  group('UserModel expiry enforcement', () {
    final now = DateTime.parse('2026-09-16T12:00:00.000Z');

    UserModel premium({DateTime? expiresAt}) => UserModel(
          userId: 'user-1',
          userName: 'Paid user',
          mail: 'paid@example.com',
          subscriptionStatus: SubscriptionStatus.premium,
          subscriptionExpiresAt: expiresAt,
        );

    UserModel freemium({DateTime? expiresAt}) => UserModel(
          userId: 'user-2',
          userName: 'Free user',
          mail: 'free@example.com',
          subscriptionStatus: SubscriptionStatus.freemium,
          subscriptionExpiresAt: expiresAt,
        );

    test('a premium user whose date has passed is served freemium', () {
      final user = premium(expiresAt: now.subtract(const Duration(days: 1)));

      expect(user.planNameAt(now), 'freemium');
      expect(user.hasActivePremiumAt(now), isFalse);
    });

    test('a premium user whose date is ahead keeps premium', () {
      final user = premium(expiresAt: now.add(const Duration(days: 1)));

      expect(user.planNameAt(now), 'premium');
      expect(user.hasActivePremiumAt(now), isTrue);
    });

    test('a null date takes nothing away from a premium user', () {
      expect(premium().planNameAt(now), 'premium');
      expect(premium().hasActivePremiumAt(now), isTrue);
    });

    test('the exact expiry instant is still premium', () {
      final user = premium(expiresAt: now);

      expect(user.planNameAt(now), 'premium');
    });

    test('a freemium user is never affected, whatever the date', () {
      expect(freemium().planNameAt(now), 'freemium');
      expect(
        freemium(expiresAt: now.add(const Duration(days: 365))).planNameAt(now),
        'freemium',
      );
      expect(
        freemium(expiresAt: now.subtract(const Duration(days: 365)))
            .hasActivePremiumAt(now),
        isFalse,
      );
    });
  });
}
