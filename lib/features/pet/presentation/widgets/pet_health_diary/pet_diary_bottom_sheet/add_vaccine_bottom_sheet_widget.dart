import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/core/utils/diary_date_bounds.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

typedef VaccineSubmit = void Function({
  required String vaccineName,
  required DateTime lastDate,
  required DateTime nextDate,
});

class AddVaccineBottomSheetWidget extends StatefulWidget {
  final VaccineSubmit onSubmit;
  final HealthDiaryVaccineModel? initial;

  /// Floor of both date pickers.
  final DateTime birthdate;

  /// Offered in edit mode only, behind a confirmation.
  final VoidCallback? onDelete;

  const AddVaccineBottomSheetWidget({
    super.key,
    required this.onSubmit,
    required this.birthdate,
    this.initial,
    this.onDelete,
  });

  @override
  State<AddVaccineBottomSheetWidget> createState() => _AddVaccineBottomSheetWidgetState();
}

class _AddVaccineBottomSheetWidgetState extends State<AddVaccineBottomSheetWidget> {
  late final TextEditingController _nameController;
  DateTime? _lastDate;
  DateTime? _nextDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.vaccineName ?? '');
    _lastDate = initial?.lastDate;
    _nextDate = initial?.nextDate;
  }

  bool get _isValid => _nameController.text.trim().isNotEmpty && _lastDate != null && _nextDate != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;
    widget.onSubmit(
      vaccineName: _nameController.text.trim(),
      lastDate: _lastDate!,
      nextDate: _nextDate!,
    );
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await confirmDeletion(
      context,
      title: 'Supprimer ce vaccin ?',
      message: 'La ligne disparaîtra du carnet de santé et ne pourra pas être récupérée.',
    );
    if (!confirmed || !mounted) return;
    widget.onDelete!();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: widget.initial == null ? 'Ajouter un vaccin' : 'Modifier le vaccin',
      action: Column(
        children: [
          if (widget.onDelete != null) ...[
            ButtonWidget(
              label: 'Supprimer le vaccin',
              type: ButtonType.delete,
              fullWidth: true,
              onPressed: _confirmDelete,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          ButtonWidget(
            label: 'Enregistrer',
            fullWidth: true,
            onPressed: _isValid ? _submit : null,
            state: _isValid ? ButtonState.normal : ButtonState.disabled,
          ),
        ],
      ),
      children: [
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Nom du vaccin',
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.backgroundStroke),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DateFieldWidget(
          label: 'Dernier rappel',
          value: _lastDate,
          firstDate: widget.birthdate,
          onChanged: (date) => setState(() => _lastDate = date),
        ),
        const SizedBox(height: AppSpacing.sm),
        DateFieldWidget(
          label: 'Prochain rappel',
          value: _nextDate,
          firstDate: widget.birthdate,
          lastDate: DiaryDateBounds.openEnd(),
          onChanged: (date) => setState(() => _nextDate = date),
        ),
      ],
    );
  }
}
