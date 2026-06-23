import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';

typedef VetVisitSubmit = void Function({
  required String title,
  required DateTime visitedAt,
  String? vetName,
  String? clinicName,
});

class AddVetVisitBottomSheetWidget extends StatefulWidget {
  final VetVisitSubmit onSubmit;

  const AddVetVisitBottomSheetWidget({super.key, required this.onSubmit});

  @override
  State<AddVetVisitBottomSheetWidget> createState() =>
      _AddVetVisitBottomSheetWidgetState();
}

class _AddVetVisitBottomSheetWidgetState
    extends State<AddVetVisitBottomSheetWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _vetController = TextEditingController();
  final TextEditingController _clinicController = TextEditingController();
  DateTime? _visitedAt;

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty && _visitedAt != null;

  @override
  void dispose() {
    _titleController.dispose();
    _vetController.dispose();
    _clinicController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;
    final vet = _vetController.text.trim();
    final clinic = _clinicController.text.trim();
    widget.onSubmit(
      title: _titleController.text.trim(),
      visitedAt: _visitedAt!,
      vetName: vet.isEmpty ? null : vet,
      clinicName: clinic.isEmpty ? null : clinic,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Ajouter une visite',
      action: ButtonWidget(
        label: 'Enregistrer',
        fullWidth: true,
        onPressed: _isValid ? _submit : null,
        state: _isValid ? ButtonState.normal : ButtonState.disabled,
      ),
      children: [
        _buildField(_titleController, 'Motif de la visite', capitalize: true),
        const SizedBox(height: AppSpacing.md),
        DateFieldWidget(
          label: 'Date de la visite',
          value: _visitedAt,
          onChanged: (date) => setState(() => _visitedAt = date),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildField(_vetController, 'Vétérinaire (optionnel)',
            capitalize: true),
        const SizedBox(height: AppSpacing.md),
        _buildField(_clinicController, 'Clinique (optionnel)',
            capitalize: true),
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool capitalize = false,
  }) {
    return TextField(
      controller: controller,
      textCapitalization:
          capitalize ? TextCapitalization.sentences : TextCapitalization.none,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.backgroundStroke),
        ),
      ),
    );
  }
}
