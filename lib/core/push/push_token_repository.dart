import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushTokenRepository {
  final SupabaseClient _supabase;

  PushTokenRepository(this._supabase);

  Future<void> register({
    required String token,
    required String platform,
    required bool articlesEnabled,
  }) async {
    try {
      await _supabase.rpc('register_push_token', params: {
        'p_token': token,
        'p_platform': platform,
        'p_articles_enabled': articlesEnabled,
      });
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'registerPushToken',
          networkMessage: 'Une connexion internet est requise pour activer les notifications.',
          serverMessage: 'Impossible d’activer les notifications pour le moment.');
    }
  }

  Future<void> delete(String token) async {
    try {
      await _supabase.from('push_tokens').delete().eq('token', token);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deletePushToken',
          networkMessage: 'Une connexion internet est requise pour couper les notifications.',
          serverMessage: 'Impossible de couper les notifications pour le moment.');
    }
  }
}
