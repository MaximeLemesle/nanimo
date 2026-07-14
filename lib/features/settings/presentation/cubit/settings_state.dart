part of 'settings_cubit.dart';

enum SettingsStatus { loading, loaded }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final UserModel? user;
  final NotificationPrefsModel prefs;
  final bool isDeleting;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.loading,
    this.user,
    this.prefs = NotificationPrefsModel.defaults,
    this.isDeleting = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    UserModel? user,
    NotificationPrefsModel? prefs,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      prefs: prefs ?? this.prefs,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, prefs, isDeleting, errorMessage];
}
