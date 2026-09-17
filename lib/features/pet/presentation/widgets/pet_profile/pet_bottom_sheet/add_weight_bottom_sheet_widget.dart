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
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

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

  /// Non-null turns the sheet into a pre-filled edit form.
  final HealthDiaryWeightLogModel? initial;

  /// Offered in edit mode only, behind a confirmation.
  final VoidCallback? onDelete;

  const AddWeightBottomSheetWidget({
    super.key,
    required this.onSubmit,
    this.pets = const [],
    this.portraits = const {},
    this.initialPetId,
    this.initial,
    this.onDelete,
  });

  @override
  State<AddWeightBottomSheetWidget> createState() => _AddWeightBottomSheetWidgetState();
}

class _AddWeightBottomSheetWidgetState extends State<AddWeightBottomSheetWidget> {
  late final TextEditingController _controller;
  late DateTime _loggedAt;
  late bool _isValid;
  late String? _petId = widget.initial?.petId ?? widget.initialPetId ?? (widget.pets.isNotEmpty ? widget.pets.first.petId : null);

  /// An existing log already belongs to a pet, there is nothing left to pick.
  bool get _showPetPicker => widget.initial == null && widget.pets.length > 1;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _controller = TextEditingController(
      text: initial == null ? '' : WeightFormatter.input(initial.weight),
    );
    _loggedAt = initial?.loggedAt ?? DateTime.now();
    _isValid = initial != null;
  }

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

  Future<void> _confirmDelete() async {
    final confirmed = await confirmDeletion(
      context,
      title: 'Supprimer cette pesée ?',
      message: 'La pesée disparaîtra du carnet de santé et de la courbe de poids, et ne pourra pas être récupérée.',
    );
    if (!confirmed || !mounted) return;
    widget.onDelete!();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: widget.initial == null ? 'Ajouter une pesée' : 'Modifier la pesée',
      action: Column(
        children: [
          if (widget.onDelete != null) ...[
            ButtonWidget(
              label: 'Supprimer la pesée',
              type: ButtonType.delete,
              fullWidth: true,
              onPressed: _confirmDelete,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          ButtonWidget(
            label: 'Enregistrer',
            onPressed: _isValid ? _submit : null,
            state: _isValid ? ButtonState.normal : ButtonState.disabled,
            fullWidth: true,
          ),
        ],
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
          autofocus: widget.initial == null,
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
