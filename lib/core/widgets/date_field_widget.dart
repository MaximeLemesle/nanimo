import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/field_variant.dart';
import 'package:nanimo/core/widgets/pill_field_widget.dart';

class DateFieldWidget extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String placeholder;
  final FieldVariant variant;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final bool showPillBorder;

  const DateFieldWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.placeholder = 'Sélectionner une date',
    this.variant = FieldVariant.field,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.showPillBorder = true,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final min = firstDate ?? DateTime(now.year - 30);
    final max = lastDate ?? now;

    var initial = value ?? now;
    if (initial.isBefore(min)) initial = min;
    if (initial.isAfter(max)) initial = max;
    var picked = initial;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.lg),
          child: SizedBox(
            height: 350,
            width: double.infinity,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              dateOrder: DatePickerDateOrder.dmy,
              initialDateTime: initial,
              minimumDate: min,
              maximumDate: max,
              onDateTimeChanged: (date) => picked = date,
            ),
          ),
        );
      },
    );

    if (!context.mounted) return;
    onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = textStyle ?? AppTextStyles.text;
    final dateText = Text(
      value == null ? placeholder : DateFormatter.date(value!),
      textAlign: textAlign,
      style: baseStyle.copyWith(
        color: value == null ? AppColors.textSecondary : (textStyle?.color ?? AppColors.textPrimary),
      ),
    );

    if (variant == FieldVariant.pill) {
      return PillFieldWidget(
        semanticLabel: label,
        onTap: () => _pick(context),
        showBorder: showPillBorder,
        child: dateText,
      );
    }

    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.backgroundStroke),
          ),
        ),
        child: dateText,
      ),
    );
  }
}
