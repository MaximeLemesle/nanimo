import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';

/// The name takes the whole width and the age is pinned right; when the pair
/// no longer fits on one line, the age drops below.
class PetNameAgeWidget extends StatelessWidget {
  final String name;
  final DateTime birthdate;
  final DateTime? now;

  const PetNameAgeWidget({
    super.key,
    required this.name,
    required this.birthdate,
    this.now,
  });

  static const double _gap = AppSpacing.sm;

  double _widthOf(BuildContext context, String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    final nameStyle = AppTextStyles.title01;
    final ageStyle = AppTextStyles.numberBig;
    final age = DateFormatter.age(birthdate, now: now);

    return LayoutBuilder(
      builder: (context, constraints) {
        final needed = _widthOf(context, name, nameStyle) + _gap + _widthOf(context, age, ageStyle);

        if (needed <= constraints.maxWidth) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(name, style: nameStyle)),
              const SizedBox(width: _gap),
              Text(age, style: ageStyle),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: nameStyle),
            const SizedBox(height: AppSpacing.xs),
            Text(age, style: ageStyle),
          ],
        );
      },
    );
  }
}
