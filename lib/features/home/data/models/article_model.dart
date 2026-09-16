class ArticleModel {
  final String articleId;
  final String title;
  final List<String> paragraphs;

  /// Never null on a row that reached the device.
  final DateTime publishedAt;

  const ArticleModel({
    required this.articleId,
    required this.title,
    required this.paragraphs,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      articleId: json['id_article'] as String,
      title: json['title'] as String,
      paragraphs: (json['paragraphs'] as List).cast<String>(),
      publishedAt: DateTime.parse(json['published_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_article': articleId,
        'title': title,
        'paragraphs': paragraphs,
        'published_at': publishedAt.toIso8601String(),
      };
}
