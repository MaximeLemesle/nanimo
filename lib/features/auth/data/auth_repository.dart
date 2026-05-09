import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// Signs in an existing user with email and password
  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Creates a new account with email and password
  Future<void> register(String email, String password) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Signs out the current user
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  String? get currentToken => _supabase.auth.currentSession?.accessToken;
}
