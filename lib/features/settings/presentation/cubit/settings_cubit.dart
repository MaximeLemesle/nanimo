import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;
  final SubscriptionRestorer _subscriptionRestorer;
  StreamSubscription<UserModel?>? _userSubscription;
  StreamSubscription<NotificationPrefsModel>? _prefsSubscription;

  SettingsCubit({
    required AuthRepository authRepository,
    required SettingsRepository settingsRepository,
    required SubscriptionRestorer subscriptionRestorer,
  })  : _authRepository = authRepository,
        _settingsRepository = settingsRepository,
        _subscriptionRestorer = subscriptionRestorer,
        super(const SettingsState());

  void load() {
    _userSubscription?.cancel();
    _prefsSubscription?.cancel();

    _userSubscription = _authRepository.watchCurrentUser().listen((user) {
      emit(state.copyWith(status: SettingsStatus.loaded, user: user));
    });
    _prefsSubscription = _settingsRepository.watchNotificationPrefs().listen((prefs) {
      emit(state.copyWith(prefs: prefs));
    });
  }

  Future<bool> updateUserName(String userName) async {
    final trimmed = userName.trim();
    if (trimmed.isEmpty) return false;

    try {
      await _authRepository.updateUserName(trimmed);
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: _messageFor(e)));
      return false;
    }
  }

  Future<void> updateNotificationPrefs(NotificationPrefsModel prefs) async {
    emit(state.copyWith(prefs: prefs));
    try {
      await _settingsRepository.saveNotificationPrefs(prefs);
    } catch (e) {
      emit(state.copyWith(errorMessage: _messageFor(e)));
    }
  }

  /// The restorer answers with an outcome instead of throwing, so the three
  /// cases (found, nothing owned, failure) all land in [state.restoreResult].
  Future<void> restorePurchases() async {
    if (state.isRestoring) return;
    emit(state.copyWith(
      isRestoring: true,
      clearError: true,
      clearRestoreResult: true,
    ));

    final result = await _subscriptionRestorer.restore();
    emit(state.copyWith(isRestoring: false, restoreResult: result));
  }

  void clearRestoreResult() {
    if (state.restoreResult != null) {
      emit(state.copyWith(clearRestoreResult: true));
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(isDeleting: true, clearError: true));
    try {
      await _authRepository.deleteAccount();
    } catch (e) {
      emit(state.copyWith(isDeleting: false, errorMessage: _messageFor(e)));
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(clearError: true));
    }
  }

  String _messageFor(Object error) {
    if (error is RepositoryException) return error.message;
    return 'Une erreur est survenue. Réessayez.';
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _prefsSubscription?.cancel();
    return super.close();
  }
}
