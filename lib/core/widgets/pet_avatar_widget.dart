import 'package:flutter/material.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';

enum PetAvatarSize {
  small(40),
  medium(80),
  large(140);

  const PetAvatarSize(this.dimension);

  final double dimension;
}

class PetAvatarWidget extends StatelessWidget {
  final PetPortrait portrait;
  final PetAvatarSize size;

  const PetAvatarWidget({
    super.key,
    required this.portrait,
    this.size = PetAvatarSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return SpeciesIconWidget(
      portrait: portrait,
      height: size.dimension,
    );
  }
}
