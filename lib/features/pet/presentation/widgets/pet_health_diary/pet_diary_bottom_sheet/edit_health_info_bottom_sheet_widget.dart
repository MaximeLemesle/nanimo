import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_section/health_diary_section_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/core/utils/gender_formatter.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/chip_number_field_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/deworming_interval_selector_widget.dart';

typedef EditHealthInfoSubmit = void Function({
  required bool isSterilized,
  required bool isChipped,
  String? chipNumber,
  DateTime? sterilizedAt,
  DateTime? lastDeworming,
  int? dewormingIntervalMonths,
});

/// Edits the facts shown on the health card: sterilisation and its date, chip, deworming.
class EditHealthInfoBottomSheetWidget extends StatefulWidget {
  final Gender gender;
  final DateTime birthdate;
  final HealthDiaryModel diary;
  final EditHealthInfoSubmit onSubmit;

  const EditHealthInfoBottomSheetWidget({
    super.key,
    required this.gender,
    required this.birthdate,
    required this.diary,
    required this.onSubmit,
  });

  @override
  State<EditHealthInfoBottomSheetWidget> createState() =>
      _EditHealthInfoBottomSheetWidgetState();
}

class _EditHealthInfoBottomSheetWidgetState
    extends State<EditHealthInfoBottomSheetWidget> {
  late final TextEditingController _chipController;

  late bool _isSterilized;
  DateTime? _sterilizedAt;
  late bool _isChipped;
  late bool _isDewormed;
  DateTime? _lastDeworming;
  late int _dewormingInterval;

  @override
  void initState() {
    super.initState();
    final diary = widget.diary;
    _chipController = TextEditingController(text: diary.chipNumber ?? '');
    _isSterilized = diary.isSterilized ?? false;
    _sterilizedAt = diary.sterilizedAt;
    _isChipped = diary.isChipped ?? false;

    /// No dewormed flag in the model: the date is the only evidence.
    _lastDeworming = diary.lastDeworming;
    _isDewormed = diary.lastDeworming != null;
    _dewormingInterval = diary.dewormingInterval;
  }

  @override
  void dispose() {
    _chipController.dispose();
    super.dispose();
  }

  void _submit() {
    final chipNumber = _chipController.text.trim();

    widget.onSubmit(
      isSterilized: _isSterilized,
      isChipped: _isChipped,
      chipNumber: _isChipped && chipNumber.isNotEmpty ? chipNumber : null,
      sterilizedAt: _isSterilized ? _sterilizedAt : null,
      lastDeworming: _isDewormed ? (_lastDeworming ?? DateTime.now()) : null,
      dewormingIntervalMonths: _dewormingInterval,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Modifier les informations de santé',
      scrollable: true,
      action: ButtonWidget(
        label: 'Enregistrer',
        fullWidth: true,
        onPressed: _submit,
      ),
      children: [
        HealthDiarySectionWidget(
          label: GenderFormatter.neuteringLabel(widget.gender),
          value: _isSterilized,
          onChanged: (value) => setState(() => _isSterilized = value),
          child: DateFieldWidget(
            label: widget.gender == Gender.male ? 'Date de la castration' : 'Date de la stérilisation',
            value: _sterilizedAt,
            firstDate: widget.birthdate,
            lastDate: DateTime.now(),
            onChanged: (date) => setState(() => _sterilizedAt = date),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        HealthDiarySectionWidget(
          label: 'Vermifugé',
          value: _isDewormed,
          onChanged: (value) => setState(() => _isDewormed = value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateFieldWidget(
                label: 'Dernier vermifuge',
                value: _lastDeworming,
                onChanged: (date) => setState(() => _lastDeworming = date),
              ),
              const SizedBox(height: AppSpacing.md),
              DewormingIntervalSelectorWidget(
                value: _dewormingInterval,
                onChanged: (months) => setState(() => _dewormingInterval = months),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        HealthDiarySectionWidget(
          label: 'Pucé',
          value: _isChipped,
          onChanged: (value) => setState(() => _isChipped = value),
          child: ChipNumberFieldWidget(
            controller: _chipController,
            onChanged: () => setState(() {}),
          ),
        ),
      ],
    );
  }
}
