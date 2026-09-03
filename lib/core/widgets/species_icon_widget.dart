import 'package:flutter/material.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';

class SpeciesIconWidget extends StatelessWidget {
  final String iconKey;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Catalogue icon chosen for one pet. Null means the pet never picked one, so
  /// the generic species asset is used instead.
  final String? assetPath;

  const SpeciesIconWidget({
    super.key,
    required this.iconKey,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final speciesAsset = PetIconResolver.speciesAsset(iconKey);

    /// Increase rabbit asset height. Catalogue icons are framed alike, so the
    /// correction only applies to the generic asset it was measured on.
    final resolvedHeight =
        assetPath == null && height != null && iconKey == 'rabbit'
            ? height! * 1.2
            : height;

    return Image.asset(
      assetPath ?? speciesAsset,
      width: width,
      height: resolvedHeight,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        speciesAsset,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
