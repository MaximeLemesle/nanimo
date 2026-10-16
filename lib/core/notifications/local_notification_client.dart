import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:nanimo/core/notifications/reminder_planner.dart';

/// The app depends on this seam, never on the plugin directly.
abstract class LocalNotificationClient {
  /// Never asks for permission: that is the priming sheet's job (NAN-107).
  Future<void> initialize({required void Function(String? payload) onTap});

  /// Payload of the notification that cold-started the app, if any.
  Future<String?> launchPayload();

  Future<void> schedule(PlannedReminder reminder);

  /// Pending only: what is already shown in the notification centre stays.
  Future<void> cancelPending();

  Future<void> cancelAll();

  /// Whether the system lets the app post notifications.
  Future<bool> isPermissionGranted();

  /// Shows the system prompt. Returns whether it ended granted.
  Future<bool> requestPermission();

  Future<void> openSystemSettings();
}

class NoopLocalNotificationClient implements LocalNotificationClient {
  const NoopLocalNotificationClient();

  @override
  Future<void> initialize({required void Function(String? payload) onTap}) async {}

  @override
  Future<String?> launchPayload() async => null;

  @override
  Future<void> schedule(PlannedReminder reminder) async {}

  @override
  Future<void> cancelPending() async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<bool> isPermissionGranted() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> openSystemSettings() async {}
}

class FlutterLocalNotificationClient implements LocalNotificationClient {
  final FlutterLocalNotificationsPlugin _plugin;

  FlutterLocalNotificationClient({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'health_reminders',
      'Rappels santé',
      channelDescription: 'Vaccins, visites chez le vétérinaire et anniversaires',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  @override
  Future<void> initialize({required void Function(String? payload) onTap}) async {
    tz_data.initializeTimeZones();
    try {
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local.identifier));
    } catch (e) {
      developer.log('local timezone unknown, falling back to Europe/Paris', name: 'notifications', error: e);
      tz.setLocalLocation(tz.getLocation('Europe/Paris'));
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) => onTap(response.payload),
    );
  }

  @override
  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return details.notificationResponse?.payload;
  }

  @override
  Future<void> schedule(PlannedReminder reminder) => _plugin.zonedSchedule(
        id: reminder.id,
        scheduledDate: tz.TZDateTime.from(reminder.when, tz.local),
        notificationDetails: _details,
        // Inexact keeps us clear of the exact-alarm permission; minutes do not matter here.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: reminder.title,
        body: reminder.body,
        payload: reminder.payload,
      );

  @override
  Future<void> cancelPending() => _plugin.cancelAllPendingNotifications();

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<bool> isPermissionGranted() async {
    if (Platform.isIOS) {
      final options = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      return options?.isEnabled ?? false;
    }
    final enabled = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    return enabled ?? false;
  }

  @override
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return granted ?? false;
  }

  @override
  Future<void> openSystemSettings() async {
    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.openAppNotificationSettings();
      return;
    }
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.openAppNotificationSettings();
  }
}
