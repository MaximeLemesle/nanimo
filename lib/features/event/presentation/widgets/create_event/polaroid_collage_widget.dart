import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

class PolaroidCollageWidget extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onTap;
  final void Function(int index)? onReplaceImage;

  const PolaroidCollageWidget({
    super.key,
    required this.images,
    required this.onTap,
    this.onReplaceImage,
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
        child: _replaceable(
          0,
          _frame(
            size: _singleFrameSize,
            child: Image.file(
              File(images.first.path),
              width: _singleFrameSize + 10,
              height: _singleFrameSize + 10,
              fit: BoxFit.cover,
            ),
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
                child: _replaceable(
                  i,
                  _frame(
                    child: Image.file(
                      File(visible[i].path),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _replaceable(int index, Widget frame) {
    if (onReplaceImage == null) return frame;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onReplaceImage!(index),
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
                  color: Color(0x1A000000),
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
