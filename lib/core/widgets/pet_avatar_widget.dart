import 'package:flutter/material.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';

enum PetAvatarSize {
  small(40),
  medium(80),
  large(160);

  const PetAvatarSize(this.dimension);

  final double dimension;
}

class PetAvatarWidget extends StatelessWidget {
  final String iconKey;
  final PetAvatarSize size;
  final String? assetPath;

  const PetAvatarWidget({
    super.key,
    required this.iconKey,
    this.size = PetAvatarSize.medium,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return SpeciesIconWidget(
      iconKey: iconKey,
      height: size.dimension,
      assetPath: assetPath,
    );
  }
}
