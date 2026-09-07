import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_section/health_diary_section_widget.dart';

typedef EditHealthInfoSubmit = void Function({
  required bool isSterilized,
  required bool isChipped,
  String? chipNumber,
  DateTime? lastDeworming,
});

/// Edits the three facts shown on the health card: sterilisation, chip, and
/// last deworming.
///
/// Deliberately not the creation sheet with a flag. That one also collects the
/// birth weight, the vaccine checklist and the vet visits, none of which belong
/// to this card. Reusing [HealthDiarySectionWidget] keeps the two sheets
/// looking alike where it matters without dragging in what does not.
class EditHealthInfoBottomSheetWidget extends StatefulWidget {
  final HealthDiaryModel diary;
  final EditHealthInfoSubmit onSubmit;

  const EditHealthInfoBottomSheetWidget({
    super.key,
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
  late bool _isChipped;
  late bool _isDewormed;
  DateTime? _lastDeworming;

  @override
  void initState() {
    super.initState();
    final diary = widget.diary;
    _chipController = TextEditingController(text: diary.chipNumber ?? '');
    _isSterilized = diary.isSterilized ?? false;
    _isChipped = diary.isChipped ?? false;

    /// A recorded date is the only evidence the pet was ever dewormed, so it
    /// drives the toggle rather than a column of its own.
    _lastDeworming = diary.lastDeworming;
    _isDewormed = diary.lastDeworming != null;
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

      /// Turning the toggle off clears the number instead of leaving an orphan
      /// value behind a "Non".
      chipNumber: _isChipped && chipNumber.isNotEmpty ? chipNumber : null,
      lastDeworming: _isDewormed ? (_lastDeworming ?? DateTime.now()) : null,
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
          label: 'Stérilisé',
          value: _isSterilized,
          onChanged: (value) => setState(() => _isSterilized = value),
        ),
        const SizedBox(height: AppSpacing.sm),
        HealthDiarySectionWidget(
          label: 'Vermifugé',
          value: _isDewormed,
          onChanged: (value) => setState(() => _isDewormed = value),
          child: DateFieldWidget(
            label: 'Dernier vermifuge',
            value: _lastDeworming,
            onChanged: (date) => setState(() => _lastDeworming = date),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        HealthDiarySectionWidget(
          label: 'Pucé',
          value: _isChipped,
          onChanged: (value) => setState(() => _isChipped = value),
          child: TextFieldWidget(
            controller: _chipController,
            label: 'Numéro de puce',
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }
}
