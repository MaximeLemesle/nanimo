import 'package:isar/isar.dart';

part 'article_sync_cache.g.dart';

/// When the articles were last pulled. A single row, so the id is fixed.
@Collection()
class ArticleSyncCache {
  static const int singletonId = 0;

  Id id = singletonId;

  late DateTime syncedAt;

  ArticleSyncCache();

  factory ArticleSyncCache.at(DateTime syncedAt) {
    return ArticleSyncCache()..syncedAt = syncedAt;
  }
}
