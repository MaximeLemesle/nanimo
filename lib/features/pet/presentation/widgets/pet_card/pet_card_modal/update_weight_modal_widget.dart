import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

class UpdateWeightModalWidget extends StatefulWidget {
  final ValueChanged<double> onSubmit;

  const UpdateWeightModalWidget({super.key, required this.onSubmit});

  @override
  State<UpdateWeightModalWidget> createState() =>
      _UpdateWeightModalWidgetState();
}

class _UpdateWeightModalWidgetState extends State<UpdateWeightModalWidget> {
  final TextEditingController _controller = TextEditingController();
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

  void _submit() {
    final value = _parse(_controller.text);
    if (value == null) return;
    widget.onSubmit(value);
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
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
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
