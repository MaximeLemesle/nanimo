import 'package:flutter/foundation.dart';
import 'package:nanimo/core/notifications/local_notification_client.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';

/// Assigned once in main, like `analytics`. Inert in tests.
LocalNotificationClient notifications = const NoopLocalNotificationClient();

/// Payload of the last tapped reminder, consumed by the shell once it can
/// navigate. Covers both a cold start and a tap while the app runs.
final ValueNotifier<String?> pendingNotificationTap = ValueNotifier<String?>(null);

/// Reads [notifications] lazily, so main can swap the client in after boot.
NotificationPriming notificationPriming = NotificationPriming(
  client: () => notifications,
  store: MemoryPrimingStore(),
);
