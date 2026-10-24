import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/deworming_interval_selector_widget.dart';

typedef DewormingSubmit = void Function({required DateTime lastDeworming, required int intervalMonths});

/// The last deworming and its frequency, opened from the home.
class DewormingBottomSheetWidget extends StatefulWidget {
  final String petName;
  final DateTime? lastDeworming;
  final int intervalMonths;
  final DewormingSubmit onSubmit;

  const DewormingBottomSheetWidget({
    super.key,
    required this.petName,
    required this.onSubmit,
    this.lastDeworming,
    this.intervalMonths = HealthDiaryModel.defaultDewormingIntervalMonths,
  });

  @override
  State<DewormingBottomSheetWidget> createState() => _DewormingBottomSheetWidgetState();
}

class _DewormingBottomSheetWidgetState extends State<DewormingBottomSheetWidget> {
  late DateTime? _lastDeworming = widget.lastDeworming;
  late int _intervalMonths = widget.intervalMonths;

  @override
  Widget build(BuildContext context) {
    final lastDeworming = _lastDeworming;
    return BottomSheetWidget(
      title: 'Vermifuge de ${widget.petName}',
      action: ButtonWidget(
        label: 'Enregistrer',
        fullWidth: true,
        state: lastDeworming == null ? ButtonState.disabled : ButtonState.normal,
        onPressed: lastDeworming == null
            ? null
            : () {
                widget.onSubmit(lastDeworming: lastDeworming, intervalMonths: _intervalMonths);
                Navigator.of(context).pop();
              },
      ),
      children: [
        DateFieldWidget(
          label: 'Dernier vermifuge',
          value: lastDeworming,
          onChanged: (date) => setState(() => _lastDeworming = date),
        ),
        const SizedBox(height: AppSpacing.md),
        DewormingIntervalSelectorWidget(
          value: _intervalMonths,
          onChanged: (months) => setState(() => _intervalMonths = months),
        ),
      ],
    );
  }
}
