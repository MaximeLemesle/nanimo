import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/article_cache.dart';
import 'package:nanimo/features/home/data/article_repository.dart';

import '../../../helpers/isar_test_helper.dart';

void main() {
  final harness = IsarTestHarness();
  late ArticleRepository repo;

  setUp(() async {
    await harness.setUp();
    repo = ArticleRepository(harness.isar);
  });

  tearDown(() => harness.tearDown());

  Future<void> seed(String id, DateTime publishedAt) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.articleCaches.putByArticleId(
        ArticleCache()
          ..articleId = id
          ..title = 'Conseil $id'
          ..paragraphs = ['Un paragraphe de $id']
          ..publishedAt = publishedAt,
      );
    });
  }

  final now = DateTime(2026, 9, 16, 12);

  // NAN-094: published_at carries both the right to publish and the rotation.
  test('serves the most recent published article', () async {
    await seed('old', now.subtract(const Duration(days: 14)));
    await seed('current', now.subtract(const Duration(days: 2)));

    final article = await repo.watchCurrentArticle(now: now).first;

    expect(article!.articleId, 'current');
    expect(article.title, 'Conseil current');
    expect(article.paragraphs, ['Un paragraphe de current']);
  });

  test('serves nothing while the cache is empty', () async {
    expect(await repo.watchCurrentArticle(now: now).first, isNull);
  });

  /// The RLS policy already drops them; the guard restates the rule here.
  test('ignores an article dated ahead', () async {
    await seed('scheduled', now.add(const Duration(days: 7)));
    await seed('current', now.subtract(const Duration(days: 2)));

    final article = await repo.watchCurrentArticle(now: now).first;

    expect(article!.articleId, 'current');
  });

  test('a scheduled article becomes current on its own, the day it comes',
      () async {
    final publishedAt = now.add(const Duration(days: 7));
    await seed('scheduled', publishedAt);

    expect(await repo.watchCurrentArticle(now: now).first, isNull);
    expect(
      (await repo
              .watchCurrentArticle(now: publishedAt.add(const Duration(hours: 1)))
              .first)!
          .articleId,
      'scheduled',
    );
  });
}
