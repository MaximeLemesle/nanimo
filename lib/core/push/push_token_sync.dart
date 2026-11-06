import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:nanimo/core/push/push_client.dart';
import 'package:nanimo/core/push/push_token_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';

/// Keeps this device's row in `push_tokens` equal to its session, its system
/// permission and its settings. Network failures wait for the next change.
class PushTokenSync {
  final PushClient _client;
  final PushTokenRepository _repository;
  final SettingsRepository _settingsRepository;
  final Future<bool> Function() _isPermissionGranted;
  final Listenable _permissionChanges;

  StreamSubscription<NotificationPrefsModel>? _prefsSubscription;
  StreamSubscription<String>? _refreshSubscription;
  NotificationPrefsModel? _prefs;
  bool _running = false;

  /// What the server holds for this device, to skip identical writes.
  String? _registeredToken;
  bool? _registeredEnabled;

  PushTokenSync({
    required PushClient client,
    required PushTokenRepository repository,
    required SettingsRepository settingsRepository,
    required Future<bool> Function() isPermissionGranted,
    required Listenable permissionChanges,
  })  : _client = client,
        _repository = repository,
        _settingsRepository = settingsRepository,
        _isPermissionGranted = isPermissionGranted,
        _permissionChanges = permissionChanges;

  void bind(AuthCubit authCubit) {
    if (authCubit.state.isAuthenticated) _start();
    authCubit.stream.listen((auth) {
      if (auth.isAuthenticated) {
        _start();
      } else if (auth.isUnauthenticated) {
        _stop();
      }
    });
  }

  void _start() {
    if (_running) return;
    _running = true;
    _prefsSubscription = _settingsRepository.watchNotificationPrefs().listen((prefs) {
      _prefs = prefs;
      sync();
    });
    _refreshSubscription = _client.tokenRefreshes.listen((_) => sync());
    _permissionChanges.addListener(sync);
  }

  void _stop() {
    _running = false;
    _prefsSubscription?.cancel();
    _refreshSubscription?.cancel();
    _permissionChanges.removeListener(sync);
    _prefs = null;
    _registeredToken = null;
    _registeredEnabled = null;
  }

  Future<void> sync() async {
    final prefs = _prefs;
    if (!_running || prefs == null) return;
    try {
      if (!await _isPermissionGranted()) {
        await unregister();
        return;
      }
      final token = await _client.token();
      if (token == null) return;

      final enabled = prefs.pushEnabled && prefs.newArticles;
      if (token == _registeredToken && enabled == _registeredEnabled) return;
      await _repository.register(token: token, platform: _client.platform, articlesEnabled: enabled);
      _registeredToken = token;
      _registeredEnabled = enabled;
    } catch (e, st) {
      developer.log('push token sync failed', name: 'push', error: e, stackTrace: st);
    }
  }

  /// Runs before sign-out: RLS only lets the owner delete the row.
  Future<void> unregister() async {
    final token = _registeredToken ?? await _client.token();
    if (token == null) return;
    try {
      await _repository.delete(token);
      _registeredToken = null;
      _registeredEnabled = null;
    } catch (e, st) {
      developer.log('push token delete failed', name: 'push', error: e, stackTrace: st);
    }
  }
}
