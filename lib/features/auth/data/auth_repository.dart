import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isar/isar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';

/// Auth flows always need the network and surface a [RepositoryNetworkException]
/// on failure. Reads of the current [UserModel] are cache-first via Isar, with
/// a Supabase fallback when the cache is empty (first launch, post-signup).
class AuthRepository {
  final SupabaseClient _supabase;
  final Isar _isar;
  final String? _googleIosClientId;
  final String? _googleWebClientId;

  AuthRepository(
    this._supabase,
    this._isar, {
    String? googleIosClientId,
    String? googleWebClientId,
  })  : _googleIosClientId = googleIosClientId,
        _googleWebClientId = googleWebClientId;

  /// Signs in an existing user with email and password.
  Future<void> login(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour se connecter.',
      );
    }
  }

  /// Creates a new account with email and password.
  Future<void> register(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour créer un compte.',
      );
    }
  }

  /// Signs in with Google
  Future<void> signInWithGoogle() async {
    if (_googleIosClientId == null || _googleWebClientId == null) {
      throw const RepositoryNetworkException(
        'Configuration Google manquante.',
      );
    }
    try {
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      await GoogleSignIn.instance.initialize(
        clientId: _googleIosClientId,
        serverClientId: _googleWebClientId,
        nonce: hashedNonce,
      );
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const RepositoryNetworkException('Token Google introuvable.');
      }
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        nonce: rawNonce,
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const RepositoryNetworkException('Connexion Google annulée.');
      }
      rethrow;
    } on AuthException {
      rethrow;
    } on RepositoryNetworkException {
      rethrow;
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour se connecter avec Google.',
      );
    }
  }

  /// Signs in with Apple
  Future<void> signInWithApple() async {
    try {
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const RepositoryNetworkException('Token Apple introuvable.');
      }
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const RepositoryNetworkException('Connexion Apple annulée.');
      }
      rethrow;
    } on AuthException {
      rethrow;
    } on RepositoryNetworkException {
      rethrow;
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour se connecter avec Apple.',
      );
    }
  }

  /// Signs out the current user.
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  /// Live auth state — used by Go Router to redirect on sign-in / sign-out.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Current Supabase auth session token, or null if signed out.
  String? get currentToken => _supabase.auth.currentSession?.accessToken;

  /// Current authenticated user id, or null if signed out.
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // ---------------------------------------------------------------------------
  // Current-user reads (cache-first)
  // ---------------------------------------------------------------------------

  /// Live current user from the local cache. Emits null while signed out or
  /// before the first sync populates the cache. The caller must re-subscribe
  /// after a sign-in/sign-out to bind the stream to the new user id.
  Stream<UserModel?> watchCurrentUser() {
    final id = currentUserId;
    if (id == null) return Stream.value(null);

    return _isar.userCaches
        .filter()
        .userIdEqualTo(id)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? null : rows.first.toModel());
  }

  /// One-shot read of the signed-in user. Falls back to a Supabase fetch
  Future<UserModel?> getCurrentUser() async {
    final id = currentUserId;
    if (id == null) return null;

    final cached = await _isar.userCaches.getByUserId(id);
    if (cached != null) return cached.toModel();

    try {
      final data =
          await _supabase.from('users').select().eq('id_user', id).single();
      final cache = UserCache.fromJson(data);
      await _isar.writeTxn(() async {
        await _isar.userCaches.putByUserId(cache);
      });
      return cache.toModel();
    } catch (_) {
      return null;
    }
  }
}
