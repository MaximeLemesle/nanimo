import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

class JournalTimelinePolaroidCollageWidget extends StatelessWidget {
  final List<String> assetPaths;
  final Future<String> Function(String assetPath) urlResolver;

  const JournalTimelinePolaroidCollageWidget({
    super.key,
    required this.assetPaths,
    required this.urlResolver,
  });

  static const int maxImages = 5;
  static const double _singleFrameSize = 120;
  static const double _backFrameSize = 120;
  static const double _frontFrameSize = 70;
  static const Offset _backOffset = Offset(8, -22);
  static const double _backAngle = 0.04;
  static const double _frameBorderWidth = 2;
  static const double _frameShadowBlur = 8;
  static const double _frameShadowDy = 4;

  /// Width the polaroid frame adds around the photo: inner padding + border.
  static const double _frameChrome = AppSpacing.xs * 2 + _frameBorderWidth * 2;

  /// How far the drop shadow bleeds past the frame edge, per axis. Counted in
  /// the collage box so the shadow is not cut in turn once the frames fit.
  static const double _shadowBleedX = _frameShadowBlur;
  static const double _shadowBleedY = _frameShadowBlur + _frameShadowDy;

  /// Smaller frames in front of the back one
  static const List<Offset> _frontOffsets = [
    Offset(-40, 30), // 4
    Offset(-20, 60), // 3
    Offset(15, 55), // 2
    Offset(45, 35), // 1
  ];
  static const List<double> _frontAngles = [-0.09, 0.07, 0.11, -0.06];

  @override
  Widget build(BuildContext context) {
    if (assetPaths.isEmpty) return const SizedBox.shrink();

    final natural = _naturalSize();
    final collage = SizedBox.fromSize(
      size: natural,
      child: assetPaths.length == 1 ? _buildSingle() : _buildCollage(),
    );

    /// The collage is laid out at its natural size, then scaled down when the
    /// half-row it sits in is narrower than that — the frames fan out well past
    /// the widest photo, and would otherwise be clipped on the sides.
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(1.0, constraints.maxWidth / natural.width);
        return SizedBox(
          height: natural.height * scale,
          width: double.infinity,
          child: FittedBox(child: collage),
        );
      },
    );
  }

  List<({Offset offset, double angle, double size})> _placements(int count) {
    final result = <({Offset offset, double angle, double size})>[
      (offset: _backOffset, angle: _backAngle, size: _backFrameSize),
    ];
    for (var i = 0; i < count - 1 && i < _frontOffsets.length; i++) {
      result.add((
        offset: _frontOffsets[i],
        angle: _frontAngles[i],
        size: _frontFrameSize,
      ));
    }
    return result;
  }

  /// Bounding box of everything the collage paints, shadows included. The
  /// [Stack] only reserves room for its largest frame, so without this the
  /// frames fanned out by [Transform.translate] land outside the widget box and
  /// get cut by the journal's scroll viewport.
  Size _naturalSize() {
    if (assetPaths.length == 1) {
      const full = _singleFrameSize + _frameChrome;
      return const Size(full + _shadowBleedX * 2, full + _shadowBleedY * 2);
    }

    final count = assetPaths.take(maxImages).length;
    var halfWidth = 0.0;
    var halfHeight = 0.0;
    for (final p in _placements(count)) {
      final full = p.size + _frameChrome;

      /// Half-extent of the frame's axis-aligned bounding box once rotated.
      final extent = (full / 2) * (math.cos(p.angle).abs() + math.sin(p.angle).abs());
      halfWidth = math.max(halfWidth, p.offset.dx.abs() + extent + _shadowBleedX);
      halfHeight = math.max(halfHeight, p.offset.dy.abs() + extent + _shadowBleedY);
    }
    return Size(2 * halfWidth, 2 * halfHeight);
  }

  Widget _buildSingle() {
    return Center(
      child: _frame(
        size: _singleFrameSize,
        assetPath: assetPaths.first,
      ),
    );
  }

  /// Sized by the parent, not by its largest child: the [Stack] is handed the
  /// tight [_naturalSize] box so the translated frames stay inside the widget.
  Widget _buildCollage() {
    final visible = assetPaths.take(maxImages).toList();
    final placements = _placements(visible.length);
    return Stack(
      alignment: Alignment.center,
      children: [
        for (var i = 0; i < visible.length; i++)
          Transform.translate(
            offset: placements[i].offset,
            child: Transform.rotate(
              angle: placements[i].angle,
              child: _frame(
                assetPath: visible[i],
                size: placements[i].size,
              ),
            ),
          ),
      ],
    );
  }

  Widget _frame({
    required String assetPath,
    double size = _frontFrameSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.backgroundStroke, width: _frameBorderWidth),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: _frameShadowBlur,
            offset: Offset(0, _frameShadowDy),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm / 2),
          child: _RemoteImage(
            assetPath: assetPath,
            urlResolver: urlResolver,
          ),
        ),
      ),
    );
  }
}

class _RemoteImage extends StatelessWidget {
  final String assetPath;
  final Future<String> Function(String assetPath) urlResolver;

  const _RemoteImage({required this.assetPath, required this.urlResolver});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: urlResolver(assetPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _placeholder();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return _placeholder(icon: Icons.broken_image_outlined);
        }
        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          cacheKey: assetPath,
          fit: BoxFit.cover,
          placeholder: (context, url) => _placeholder(),
          errorWidget: (context, url, error) => _placeholder(icon: Icons.broken_image_outlined),
        );
      },
    );
  }

  Widget _placeholder({IconData icon = Icons.photo}) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary, size: AppSpacing.xl),
    );
  }
}
