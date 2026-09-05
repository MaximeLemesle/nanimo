import 'package:flutter/material.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';

class SpeciesIconWidget extends StatelessWidget {
  final PetPortrait portrait;
  final double? width;
  final double? height;
  final BoxFit fit;
  const SpeciesIconWidget({
    super.key,
    required this.portrait,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  int? _decodeSize(BuildContext context, double? dimension) {
    if (dimension == null || !dimension.isFinite || dimension <= 0) return null;
    return (dimension * MediaQuery.devicePixelRatioOf(context)).round();
  }

  @override
  Widget build(BuildContext context) {
    final speciesAsset = PetIconResolver.speciesAsset(portrait.iconKey);
    final assetPath = portrait.assetPath;

    /// Only one axis is constrained: giving both would distort a source whose
    /// aspect ratio is not exactly the box it is drawn in.
    final cacheWidth = _decodeSize(context, width);
    final cacheHeight = cacheWidth == null ? _decodeSize(context, height) : null;

    return Image.asset(
      assetPath ?? speciesAsset,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        speciesAsset,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      ),
    );
  }
}
