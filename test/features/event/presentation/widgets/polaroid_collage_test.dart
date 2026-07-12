import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows the empty placeholder when no image is selected',
      (tester) async {
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(images: const [], onTap: () {}),
    ));

    expect(find.byIcon(Icons.photo), findsWidgets);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('renders a frame per picked local image', (tester) async {
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(
        images: [
          LocalCollageImage(XFile('a.jpg')),
          LocalCollageImage(XFile('b.jpg')),
        ],
        onTap: () {},
      ),
    ));

    expect(find.byType(Image), findsNWidgets(2));
    expect(find.byIcon(Icons.photo), findsNothing);
  });

  testWidgets('resolves remote images through urlResolver', (tester) async {
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(
        images: const [
          RemoteCollageImage(eventImageId: 'img-1', assetPath: 'a/b.jpg'),
        ],
        onTap: () {},
        urlResolver: (assetPath) async => 'https://example.com/$assetPath',
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('forwards taps through onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(images: const [], onTap: () => tapped = true),
    ));

    await tester.tap(find.byType(PolaroidCollageWidget));
    expect(tapped, isTrue);
  });

  testWidgets('forwards a single-photo tap through onImageTap', (tester) async {
    int? tappedIndex;
    await tester.pumpWidget(wrap(
      PolaroidCollageWidget(
        images: [LocalCollageImage(XFile('a.jpg'))],
        onTap: () {},
        onImageTap: (index) => tappedIndex = index,
      ),
    ));

    await tester.tap(find.byType(Image));
    expect(tappedIndex, 0);
  });
}
