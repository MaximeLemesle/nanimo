import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/notifications/reminder_planner.dart';
import 'package:nanimo/core/push/push_client.dart';

void main() {
  const env = {
    'FIREBASE_PROJECT_ID': 'nanimo-dev',
    'FIREBASE_MESSAGING_SENDER_ID': '123',
    'FIREBASE_IOS_API_KEY': 'ios-key',
    'FIREBASE_IOS_APP_ID': 'ios-app',
    'FIREBASE_ANDROID_API_KEY': 'android-key',
    'FIREBASE_ANDROID_APP_ID': 'android-app',
  };

  test('each platform reads its own Firebase keys', () {
    expect(firebaseOptionsFrom(env, isIOS: true)?.appId, 'ios-app');
    expect(firebaseOptionsFrom(env, isIOS: false)?.apiKey, 'android-key');
  });

  test('a missing key disables pushes', () {
    expect(firebaseOptionsFrom({...env, 'FIREBASE_IOS_APP_ID': ''}, isIOS: true), isNull);
    expect(firebaseOptionsFrom(const {}, isIOS: false), isNull);
  });

  test('an article payload carries its id', () {
    expect(parseArticlePayload('article|a1'), 'a1');
  });

  test('anything else is not an article', () {
    expect(parseArticlePayload(null), isNull);
    expect(parseArticlePayload('article|'), isNull);
    expect(parseArticlePayload('vaccine|p1'), isNull);
  });

  test('an article payload is not a reminder', () {
    expect(parseReminderPayload('article|a1'), isNull);
  });
}
