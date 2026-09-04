import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';

void main() {
  Widget build({String iconKey = 'cat', String? assetPath, double? height}) {
    return MaterialApp(
      home: Center(
        child: SpeciesIconWidget(
          iconKey: iconKey,
          assetPath: assetPath,
          height: height,
        ),
      ),
    );
  }

  String renderedAsset(WidgetTester tester) {
    final provider = tester.widget<Image>(find.byType(Image)).image;
    final asset = provider is ResizeImage ? provider.imageProvider : provider;
    return (asset as AssetImage).assetName;
  }

  testWidgets('falls back to the species asset without a chosen icon',
      (tester) async {
    await tester.pumpWidget(build());

    expect(renderedAsset(tester), 'assets/icons/species/cat.png');
  });

  testWidgets('renders the chosen catalogue icon when given one',
      (tester) async {
    await tester.pumpWidget(
      build(assetPath: 'assets/icons/species/dog.png'),
    );

    expect(renderedAsset(tester), 'assets/icons/species/dog.png');
  });

  /// The correction was measured on the generic rabbit asset, so a catalogue
  /// icon, framed like every other, must not inherit it.
  /// A 512px source drawn at 40pt would otherwise keep 18x the pixels it needs.
  testWidgets('decodes at the drawn size, not the source size', (tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(build(height: 40));

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as ResizeImage).height, 120);
    expect((image.image as ResizeImage).width, isNull);
  });

  testWidgets('leaves the source untouched when no size is given',
      (tester) async {
    await tester.pumpWidget(build());

    expect(tester.widget<Image>(find.byType(Image)).image, isA<AssetImage>());
  });

  testWidgets('stretches the generic rabbit asset only', (tester) async {
    await tester.pumpWidget(build(iconKey: 'rabbit', height: 100));
    expect(tester.getSize(find.byType(Image)).height, 120);

    await tester.pumpWidget(build(
      iconKey: 'rabbit',
      assetPath: 'assets/icons/species/dog.png',
      height: 100,
    ));
    expect(tester.getSize(find.byType(Image)).height, 100);
  });
}
