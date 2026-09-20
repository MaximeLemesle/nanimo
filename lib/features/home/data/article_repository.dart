import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/article_cache.dart';
import 'package:nanimo/features/home/data/models/article_model.dart';

/// Reads the home tips from the Isar cache, never from Supabase, which only
/// feeds that cache through [SyncService].
class ArticleRepository {
  final Isar _isar;

  ArticleRepository(this._isar);

  /// The published article with the most recent date. Older rows are archives,
  /// and a future date never reaches the cache anyway.
  Stream<ArticleModel?> watchCurrentArticle({DateTime? now}) {
    return _isar.articleCaches
        .where()
        .sortByPublishedAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => _current(rows, now ?? DateTime.now()));
  }

  static ArticleModel? _current(List<ArticleCache> rows, DateTime now) {
    for (final row in rows) {
      if (!row.publishedAt.isAfter(now)) return row.toModel();
    }
    return null;
  }
}
