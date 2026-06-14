import 'package:flutter/material.dart';

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

  const PetAvatarWidget({
    super.key,
    required this.iconKey,
    this.size = PetAvatarSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/species/$iconKey.png',
      height: size.dimension,
      fit: BoxFit.contain,
    );
  }
}
