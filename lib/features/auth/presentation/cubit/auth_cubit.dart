import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final SyncService _syncService;
  late final StreamSubscription<supabase.AuthState> _authSubscription;

  AuthCubit({
    required AuthRepository repository,
    required SyncService syncService,
  })  : _repository = repository,
        _syncService = syncService,
        super(const AuthState.unknown()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    /// Listen to session changes and trigger sync on sign-in or session restore
    _authSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange
        .listen((supabase.AuthState data) async {
      final session = data.session;

      if (session != null) {
        final isNewSession =
            data.event == supabase.AuthChangeEvent.signedIn ||
            data.event == supabase.AuthChangeEvent.initialSession;

        if (isNewSession) {
          try {
            await _syncService.syncCritical();
          } catch (_) {}
          _syncService.syncSecondary();
        }
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          isSubmitting: false,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          isSubmitting: false,
        ));
      }
    });
  }

  /// Signs in with [email] and [password]
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repository.login(email, password);
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: _formatError(e),
      ));
    }
  }

  /// Creates a new account with [email] and [password]
  Future<void> register(String email, String password) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repository.register(email, password);
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: _formatError(e),
      ));
    }
  }

  /// Signs out the current user
  Future<void> logout() async {
    await _repository.logout();
  }

  /// Clears the current error message (called when user edits a field)
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(clearError: true));
    }
  }

  String _formatError(Object error) {
    if (error is supabase.AuthException) return error.message;
    if (error is Exception) {
      final raw = error.toString();
      return raw.startsWith('Exception: ') ? raw.substring(11) : raw;
    }
    return error.toString();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
