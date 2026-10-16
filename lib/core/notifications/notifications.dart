import 'package:flutter/foundation.dart';
import 'package:nanimo/core/notifications/local_notification_client.dart';

/// Assigned once in main, like `analytics`. Inert in tests.
LocalNotificationClient notifications = const NoopLocalNotificationClient();

/// Payload of the last tapped reminder, consumed by the shell once it can
/// navigate. Covers both a cold start and a tap while the app runs.
final ValueNotifier<String?> pendingNotificationTap = ValueNotifier<String?>(null);
