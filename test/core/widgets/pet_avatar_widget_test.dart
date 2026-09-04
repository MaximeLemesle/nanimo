import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';

void main() {
  Widget buildAvatar({PetAvatarSize? size}) {
    return MaterialApp(
      home: Center(
        child: size == null
            ? const PetAvatarWidget(iconKey: 'cat')
            : PetAvatarWidget(iconKey: 'cat', size: size),
      ),
    );
  }

  testWidgets('renders the avatar from the species icon key', (tester) async {
    await tester.pumpWidget(buildAvatar(size: PetAvatarSize.large));

    /// The avatar is decoded at its drawn size, so the asset sits behind a
    /// ResizeImage rather than being the provider itself.
    final provider = tester.widget<Image>(find.byType(Image)).image;
    expect(
      ((provider as ResizeImage).imageProvider as AssetImage).assetName,
      'assets/icons/species/cat.png',
    );
  });

  testWidgets('each size renders at its declared height', (tester) async {
    for (final size in PetAvatarSize.values) {
      await tester.pumpWidget(buildAvatar(size: size));

      final renderedSize = tester.getSize(find.byType(PetAvatarWidget));
      expect(renderedSize.height, size.dimension);
    }
  });

  testWidgets('defaults to medium size', (tester) async {
    await tester.pumpWidget(buildAvatar());

    final renderedSize = tester.getSize(find.byType(PetAvatarWidget));
    expect(renderedSize.height, PetAvatarSize.medium.dimension);
  });
}
