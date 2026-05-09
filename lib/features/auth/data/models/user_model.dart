enum SubscriptionStatus { freemium, premium }

class UserModel {
  final String userId;
  final String userName;
  final String mail;
  final SubscriptionStatus subscriptionStatus;
  final DateTime? subscriptionExpiresAt;
  final String subscriptionConfigId;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.mail,
    required this.subscriptionStatus,
    required this.subscriptionConfigId,
    this.subscriptionExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id_user'],
      userName: json['user_name'],
      mail: json['mail'],
      subscriptionStatus: _parseSubscriptionStatus(json['subscription_status']),
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'] as String)
          : null,
      subscriptionConfigId: json['id_subscription_config'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_user': userId,
        'user_name': userName,
        'mail': mail,
        'subscription_status': _subscriptionStatusToString(subscriptionStatus),
        'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
        'id_subscription_config': subscriptionConfigId,
      };
}

SubscriptionStatus _parseSubscriptionStatus(String value) {
  switch (value) {
    case 'premium':
      return SubscriptionStatus.premium;
    case 'freemium':
    default:
      return SubscriptionStatus.freemium;
  }
}

String _subscriptionStatusToString(SubscriptionStatus status) {
  switch (status) {
    case SubscriptionStatus.premium:
      return 'premium';
    case SubscriptionStatus.freemium:
      return 'freemium';
  }
}
