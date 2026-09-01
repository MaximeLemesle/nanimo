part of 'settings_cubit.dart';

enum SettingsStatus { loading, loaded }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final UserModel? user;
  final NotificationPrefsModel prefs;
  final bool isDeleting;
  final bool isRestoring;
  final RestoreResult? restoreResult;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.loading,
    this.user,
    this.prefs = NotificationPrefsModel.defaults,
    this.isDeleting = false,
    this.isRestoring = false,
    this.restoreResult,
    this.errorMessage,
  });

  /// Null while the user stream has not emitted: the plan is then unknown, not
  /// freemium, and no subscription action may be offered.
  bool get isSubscriptionLoaded => user != null;

  bool get isPremium => user?.subscriptionStatus == SubscriptionStatus.premium;

  SettingsState copyWith({
    SettingsStatus? status,
    UserModel? user,
    NotificationPrefsModel? prefs,
    bool? isDeleting,
    bool? isRestoring,
    RestoreResult? restoreResult,
    bool clearRestoreResult = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      prefs: prefs ?? this.prefs,
      isDeleting: isDeleting ?? this.isDeleting,
      isRestoring: isRestoring ?? this.isRestoring,
      restoreResult:
          clearRestoreResult ? null : restoreResult ?? this.restoreResult,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        prefs,
        isDeleting,
        isRestoring,
        restoreResult,
        errorMessage,
      ];
}
