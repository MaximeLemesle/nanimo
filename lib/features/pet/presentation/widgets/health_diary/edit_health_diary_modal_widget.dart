import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';

/// Callback carrying the edited diary fields.
typedef HealthDiarySubmit = void Function({
  required bool isSterilized,
  required bool isChipped,
  String? chipNumber,
  DateTime? lastDeworming,
  DateTime? lastVetAppointment,
});

/// Bottom sheet to edit the editable health diary fields.
class EditHealthDiaryModalWidget extends StatefulWidget {
  final HealthDiaryModel? diary;
  final HealthDiarySubmit onSubmit;

  const EditHealthDiaryModalWidget({
    super.key,
    required this.diary,
    required this.onSubmit,
  });

  @override
  State<EditHealthDiaryModalWidget> createState() =>
      _EditHealthDiaryModalWidgetState();
}

class _EditHealthDiaryModalWidgetState
    extends State<EditHealthDiaryModalWidget> {
  late bool _isSterilized;
  late bool _isChipped;
  late final TextEditingController _chipController;
  DateTime? _lastDeworming;
  DateTime? _lastVetAppointment;

  @override
  void initState() {
    super.initState();
    final diary = widget.diary;
    _isSterilized = diary?.isSterilized ?? false;
    _isChipped = diary?.isChipped ?? false;
    _chipController = TextEditingController(text: diary?.chipNumber ?? '');
    _lastDeworming = diary?.lastDeworming;
    _lastVetAppointment = diary?.lastVetAppointment;
  }

  @override
  void dispose() {
    _chipController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(ValueChanged<DateTime> onPicked) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (!mounted || picked == null) return;
    setState(() => onPicked(picked));
  }

  void _submit() {
    final chip = _chipController.text.trim();
    widget.onSubmit(
      isSterilized: _isSterilized,
      isChipped: _isChipped,
      chipNumber: _isChipped && chip.isNotEmpty ? chip : null,
      lastDeworming: _lastDeworming,
      lastVetAppointment: _lastVetAppointment,
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
          Text('Carnet de santé', style: AppTextStyles.title03),
          const SizedBox(height: AppSpacing.lg),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primary,
            title: Text('Stérilisé', style: AppTextStyles.textBold),
            value: _isSterilized,
            onChanged: (v) => setState(() => _isSterilized = v),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primary,
            title: Text('Pucé', style: AppTextStyles.textBold),
            value: _isChipped,
            onChanged: (v) => setState(() => _isChipped = v),
          ),
          if (_isChipped) ...[
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _chipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Numéro de puce',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide:
                      const BorderSide(color: AppColors.backgroundStroke),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _buildDateField(
            label: 'Dernier vermifuge',
            value: _lastDeworming,
            onTap: () => _pickDate((d) => _lastDeworming = d),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDateField(
            label: 'Dernier rendez-vous vétérinaire',
            value: _lastVetAppointment,
            onTap: () => _pickDate((d) => _lastVetAppointment = d),
          ),
          const SizedBox(height: AppSpacing.lg),
          ButtonWidget(
            label: 'Enregistrer',
            fullWidth: true,
            onPressed: _submit,
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
            color: value == null
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
