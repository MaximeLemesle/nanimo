import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

sealed class CollageImage {
  const CollageImage();
}

class LocalCollageImage extends CollageImage {
  final XFile file;
  const LocalCollageImage(this.file);
}

class RemoteCollageImage extends CollageImage {
  final String eventImageId;
  final String assetPath;
  const RemoteCollageImage({
    required this.eventImageId,
    required this.assetPath,
  });
}

class PolaroidCollageWidget extends StatelessWidget {
  final List<CollageImage> images;
  final VoidCallback onTap;
  final void Function(int index)? onImageTap;
  final Future<String> Function(String assetPath)? urlResolver;

  const PolaroidCollageWidget({
    super.key,
    required this.images,
    required this.onTap,
    this.onImageTap,
    this.urlResolver,
  });

  static const int maxImages = 5;
  static const double _collageFrameSize = 140;
  static const double _singleFrameSize = 200;
  static const int _placeholderFrameCount = 5;
  static const double _placeholderBackRaise = 30;

  static const List<double> _angles = [-0.06, 0.05, -0.04, 0.07, -0.03];
  static const List<Offset> _offsets = [
    Offset(-70, -40),
    Offset(90, -20),
    Offset(0, 20),
    Offset(-90, 80),
    Offset(80, 70),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: _resolveHeight(),
        width: double.infinity,
        child: images.isEmpty ? _buildPlaceholder() : _buildCollage(),
      ),
    );
  }

  double _resolveHeight() {
    const padding = AppSpacing.xs * 2;
    if (images.length == 1) {
      return _singleFrameSize + padding;
    }

    final isPlaceholder = images.isEmpty;
    final count =
        isPlaceholder ? _placeholderFrameCount : images.take(maxImages).length;
    final outer = _collageFrameSize + padding;
    var half = 0.0;
    for (var i = 0; i < count; i++) {
      final dy = _frameOffset(i).dy.abs();
      final angle = _angles[i].abs();
      final extent = (outer / 2) * (math.cos(angle) + math.sin(angle));
      half = math.max(half, dy + extent);
    }
    return 2 * half;
  }

  Offset _frameOffset(int index) => index < _placeholderFrameCount - 1
      ? _offsets[index].translate(0, -_placeholderBackRaise)
      : _offsets[index];

  Widget _buildPlaceholder() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < _placeholderFrameCount; i++)
            Transform.translate(
              offset: _frameOffset(i),
              child: Transform.rotate(
                angle: _angles[i],
                child: _frame(
                  dashed: true,
                  child: Icon(
                    Icons.photo,
                    size: AppSpacing.xl,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCollage() {
    /// A single image is displayed larger
    if (images.length == 1) {
      return Center(
        child: _tappable(
          0,
          _frame(
            size: _singleFrameSize,
            child: _image(images.first, _singleFrameSize + 10),
          ),
        ),
      );
    }

    final visible = images.take(maxImages).toList();
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < visible.length; i++)
            Transform.translate(
              offset: _frameOffset(i),
              child: Transform.rotate(
                angle: _angles[i],
                child: _tappable(
                  i,
                  _frame(
                    child: _image(visible[i], 150),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _image(CollageImage image, double size) {
    return switch (image) {
      LocalCollageImage(:final file) => Image.file(
          File(file.path),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      RemoteCollageImage(:final assetPath) => FutureBuilder<String>(
          future: urlResolver!(assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _imagePlaceholder(size);
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return _imagePlaceholder(size, icon: Icons.broken_image_outlined);
            }
            return CachedNetworkImage(
              imageUrl: snapshot.data!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (_, __) => _imagePlaceholder(size),
              errorWidget: (_, __, ___) =>
                  _imagePlaceholder(size, icon: Icons.broken_image_outlined),
            );
          },
        ),
    };
  }

  Widget _imagePlaceholder(double size, {IconData icon = Icons.photo}) {
    return Container(
      width: size,
      height: size,
      color: AppColors.background,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary, size: AppSpacing.xl),
    );
  }

  Widget _tappable(int index, Widget frame) {
    if (onImageTap == null) return frame;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onImageTap!(index),
      child: frame,
    );
  }

  Widget _frame({
    required Widget child,
    double size = _collageFrameSize,
    bool dashed = false,
  }) {
    final content = Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: dashed
            ? null
            : Border.all(color: AppColors.backgroundStroke, width: 2),
        boxShadow: dashed
            ? null
            : const [
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
          child: child,
        ),
      ),
    );

    if (!dashed) return content;

    /// Dashed outline drawn over the empty frame.
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: AppColors.backgroundStroke,
        radius: AppRadius.sm,
      ),
      child: content,
    );
  }
}

/// Paints a dashed rounded-rectangle border around its child.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth = 2;
  final double dashLength = 6;
  final double gapLength = 4;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength;
}
