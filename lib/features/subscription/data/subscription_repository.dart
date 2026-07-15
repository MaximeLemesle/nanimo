import 'dart:developer' as developer;

import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

/// Reads always hit Isar so the UI is instant and works offline. Supabase is
/// kept fresh by [SyncService] at app start. [fetchConfigByPlanName] forces a
/// Supabase round-trip and write-throughs the cache — used on upgrade.
class SubscriptionRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  SubscriptionRepository(this._supabase, this._isar);

  /// Live stream of the subscription config from the local cache.
  Stream<SubscriptionConfigModel?> watchConfigByPlanName(String planName) {
    return _isar.subscriptionConfigCaches
        .filter()
        .planNameEqualTo(planName)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? null : rows.first.toModel());
  }

  /// One-shot read from the cache. Returns null if the config has never been
  /// synced (e.g. first launch offline).
  Future<SubscriptionConfigModel?> getConfigByPlanName(String planName) async {
    final row = await _isar.subscriptionConfigCaches.getByPlanName(planName);
    return row?.toModel();
  }

  /// Forces a Supabase fetch and writes through the cache. Used on upgrade or
  /// when the cache is empty. Throws [RepositoryNetworkException] on failure.
  Future<SubscriptionConfigModel> fetchConfigByPlanName(String planName) async {
    final SubscriptionConfigCache cache;
    try {
      final data = await _supabase
          .from('subscription_config')
          .select()
          .eq('plan_name', planName)
          .single();

      cache = SubscriptionConfigCache.fromJson(data);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'fetchConfigByPlanName',
          networkMessage:
              'Une connexion internet est requise pour charger votre abonnement.',
          serverMessage: 'Impossible de charger votre abonnement pour le moment.');
    }

    /// Write-through is an optimisation for the next launch. A broken cache must
    /// not deny the caller a config the server just handed over.
    try {
      await _isar.writeTxn(() async {
        await _isar.subscriptionConfigCaches.putByPlanName(cache);
      });
    } catch (e, st) {
      developer.log('config cache write failed for plan "$planName"',
          name: 'subscription', error: e, stackTrace: st);
    }

    return cache.toModel();
  }
}
