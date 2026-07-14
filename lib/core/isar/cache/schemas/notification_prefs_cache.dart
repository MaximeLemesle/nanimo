import 'package:isar/isar.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';

part 'notification_prefs_cache.g.dart';

@Collection()
class NotificationPrefsCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  late bool pushEnabled;
  late bool vaccineReminders;
  late bool vetReminders;
  late bool dewormingReminders;
  late bool anniversaryReminders;

  NotificationPrefsCache();

  factory NotificationPrefsCache.fromModel(
    String userId,
    NotificationPrefsModel model,
  ) {
    return NotificationPrefsCache()
      ..userId = userId
      ..pushEnabled = model.pushEnabled
      ..vaccineReminders = model.vaccineReminders
      ..vetReminders = model.vetReminders
      ..dewormingReminders = model.dewormingReminders
      ..anniversaryReminders = model.anniversaryReminders;
  }

  NotificationPrefsModel toModel() {
    return NotificationPrefsModel(
      pushEnabled: pushEnabled,
      vaccineReminders: vaccineReminders,
      vetReminders: vetReminders,
      dewormingReminders: dewormingReminders,
      anniversaryReminders: anniversaryReminders,
    );
  }
}
