import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

typedef WeightSubmit = void Function(double weight, DateTime loggedAt);

class UpdateWeightModalWidget extends StatefulWidget {
  final WeightSubmit onSubmit;

  const UpdateWeightModalWidget({super.key, required this.onSubmit});

  @override
  State<UpdateWeightModalWidget> createState() =>
      _UpdateWeightModalWidgetState();
}

class _UpdateWeightModalWidgetState extends State<UpdateWeightModalWidget> {
  final TextEditingController _controller = TextEditingController();
  DateTime _loggedAt = DateTime.now();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? _parse(String raw) {
    final value = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    return value;
  }

  void _onChanged(String raw) {
    setState(() => _isValid = _parse(raw) != null);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    var picked = _loggedAt;

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
            maximumDate: now,
            onDateTimeChanged: (date) => picked = date,
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() => _loggedAt = picked);
  }

  void _submit() {
    final value = _parse(_controller.text);
    if (value == null) return;
    widget.onSubmit(value, _loggedAt);
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
          Text('Mettre à jour le poids', style: AppTextStyles.title03),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: _onChanged,
            onSubmitted: (_) {
              if (_isValid) _submit();
            },
            decoration: InputDecoration(
              suffixText: 'kg',
              hintText: '0,0',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.backgroundStroke),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date de la pesée',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide:
                      const BorderSide(color: AppColors.backgroundStroke),
                ),
              ),
              child: Text(
                DateFormatter.date(_loggedAt),
                style:
                    AppTextStyles.text.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ButtonWidget(
            label: 'Enregistrer',
            onPressed: _isValid ? _submit : null,
            state: _isValid ? ButtonState.normal : ButtonState.disabled,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}
