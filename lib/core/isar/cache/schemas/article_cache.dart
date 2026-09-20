import 'package:isar/isar.dart';
import 'package:nanimo/features/home/data/models/article_model.dart';

part 'article_cache.g.dart';

@Collection()
class ArticleCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String articleId;

  late String title;

  late List<String> paragraphs;

  @Index()
  late DateTime publishedAt;

  ArticleCache();

  /// Maps a Supabase [json] row to an [ArticleCache] instance
  factory ArticleCache.fromJson(Map<String, dynamic> json) {
    return ArticleCache()
      ..articleId = json['id_article'] as String
      ..title = json['title'] as String
      ..paragraphs = (json['paragraphs'] as List).cast<String>()
      ..publishedAt = DateTime.parse(json['published_at'] as String);
  }

  /// Builds an [ArticleCache] from an [ArticleModel]
  factory ArticleCache.fromModel(ArticleModel model) {
    return ArticleCache()
      ..articleId = model.articleId
      ..title = model.title
      ..paragraphs = model.paragraphs
      ..publishedAt = model.publishedAt;
  }

  /// Converts this cache row into the domain [ArticleModel]
  ArticleModel toModel() {
    return ArticleModel(
      articleId: articleId,
      title: title,
      paragraphs: paragraphs,
      publishedAt: publishedAt,
    );
  }
}
