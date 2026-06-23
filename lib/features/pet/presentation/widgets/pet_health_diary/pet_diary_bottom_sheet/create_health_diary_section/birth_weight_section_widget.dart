import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';

class BirthWeightSectionWidget extends StatelessWidget {
  final String petName;
  final TextEditingController weightController;
  final DateTime weightDate;
  final VoidCallback onWeightChanged;

  const BirthWeightSectionWidget({
    super.key,
    required this.petName,
    required this.weightController,
    required this.weightDate,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Poids à la naissance', style: AppTextStyles.text),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                controller: weightController,
                label: null,
                hint: '0.0',
                suffixText: 'kg',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                onChanged: (_) => onWeightChanged(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'le ${DateFormatter.date(weightDate)}',
              style: AppTextStyles.text,
            ),
          ],
        ),
      ],
    );
  }
}
