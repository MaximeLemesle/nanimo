import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';

/// The name owns the width; the age drops to the line below when the pair no
/// longer fits.
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Text(name, style: AppTextStyles.title01),
          ),
          Text(
            DateFormatter.age(birthdate, now: now),
            style: AppTextStyles.numberBig,
          ),
        ],
      ),
    );
  }
}
