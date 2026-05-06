import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:nanimo/features/auth/data/auth.repository.dart';

part 'auth.state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  late final StreamSubscription<supabase.AuthState> _authSubscription;

  AuthCubit({ required AuthRepository repository }) : 
    _repository = repository,
    super(const AuthState.unknown()) { 
      _listenToAuthChanges();
    }
    

  void _listenToAuthChanges() {
    /// listen session changement
    _authSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange.listen(
      (supabase.AuthState data) {
        final session = data.session;
        session != null
          ? emit(const AuthState.authenticated())
          : emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> login(String email, String password) async {
    try {
      await _repository.login(email, password);
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}