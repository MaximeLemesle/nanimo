import 'dart:developer' as developer;

import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/article_cache.dart';
import 'package:nanimo/features/home/data/models/article_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads the home tips from the Isar cache, never from Supabase, which only
/// feeds that cache through [SyncService].
class ArticleRepository {
  final Isar _isar;
  final SupabaseClient _supabase;

  ArticleRepository(this._isar, this._supabase);

  /// The published article with the most recent date. Older rows are archives,
  /// and a future date never reaches the cache anyway.
  Stream<ArticleModel?> watchCurrentArticle({DateTime? now}) {
    return _isar.articleCaches
        .where()
        .sortByPublishedAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => _current(rows, now ?? DateTime.now()));
  }

  /// A tapped push can beat the sync, hence the database as a fallback.
  /// Null when the article is unreachable or unpublished.
  Future<ArticleModel?> findArticle(String articleId) async {
    final cached = await _isar.articleCaches.getByArticleId(articleId);
    if (cached != null) return cached.toModel();
    try {
      final row = await _supabase.from('articles').select().eq('id_article', articleId).maybeSingle();
      return row == null ? null : ArticleModel.fromJson(row);
    } catch (e, st) {
      developer.log('findArticle failed', name: 'articles', error: e, stackTrace: st);
      return null;
    }
  }

  static ArticleModel? _current(List<ArticleCache> rows, DateTime now) {
    for (final row in rows) {
      if (!row.publishedAt.isAfter(now)) return row.toModel();
    }
    return null;
  }
}
