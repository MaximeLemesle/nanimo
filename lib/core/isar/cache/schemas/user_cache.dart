import 'package:isar/isar.dart';

part 'user_cache.g.dart';

@Collection()
class UserCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idUser;

  String? userName;
  late String mail;
  late String subscriptionStatus;
  DateTime? subscriptionExpiresAt;

  UserCache();

  /// Maps a Supabase [json] row to a [UserCache] instance
  factory UserCache.fromJson(Map<String, dynamic> json) {
    return UserCache()
      ..idUser = json['id_user'] as String
      ..userName = json['user_name'] as String?
      ..mail = json['mail'] as String
      ..subscriptionStatus = json['subscription_status'] as String
      ..subscriptionExpiresAt = json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'] as String)
          : null;
  }
}
