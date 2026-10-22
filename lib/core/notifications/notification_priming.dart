import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/notifications/local_notification_client.dart';

enum NotificationPermissionState { granted, denied, undetermined }

/// What the priming sheet says: which animal, which date, which kind.
class PrimingOffer {
  final String petName;
  final DateTime dueDate;
  final bool isVetVisit;

  const PrimingOffer(
      {required this.petName, required this.dueDate, this.isVetVisit = false});
}

/// What the priming needs to remember across launches.
abstract class PrimingStore {
  Future<bool> systemPromptShown();
  Future<void> markSystemPromptShown();
  Future<DateTime?> postponedAt();
  Future<void> markPostponed(DateTime at);
}

class SharedPreferencesPrimingStore implements PrimingStore {
  static const _shownKey = 'notification_prompt_shown';
  static const _postponedKey = 'notification_priming_postponed_at';

  @override
  Future<bool> systemPromptShown() async =>
      (await SharedPreferences.getInstance()).getBool(_shownKey) ?? false;

  @override
  Future<void> markSystemPromptShown() async =>
      (await SharedPreferences.getInstance()).setBool(_shownKey, true);

  @override
  Future<DateTime?> postponedAt() async {
    final millis =
        (await SharedPreferences.getInstance()).getInt(_postponedKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> markPostponed(DateTime at) async =>
      (await SharedPreferences.getInstance())
          .setInt(_postponedKey, at.millisecondsSinceEpoch);
}

class MemoryPrimingStore implements PrimingStore {
  bool shown = false;
  DateTime? postponed;

  @override
  Future<bool> systemPromptShown() async => shown;

  @override
  Future<void> markSystemPromptShown() async => shown = true;

  @override
  Future<DateTime?> postponedAt() async => postponed;

  @override
  Future<void> markPostponed(DateTime at) async => postponed = at;
}

/// Asks for the permission after a value moment, behind Nanimo's own sheet
/// (NAN-107). On iOS the system prompt shows once: a "no" there is final.
class NotificationPriming {
  static const snooze = Duration(days: 7);

  final LocalNotificationClient Function() _client;
  final PrimingStore _store;
  final DateTime Function() _now;
  final Future<void> Function()? _onGranted;

  /// Shared by every permission entry point, including the diary wizard.
  final ValueNotifier<NotificationPermissionState> permission =
      ValueNotifier(NotificationPermissionState.undetermined);

  /// Set when the sheet should open; the shell shows it and clears it.
  final ValueNotifier<PrimingOffer?> offer = ValueNotifier(null);

  NotificationPriming({
    required LocalNotificationClient Function() client,
    required PrimingStore store,
    DateTime Function()? now,
    Future<void> Function()? onGranted,
  })  : _onGranted = onGranted,
        _client = client,
        _store = store,
        _now = now ?? DateTime.now;

  Future<NotificationPermissionState> permissionState() async {
    final granted = await _client().isPermissionGranted();
    final state = granted
        ? NotificationPermissionState.granted
        : await _store.systemPromptShown()
            ? NotificationPermissionState.denied
            : NotificationPermissionState.undetermined;
    permission.value = state;
    return state;
  }

  /// Called right after an upcoming booster or visit is saved.
  Future<void> offerFor(PrimingOffer candidate) async {
    if (!candidate.dueDate.isAfter(_now())) return;
    if (await permissionState() != NotificationPermissionState.undetermined) {
      return;
    }
    final postponed = await _store.postponedAt();
    if (postponed != null && _now().difference(postponed) < snooze) return;
    offer.value = candidate;
  }

  /// Enables the in-app master switch after an explicit reminder request.
  Future<void> enableReminders() async => _onGranted?.call();

  Future<bool> accept() async {
    offer.value = null;
    final granted = await _client().requestPermission();
    await _store.markSystemPromptShown();
    if (granted) await _onGranted?.call();
    permission.value = granted
        ? NotificationPermissionState.granted
        : NotificationPermissionState.denied;
    _track(granted ? 'granted' : 'denied');
    return granted;
  }

  Future<void> postpone() async {
    offer.value = null;
    await _store.markPostponed(_now());
    _track('later');
  }

  Future<void> openSystemSettings() => _client().openSystemSettings();

  void _track(String result) {
    analytics.capture(
      AnalyticsEvents.notificationPermission,
      properties: {AnalyticsProperties.result: result},
    );
  }
}
