import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/field_variant.dart';
import 'package:nanimo/core/widgets/pill_field_widget.dart';

class DateFieldWidget extends StatefulWidget {
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

  @override
  State<DateFieldWidget> createState() => _DateFieldWidgetState();

  static ({DateTime min, DateTime max, DateTime initial}) _bounds(
      DateTime? value, DateTime? firstDate, DateTime? lastDate) {
    final now = DateTime.now();
    final min = firstDate ?? DateTime(now.year - 30);
    final max = lastDate ?? now;
    var initial = value ?? now;
    if (initial.isBefore(min)) initial = min;
    if (initial.isAfter(max)) initial = max;
    return (min: min, max: max, initial: initial);
  }

  /// Opens the same wheel calendar from both a field and an action button.
  static Future<DateTime?> pick(
    BuildContext context, {
    DateTime? value,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final (:min, :max, :initial) = _bounds(value, firstDate, lastDate);
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

    return context.mounted ? picked : null;
  }

}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  /// The field variant unfolds its wheel in place: opened from a sheet, a
  /// second sheet stacked on the first and left it peeking out behind.
  bool _isOpen = false;
  static const _duration = Duration(milliseconds: 250);

  Future<void> _pick() async {
    final picked = await DateFieldWidget.pick(context,
        value: widget.value,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate);
    if (picked != null && mounted) widget.onChanged(picked);
  }

  void _toggle() {
    FocusScope.of(context).unfocus();
    final opening = !_isOpen;
    setState(() => _isOpen = opening);
    if (!opening) return;
    if (widget.value == null) {
      widget.onChanged(DateFieldWidget._bounds(
              null, widget.firstDate, widget.lastDate)
          .initial);
    }
    Future<void>.delayed(_duration, () {
      if (mounted) Scrollable.ensureVisible(context, duration: _duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final textStyle = widget.textStyle;
    final baseStyle = textStyle ?? AppTextStyles.text;
    final dateText = Text(
      value == null ? widget.placeholder : DateFormatter.date(value),
      textAlign: widget.textAlign,
      style: baseStyle.copyWith(
        color: value == null
            ? AppColors.textSecondary
            : (textStyle?.color ?? AppColors.textPrimary),
      ),
    );

    if (widget.variant == FieldVariant.pill) {
      return PillFieldWidget(
        semanticLabel: widget.label,
        onTap: _pick,
        showBorder: widget.showPillBorder,
        child: dateText,
      );
    }

    final bounds =
        DateFieldWidget._bounds(value, widget.firstDate, widget.lastDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InputDecorator(
            isFocused: _isOpen,
            decoration: InputDecoration(
              labelText: widget.label,
              filled: true,
              fillColor: AppColors.background,
              suffixIcon: AnimatedRotation(
                turns: _isOpen ? 0.5 : 0,
                duration: _duration,
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.backgroundStroke),
              ),
            ),
            child: dateText,
          ),
        ),
        AnimatedSize(
          duration: _duration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _isOpen
              ? SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: bounds.initial,
                    minimumDate: bounds.min,
                    maximumDate: bounds.max,
                    onDateTimeChanged: widget.onChanged,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
