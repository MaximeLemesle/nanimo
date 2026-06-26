import 'package:flutter/material.dart';

class SpeciesIconWidget extends StatelessWidget {
  final String iconKey;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SpeciesIconWidget({
    super.key,
    required this.iconKey,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    /// Increase rabbit asset height
    final resolvedHeight =
        height != null && iconKey == 'rabbit' ? height! * 1.2 : height;
    return Image.asset(
      'assets/icons/species/$iconKey.png',
      width: width,
      height: resolvedHeight,
      fit: fit,
    );
  }
}
