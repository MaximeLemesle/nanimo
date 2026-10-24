import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

/// Every showcase is drawn on this fixed canvas, then scaled to the room it
/// is given: the composition never reflows from one phone to the next.
class ShowcaseCanvas extends StatelessWidget {
  static const size = Size(320, 380);

  final List<Widget> children;

  const ShowcaseCanvas({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: FittedBox(
        child: SizedBox.fromSize(
          size: size,
          child: Stack(clipBehavior: Clip.none, children: children),
        ),
      ),
    );
  }
}

/// A phone outline holding a slice of the app.
class ShowcasePhone extends StatelessWidget {
  final Widget child;

  const ShowcasePhone({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppColors.backgroundInvert, width: 6),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 12))],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.backgroundInvert,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// A card lifted off the phone, as on the store screenshots.
class ShowcaseCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;

  const ShowcaseCard({
    super.key,
    required this.child,
    required this.width,
    this.color = AppColors.backgroundSurface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.backgroundStroke),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: child,
    );
  }
}

/// Small caption over a value, the pattern of the pet page cards.
class ShowcaseField extends StatelessWidget {
  final String value;
  final String label;

  const ShowcaseField({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, maxLines: 1, softWrap: false, overflow: TextOverflow.fade, style: AppTextStyles.textBold.copyWith(fontSize: 12)),
        Text(label, style: AppTextStyles.textLabel.copyWith(fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}

/// Coloured pill such as « Dans 29 j » or « Terminé ».
class ShowcasePill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const ShowcasePill({super.key, required this.label, required this.background, required this.foreground});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(label, style: AppTextStyles.textLabel.copyWith(fontSize: 9, color: foreground)),
    );
  }
}

/// A weight curve, enough to read as one without real data behind it.
class ShowcaseSparkline extends StatelessWidget {
  final List<double> points;
  final double height;

  const ShowcaseSparkline({super.key, required this.points, this.height = 36});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, child: CustomPaint(painter: _SparklinePainter(points), size: Size.infinite));
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;

  _SparklinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final lowest = points.reduce((a, b) => a < b ? a : b);
    final highest = points.reduce((a, b) => a > b ? a : b);
    final span = highest - lowest == 0 ? 1 : highest - lowest;
    final offsets = [
      for (var i = 0; i < points.length; i++)
        Offset(
          size.width * i / (points.length - 1),
          size.height * (1 - (points[i] - lowest) / span) * 0.8 + size.height * 0.1,
        ),
    ];

    final fill = Path()..moveTo(offsets.first.dx, size.height);
    for (final offset in offsets) {
      fill.lineTo(offset.dx, offset.dy);
    }
    fill
      ..lineTo(offsets.last.dx, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = AppColors.primary100);

    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(Path()..addPolygon(offsets, false), line);
    for (final offset in offsets) {
      canvas.drawCircle(offset, 2.5, Paint()..color = AppColors.primary);
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) => oldDelegate.points != points;
}
