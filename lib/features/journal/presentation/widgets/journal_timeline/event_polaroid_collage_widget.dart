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

    return SizedBox(
      height: _resolveHeight(),
      width: double.infinity,
      child: assetPaths.length == 1 ? _buildSingle() : _buildCollage(),
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

  double _resolveHeight() {
    const padding = AppSpacing.xs * 2;
    if (assetPaths.length == 1) {
      return _singleFrameSize + padding;
    }

    final count = assetPaths.take(maxImages).length;
    var half = 0.0;
    for (final p in _placements(count)) {
      final full = p.size + padding;
      final extent =
          (full / 2) * (math.cos(p.angle).abs() + math.sin(p.angle).abs());
      half = math.max(half, p.offset.dy.abs() + extent);
    }
    return 2 * half;
  }

  Widget _buildSingle() {
    return Center(
      child: _frame(
        size: _singleFrameSize,
        assetPath: assetPaths.first,
      ),
    );
  }

  Widget _buildCollage() {
    final visible = assetPaths.take(maxImages).toList();
    final placements = _placements(visible.length);
    return Center(
      child: Stack(
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
      ),
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
        border: Border.all(color: AppColors.backgroundStroke, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
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
          fit: BoxFit.cover,
          placeholder: (context, url) => _placeholder(),
          errorWidget: (context, url, error) =>
              _placeholder(icon: Icons.broken_image_outlined),
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
