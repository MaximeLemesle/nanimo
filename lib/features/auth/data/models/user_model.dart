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

  /// A null date takes nothing away: a lifetime grant or a manual fix in the
  /// database must not be revoked as a side effect.
  bool hasActivePremiumAt(DateTime now) {
    if (subscriptionStatus != SubscriptionStatus.premium) return false;
    final expiresAt = subscriptionExpiresAt;
    return expiresAt == null || !expiresAt.isBefore(now);
  }

  bool get hasActivePremium => hasActivePremiumAt(DateTime.now());

  /// Mirrors `public.effective_plan_name` in migration 0008, and must stay
  /// in step with it.
  String planNameAt(DateTime now) => _subscriptionStatusToString(
      hasActivePremiumAt(now)
          ? SubscriptionStatus.premium
          : SubscriptionStatus.freemium);

  String get planName => planNameAt(DateTime.now());

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
