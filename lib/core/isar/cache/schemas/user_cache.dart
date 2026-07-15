import 'package:isar/isar.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';

part 'user_cache.g.dart';

@Collection()
class UserCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  String? userName;
  late String mail;
  late String subscriptionStatus;
  DateTime? subscriptionExpiresAt;
  String? subscriptionConfigId;

  UserCache();

  /// Maps a Supabase [json] row to a [UserCache] instance
  factory UserCache.fromJson(Map<String, dynamic> json) {
    return UserCache()
      ..userId = json['id_user'] as String
      ..userName = json['user_name'] as String?
      ..mail = json['mail'] as String
      ..subscriptionStatus = json['subscription_status'] as String
      ..subscriptionExpiresAt = json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'] as String)
          : null
      ..subscriptionConfigId = json['id_subscription_config']?.toString();
  }

  /// Builds a [UserCache] from a [UserModel]
  factory UserCache.fromModel(UserModel model) {
    return UserCache()
      ..userId = model.userId
      ..userName = model.userName
      ..mail = model.mail
      ..subscriptionStatus = _statusToString(model.subscriptionStatus)
      ..subscriptionExpiresAt = model.subscriptionExpiresAt
      ..subscriptionConfigId = model.subscriptionConfigId;
  }

  /// Converts this cache row into the domain [UserModel]
  UserModel toModel() {
    return UserModel(
      userId: userId,
      userName: userName ?? '',
      mail: mail,
      subscriptionStatus: _parseStatus(subscriptionStatus),
      subscriptionExpiresAt: subscriptionExpiresAt,
      subscriptionConfigId: subscriptionConfigId,
    );
  }
}

SubscriptionStatus _parseStatus(String value) {
  switch (value) {
    case 'premium':
      return SubscriptionStatus.premium;
    case 'freemium':
    default:
      return SubscriptionStatus.freemium;
  }
}

String _statusToString(SubscriptionStatus status) {
  switch (status) {
    case SubscriptionStatus.premium:
      return 'premium';
    case SubscriptionStatus.freemium:
      return 'freemium';
  }
}
