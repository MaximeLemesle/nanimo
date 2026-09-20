import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/home/data/models/article_model.dart';
import 'package:nanimo/features/home/presentation/widgets/home_article_card_widget.dart';

const _fallbackTitle = 'La mue d’automne : le grand retour des poils partout';

final _remote = ArticleModel(
  articleId: 'a1',
  title: 'Les dents de ton chat méritent mieux',
  paragraphs: [
    'Le tartre s’installe bien avant que ça ne se voie.',
    'Un contrôle annuel suffit à prendre les choses à temps.',
  ],
  publishedAt: DateTime(2026, 9, 14),
);

void main() {
  Future<void> pumpCard(WidgetTester tester, {ArticleModel? article}) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: HomeArticleCardWidget(article: article)),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('keeps its title whatever it shows', (tester) async {
    await pumpCard(tester, article: _remote);

    expect(find.text('Le conseil de la semaine'), findsOneWidget);
  });

  // NAN-094: an empty card is worse than a frozen article.
  testWidgets('falls back on the embedded tip with no article', (tester) async {
    await pumpCard(tester);

    expect(find.text(_fallbackTitle), findsOneWidget);
  });

  testWidgets('shows the article from the cache when there is one',
      (tester) async {
    await pumpCard(tester, article: _remote);

    expect(find.text('Les dents de ton chat méritent mieux'), findsOneWidget);
    expect(find.text(_fallbackTitle), findsNothing);
  });

  testWidgets('opens the full article in the reading sheet', (tester) async {
    await pumpCard(tester, article: _remote);

    await tester.tap(find.text('Lire la suite'));
    await tester.pumpAndSettle();

    expect(
      find.text('Un contrôle annuel suffit à prendre les choses à temps.'),
      findsOneWidget,
    );
  });

  testWidgets('the reading sheet also serves the fallback', (tester) async {
    await pumpCard(tester);

    await tester.tap(find.text('Lire la suite'));
    await tester.pumpAndSettle();

    expect(find.text(_fallbackTitle), findsWidgets);
  });
}
