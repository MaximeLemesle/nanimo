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

  /// Decode size in physical pixels for a logical [dimension]. Source files are
  /// 512px squares, so an avatar drawn at 40pt would otherwise hold a full
  /// 512x512 bitmap in memory, eighteen times the pixels it puts on screen.
  int? _decodeSize(BuildContext context, double? dimension) {
    if (dimension == null || !dimension.isFinite || dimension <= 0) return null;
    return (dimension * MediaQuery.devicePixelRatioOf(context)).round();
  }

  @override
  Widget build(BuildContext context) {
    final speciesAsset = PetIconResolver.speciesAsset(iconKey);

    /// Increase rabbit asset height. Catalogue icons are framed alike, so the
    /// correction only applies to the generic asset it was measured on.
    final resolvedHeight =
        assetPath == null && height != null && iconKey == 'rabbit'
            ? height! * 1.2
            : height;

    /// Only one axis is constrained: giving both would distort a source whose
    /// aspect ratio is not exactly the box it is drawn in.
    final cacheWidth = _decodeSize(context, width);
    final cacheHeight = cacheWidth == null ? _decodeSize(context, height) : null;

    return Image.asset(
      assetPath ?? speciesAsset,
      width: width,
      height: resolvedHeight,
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
