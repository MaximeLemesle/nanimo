import 'package:isar/isar.dart';
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

  AuthRepository(this._supabase, this._isar);

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
