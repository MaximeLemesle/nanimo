import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

typedef VetVisitSubmit = void Function({
  required String title,
  required DateTime visitedAt,
  String? vetName,
  String? clinicName,
});

class AddVetVisitBottomSheetWidget extends StatefulWidget {
  final VetVisitSubmit onSubmit;

  /// Non-null turns the sheet into a pre-filled edit form, like [AddVaccineBottomSheetWidget].
  final VetVisitModel? initial;

  /// Offered in edit mode only, behind a confirmation.
  final VoidCallback? onDelete;

  const AddVetVisitBottomSheetWidget({super.key, required this.onSubmit, this.initial, this.onDelete});

  @override
  State<AddVetVisitBottomSheetWidget> createState() => _AddVetVisitBottomSheetWidgetState();
}

class _AddVetVisitBottomSheetWidgetState extends State<AddVetVisitBottomSheetWidget> {
  late final TextEditingController _titleController;
  late final TextEditingController _vetController;
  late final TextEditingController _clinicController;
  DateTime? _visitedAt;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _vetController = TextEditingController(text: initial?.vetName ?? '');
    _clinicController = TextEditingController(text: initial?.clinicName ?? '');
    _visitedAt = initial?.visitedAt;
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty && _visitedAt != null;

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

  Future<void> _confirmDelete() async {
    final confirmed = await confirmDeletion(
      context,
      title: 'Supprimer cette visite ?',
      message: 'La visite disparaîtra du carnet de santé et ne pourra pas être récupérée.',
    );
    if (!confirmed || !mounted) return;
    widget.onDelete!();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: widget.initial == null ? 'Ajouter une visite' : 'Modifier la visite',
      action: Column(
        children: [
          if (widget.onDelete != null) ...[
            ButtonWidget(
              label: 'Supprimer la visite',
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
        _buildField(_titleController, 'Motif de la visite', capitalize: true),
        const SizedBox(height: AppSpacing.md),
        DateFieldWidget(
          label: 'Date de la visite',
          value: _visitedAt,
          onChanged: (date) => setState(() => _visitedAt = date),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildField(_vetController, 'Vétérinaire (optionnel)', capitalize: true),
        const SizedBox(height: AppSpacing.md),
        _buildField(_clinicController, 'Clinique (optionnel)', capitalize: true),
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
      textCapitalization: capitalize ? TextCapitalization.sentences : TextCapitalization.none,
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
