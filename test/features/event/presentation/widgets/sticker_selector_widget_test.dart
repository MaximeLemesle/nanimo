import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders a single sticker and forwards taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      StickerSelectorWidget(
        semanticLabel: 'Type',
        stickers: const [Icon(Icons.star, key: Key('s0'))],
        onTap: () => tapped = true,
      ),
    ));

    expect(find.byKey(const Key('s0')), findsWidgets);

    await tester.tap(find.byType(StickerSelectorWidget));
    expect(tapped, isTrue);
  });

  testWidgets('stacks multiple stickers', (tester) async {
    await tester.pumpWidget(wrap(
      StickerSelectorWidget(
        semanticLabel: 'Animaux',
        stickers: const [
          Icon(Icons.pets, key: Key('a0')),
          Icon(Icons.pets, key: Key('a1')),
          Icon(Icons.pets, key: Key('a2')),
        ],
        onTap: () {},
      ),
    ));

    expect(find.byKey(const Key('a0')), findsWidgets);
    expect(find.byKey(const Key('a2')), findsWidgets);
  });

  testWidgets('renders nothing in the stack when there is no sticker',
      (tester) async {
    await tester.pumpWidget(wrap(
      StickerSelectorWidget(
        semanticLabel: 'Vide',
        stickers: const [],
        onTap: () {},
      ),
    ));

    expect(find.byType(StickerSelectorWidget), findsOneWidget);
  });
}
