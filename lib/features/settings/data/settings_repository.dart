import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/isar/cache/schemas/notification_prefs_cache.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';

class SettingsRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  SettingsRepository(this._supabase, this._isar);

  String? get _userId => _supabase.auth.currentUser?.id;

  Stream<NotificationPrefsModel> watchNotificationPrefs() {
    final id = _userId;
    if (id == null) return Stream.value(NotificationPrefsModel.defaults);

    return _isar.notificationPrefsCaches
        .filter()
        .userIdEqualTo(id)
        .watch(fireImmediately: true)
        .map((rows) =>
            rows.isEmpty ? NotificationPrefsModel.defaults : rows.first.toModel());
  }

  Future<void> saveNotificationPrefs(NotificationPrefsModel prefs) async {
    final id = _userId;
    if (id == null) return;

    final cache = NotificationPrefsCache.fromModel(id, prefs);
    await _isar.writeTxn(() async {
      await _isar.notificationPrefsCaches.putByUserId(cache);
    });
  }
}
