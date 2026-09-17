import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import '../../../../helpers/app_icon_finder.dart';

import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/config/theme/app_colors.dart';

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

  // NAN-093: the empty collage promised five slots to every owner.
  group('premium frames', () {
    testWidgets('marks nothing when told nothing', (tester) async {
      await tester.pumpWidget(wrap(
        PolaroidCollageWidget(images: const [], onTap: () {}),
      ));

      expect(findAppIcon(AppIcons.crown), findsNothing);
    });

    testWidgets('crowns every frame beyond the free one', (tester) async {
      await tester.pumpWidget(wrap(
        PolaroidCollageWidget(
          images: const [],
          onTap: () {},
          premiumFromIndex: 1,
        ),
      ));

      expect(findAppIcon(AppIcons.crown), findsNWidgets(4));
    });

    testWidgets('keeps the crown out of a premium collage', (tester) async {
      await tester.pumpWidget(wrap(
        PolaroidCollageWidget(
          images: const [],
          onTap: () {},
          premiumFromIndex: null,
        ),
      ));

      expect(findAppIcon(AppIcons.crown), findsNothing);
    });

    testWidgets('respects the convention: crown only, tertiary, size 18',
        (tester) async {
      await tester.pumpWidget(wrap(
        PolaroidCollageWidget(
          images: const [],
          onTap: () {},
          premiumFromIndex: 1,
        ),
      ));

      final crown = tester.widget<AppIconWidget>(
        findAppIcon(AppIcons.crown).first,
      );
      expect(crown.color, AppColors.tertiary);
      expect(crown.size, 18);
      expect(find.byIcon(Icons.lock), findsNothing);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
      expect(find.text('Premium'), findsNothing);
    });

    /// NAN-093: the frame the owner can fill is the one painted last, so it
    /// sits on top of the pile and the locked ones stack up behind it.
    testWidgets('leaves the free frame on top of the pile', (tester) async {
      await tester.pumpWidget(wrap(
        PolaroidCollageWidget(
          images: const [],
          onTap: () {},
          premiumFromIndex: 1,
        ),
      ));

      final pile = tester.widget<Stack>(
        find.descendant(
          of: find.byType(PolaroidCollageWidget),
          matching: find.byType(Stack),
        ).first,
      );

      /// A Stack paints its children in order: the last one is the top frame.
      final crowns = [
        for (final child in pile.children)
          find
              .descendant(
                of: find.byWidget(child),
                matching: findAppIcon(AppIcons.crown),
              )
              .evaluate()
              .isNotEmpty,
      ];

      expect(crowns.length, 5);
      expect(crowns.last, isFalse, reason: 'the top frame must stay free');
      expect(crowns.sublist(0, 4), everyElement(isTrue));
    });

    /// The pile is the "add a photo" affordance, so no frame takes the tap.
    testWidgets('leaves the collage its one gesture', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(wrap(
        PolaroidCollageWidget(
          images: const [],
          onTap: () => tapped++,
          premiumFromIndex: 1,
        ),
      ));

      await tester.tap(find.byType(PolaroidCollageWidget));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });
  });
}
