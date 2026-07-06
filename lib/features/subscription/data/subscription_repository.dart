import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

/// Reads always hit Isar so the UI is instant and works offline. Supabase is
/// kept fresh by [SyncService] at app start. [fetchConfigById] forces a
/// Supabase round-trip and write-throughs the cache — used on upgrade.
class SubscriptionRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  SubscriptionRepository(this._supabase, this._isar);

  /// Live stream of the subscription config from the local cache.
  Stream<SubscriptionConfigModel?> watchConfigById(String configId) {
    return _isar.subscriptionConfigCaches
        .filter()
        .configIdEqualTo(configId)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? null : rows.first.toModel());
  }

  /// One-shot read from the cache. Returns null if the config has never been
  /// synced (e.g. first launch offline).
  Future<SubscriptionConfigModel?> getConfigById(String configId) async {
    final row = await _isar.subscriptionConfigCaches.getByConfigId(configId);
    return row?.toModel();
  }

  /// Forces a Supabase fetch and writes through the cache. Used on upgrade or
  /// when the cache is empty. Throws [RepositoryNetworkException] on failure.
  Future<SubscriptionConfigModel> fetchConfigById(String configId) async {
    try {
      final data = await _supabase
          .from('subscription_config')
          .select()
          .eq('id_subscription_config', configId)
          .single();

      final cache = SubscriptionConfigCache.fromJson(data);
      await _isar.writeTxn(() async {
        await _isar.subscriptionConfigCaches.putByConfigId(cache);
      });
      return cache.toModel();
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'fetchConfigById',
          networkMessage:
              'Une connexion internet est requise pour charger votre abonnement.');
    }
  }
}
