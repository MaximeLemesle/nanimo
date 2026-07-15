enum SubscriptionStatus { freemium, premium }

class UserModel {
  final String userId;
  final String userName;
  final String mail;
  final SubscriptionStatus subscriptionStatus;
  final DateTime? subscriptionExpiresAt;

  const UserModel({
    required this.userId,
    required this.userName,
    required this.mail,
    required this.subscriptionStatus,
    this.subscriptionExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id_user'],
      userName: json['user_name'],
      mail: json['mail'],
      subscriptionStatus: _parseSubscriptionStatus(json['subscription_status']),
      subscriptionExpiresAt: json['subscription_expires_at'] != null ? DateTime.parse(json['subscription_expires_at'] as String) : null,
    );
  }

  String get planName => _subscriptionStatusToString(subscriptionStatus);

  Map<String, dynamic> toJson() => {
        'id_user': userId,
        'user_name': userName,
        'mail': mail,
        'subscription_status': _subscriptionStatusToString(subscriptionStatus),
        'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
      };
}

SubscriptionStatus _parseSubscriptionStatus(String value) {
  switch (value) {
    case 'premium':
      return SubscriptionStatus.premium;
    case 'freemium':
      return SubscriptionStatus.freemium;
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
