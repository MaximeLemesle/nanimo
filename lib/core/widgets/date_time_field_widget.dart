import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/field_variant.dart';
import 'package:nanimo/core/widgets/time_field_widget.dart';

class DateTimeFieldWidget extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateLabel;
  final String timeLabel;
  final TextStyle? textStyle;

  const DateTimeFieldWidget({
    super.key,
    required this.value,
    required this.onDateChanged,
    required this.onTimeChanged,
    this.firstDate,
    this.lastDate,
    this.dateLabel = 'Date',
    this.timeLabel = 'Heure',
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final shape = ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md * 2),
    );
    final style = textStyle ?? AppTextStyles.textBold;

    final box = Container(
      decoration: ShapeDecoration(
        color: AppColors.backgroundSurface,
        shape: shape,
      ),
      child: Row(
        children: [
          Expanded(
            child: DateFieldWidget(
              label: dateLabel,
              value: value,
              onChanged: onDateChanged,
              firstDate: firstDate,
              lastDate: lastDate,
              variant: FieldVariant.pill,
              showPillBorder: false,
              textAlign: TextAlign.center,
              textStyle: style,
            ),
          ),
          Expanded(
            child: TimeFieldWidget(
              label: timeLabel,
              value: value,
              onChanged: onTimeChanged,
              variant: FieldVariant.pill,
              showPillBorder: false,
              textAlign: TextAlign.center,
              textStyle: style,
            ),
          ),
        ],
      ),
    );
    
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: ShapeDecoration(
        color: AppColors.backgroundStroke,
        shape: shape,
      ),
      child: box,
    );
  }
}
