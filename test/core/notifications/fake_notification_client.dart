import 'package:nanimo/core/notifications/local_notification_client.dart';
import 'package:nanimo/core/notifications/reminder_planner.dart';

class FakeNotificationClient implements LocalNotificationClient {
  final List<PlannedReminder> pending = [];
  int cancelAllCount = 0;
  bool granted;
  bool grantOnRequest;
  int requestCount = 0;
  int openSettingsCount = 0;

  FakeNotificationClient({this.granted = false, this.grantOnRequest = true});

  @override
  Future<void> initialize({required void Function(String? payload) onTap}) async {}

  @override
  Future<String?> launchPayload() async => null;

  @override
  Future<void> schedule(PlannedReminder reminder) async => pending.add(reminder);

  @override
  Future<void> cancelPending() async => pending.clear();

  @override
  Future<void> cancelAll() async {
    cancelAllCount++;
    pending.clear();
  }

  @override
  Future<bool> isPermissionGranted() async => granted;

  @override
  Future<bool> requestPermission() async {
    requestCount++;
    granted = grantOnRequest;
    return granted;
  }

  @override
  Future<void> openSystemSettings() async => openSettingsCount++;
}
