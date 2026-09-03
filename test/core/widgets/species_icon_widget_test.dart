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

  String renderedAsset(WidgetTester tester) =>
      (tester.widget<Image>(find.byType(Image)).image as AssetImage).assetName;

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
