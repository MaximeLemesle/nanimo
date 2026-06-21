import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';

typedef VaccineSubmit = void Function({
  required String vaccineName,
  required DateTime lastDate,
  required DateTime nextDate,
});

class AddVaccineModalWidget extends StatefulWidget {
  final VaccineSubmit onSubmit;
  final HealthDiaryVaccineModel? initial;

  const AddVaccineModalWidget({
    super.key,
    required this.onSubmit,
    this.initial,
  });

  @override
  State<AddVaccineModalWidget> createState() => _AddVaccineModalWidgetState();
}

class _AddVaccineModalWidgetState extends State<AddVaccineModalWidget> {
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

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _lastDate != null &&
      _nextDate != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(DateTime? current, ValueChanged<DateTime> onPicked) async {
    final now = DateTime.now();
    var picked = current ?? now;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          width: double.infinity,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            initialDateTime: picked,
            minimumDate: DateTime(now.year - 30),
            maximumDate: DateTime(now.year + 30),
            onDateTimeChanged: (date) => picked = date,
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() => onPicked(picked));
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
          Text(
            widget.initial == null ? 'Ajouter un vaccin' : 'Modifier le vaccin',
            style: AppTextStyles.title03,
          ),
          const SizedBox(height: AppSpacing.lg),
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
          _buildDateField(
            label: 'Dernier rappel',
            value: _lastDate,
            onTap: () => _pickDate(_lastDate, (d) => _lastDate = d),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDateField(
            label: 'Prochain rappel',
            value: _nextDate,
            onTap: () => _pickDate(_nextDate, (d) => _nextDate = d),
          ),
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

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
        child: Text(
          value == null ? 'Sélectionner une date' : DateFormatter.date(value),
          style: AppTextStyles.text.copyWith(
            color:
                value == null ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
