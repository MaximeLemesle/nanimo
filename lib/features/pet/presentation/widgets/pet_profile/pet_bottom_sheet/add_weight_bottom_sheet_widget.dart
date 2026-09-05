import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';

typedef WeightSubmit = void Function(
  double weight,
  DateTime loggedAt, {
  String? petId,
});

class AddWeightBottomSheetWidget extends StatefulWidget {
  final WeightSubmit onSubmit;
  final List<PetModel> pets;
  final Map<String, PetPortrait> portraits;
  final String? initialPetId;

  const AddWeightBottomSheetWidget({
    super.key,
    required this.onSubmit,
    this.pets = const [],
    this.portraits = const {},
    this.initialPetId,
  });

  @override
  State<AddWeightBottomSheetWidget> createState() => _AddWeightBottomSheetWidgetState();
}

class _AddWeightBottomSheetWidgetState extends State<AddWeightBottomSheetWidget> {
  final TextEditingController _controller = TextEditingController();
  DateTime _loggedAt = DateTime.now();
  bool _isValid = false;
  late String? _petId = widget.initialPetId ?? (widget.pets.isNotEmpty ? widget.pets.first.petId : null);

  bool get _showPetPicker => widget.pets.length > 1;

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
    widget.onSubmit(value, _loggedAt, petId: _petId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Mettre à jour le poids',
      action: ButtonWidget(
        label: 'Enregistrer',
        onPressed: _isValid ? _submit : null,
        state: _isValid ? ButtonState.normal : ButtonState.disabled,
        fullWidth: true,
      ),
      children: [
        if (_showPetPicker) ...[
          PetPickerWidget.single(
            pets: widget.pets,
            portraits: widget.portraits,
            selectedPetId: _petId,
            onSelected: (id) => setState(() => _petId = id),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
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
        DateFieldWidget(
          label: 'Date de la pesée',
          value: _loggedAt,
          onChanged: (date) => setState(() => _loggedAt = date),
        ),
      ],
    );
  }
}
