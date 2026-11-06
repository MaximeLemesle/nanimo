import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// The app depends on this seam, never on the plugin directly.
abstract class PushClient {
  String get platform;

  /// Null when the device has no token yet.
  Future<String?> token();

  Stream<String> get tokenRefreshes;
}

class NoopPushClient implements PushClient {
  const NoopPushClient();

  @override
  String get platform => 'ios';

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();
}

/// Firebase needs no config file: dev and prod differ by their dotenv keys only.
FirebaseOptions? firebaseOptionsFrom(Map<String, String> env, {required bool isIOS}) {
  final prefix = isIOS ? 'FIREBASE_IOS' : 'FIREBASE_ANDROID';
  final apiKey = env['${prefix}_API_KEY'] ?? '';
  final appId = env['${prefix}_APP_ID'] ?? '';
  final senderId = env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  final projectId = env['FIREBASE_PROJECT_ID'] ?? '';
  if ([apiKey, appId, senderId, projectId].any((value) => value.isEmpty)) return null;
  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: senderId,
    projectId: projectId,
  );
}

class FirebasePushClient implements PushClient {
  static const _apnsRetries = 5;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Android hides pushes received in the foreground, so the app shows them.
  Future<void> initialize({
    required void Function(String? payload) onTap,
    required Future<void> Function(String title, String body, String? payload) showForeground,
  }) async {
    await _messaging.setForegroundNotificationPresentationOptions(alert: true, sound: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) => onTap(message.data['payload'] as String?));
    final launch = await _messaging.getInitialMessage();
    if (launch != null) onTap(launch.data['payload'] as String?);

    if (Platform.isIOS) return;
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      showForeground(
        notification.title ?? '',
        notification.body ?? '',
        message.data['payload'] as String?,
      );
    });
  }

  @override
  String get platform => Platform.isIOS ? 'ios' : 'android';

  /// Only called once granted, so this never shows a system prompt: it makes
  /// iOS register with APNs, without which FCM refuses to hand out a token.
  @override
  Future<String?> token() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission();
      for (var i = 0; i < _apnsRetries; i++) {
        if (await _messaging.getAPNSToken() != null) break;
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }
    try {
      // ignore: deprecated_member_use
      return await _messaging.getToken();
    } on FirebaseException catch (e, st) {
      developer.log('no fcm token', name: 'push', error: e, stackTrace: st);
      return null;
    }
  }

  /// The replacement API yields an installation id, not the `token` FCM v1 expects.
  @override
  // ignore: deprecated_member_use
  Stream<String> get tokenRefreshes => _messaging.onTokenRefresh;
}
