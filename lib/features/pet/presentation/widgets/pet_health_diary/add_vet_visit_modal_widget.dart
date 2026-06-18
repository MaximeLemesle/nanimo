import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

/// Callback carrying a new vet visit.
typedef VetVisitSubmit = void Function({
  required String title,
  required DateTime visitedAt,
  String? vetName,
  String? clinicName,
});

/// Bottom sheet to add a vet visit (title, date, vet, clinic).
class AddVetVisitModalWidget extends StatefulWidget {
  final VetVisitSubmit onSubmit;

  const AddVetVisitModalWidget({super.key, required this.onSubmit});

  @override
  State<AddVetVisitModalWidget> createState() => _AddVetVisitModalWidgetState();
}

class _AddVetVisitModalWidgetState extends State<AddVetVisitModalWidget> {
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (!mounted || picked == null) return;
    setState(() => _visitedAt = picked);
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
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ajouter une visite', style: AppTextStyles.title03),
          const SizedBox(height: AppSpacing.lg),
          _buildField(_titleController, 'Motif de la visite',
              capitalize: true),
          const SizedBox(height: AppSpacing.md),
          _buildDateField(),
          const SizedBox(height: AppSpacing.md),
          _buildField(_vetController, 'Vétérinaire (optionnel)',
              capitalize: true),
          const SizedBox(height: AppSpacing.md),
          _buildField(_clinicController, 'Clinique (optionnel)',
              capitalize: true),
          const SizedBox(height: AppSpacing.lg),
          ButtonWidget(
            label: 'Enregistrer',
            fullWidth: true,
            onPressed: _isValid ? _submit : null,
            state: _isValid ? ButtonState.normal : ButtonState.disabled,
          ),
        ],
      ),
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

  Widget _buildDateField() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date de la visite',
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.backgroundStroke),
          ),
        ),
        child: Text(
          _visitedAt == null
              ? 'Sélectionner une date'
              : DateFormatter.date(_visitedAt!),
          style: AppTextStyles.text.copyWith(
            color: _visitedAt == null
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
