import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/core/utils/diary_date_bounds.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

typedef VaccineSubmit = void Function({
  required String vaccineName,
  required DateTime lastDate,
  required DateTime nextDate,
  String? petId,
});

class AddVaccineBottomSheetWidget extends StatefulWidget {
  final VaccineSubmit onSubmit;
  final HealthDiaryVaccineModel? initial;

  /// Floor of both date pickers. Ignored when [pets] carries the animal.
  final DateTime birthdate;

  /// Opt-in animal selector, same contract as [AddVetVisitBottomSheetWidget].
  final List<PetModel> pets;
  final Map<String, PetPortrait> portraits;
  final String? initialPetId;

  /// Offered in edit mode only, behind a confirmation.
  final VoidCallback? onDelete;

  /// Books ahead: the next booster floors at today, not at the birthdate.
  final bool upcomingOnly;

  const AddVaccineBottomSheetWidget({
    super.key,
    required this.onSubmit,
    required this.birthdate,
    this.initial,
    this.pets = const [],
    this.portraits = const {},
    this.initialPetId,
    this.onDelete,
    this.upcomingOnly = false,
  });

  @override
  State<AddVaccineBottomSheetWidget> createState() => _AddVaccineBottomSheetWidgetState();
}

class _AddVaccineBottomSheetWidgetState extends State<AddVaccineBottomSheetWidget> {
  late final TextEditingController _nameController;
  DateTime? _lastDate;
  DateTime? _nextDate;
  late String? _petId = widget.initialPetId ??
      (widget.pets.isNotEmpty ? widget.pets.first.petId : null);

  /// An existing vaccine already belongs to a diary, nothing left to pick.
  bool get _showPetPicker => widget.initial == null && widget.pets.length > 1;

  /// The picker may change the animal under the date fields.
  DateTime get _birthdate {
    for (final pet in widget.pets) {
      if (pet.petId == _petId) return pet.birthdate;
    }
    return widget.birthdate;
  }

  /// Booking ahead, a booster already gone is not a booster to come.
  DateTime get _nextFirstDate =>
      widget.upcomingOnly ? DiaryDateBounds.today() : _birthdate;

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
      _nextDate != null &&
      (!_showPetPicker || _petId != null);

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
      petId: _petId,
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
          firstDate: _birthdate,
          onChanged: (date) => setState(() => _lastDate = date),
        ),
        const SizedBox(height: AppSpacing.sm),
        DateFieldWidget(
          label: 'Prochain rappel',
          value: _nextDate,
          firstDate: _nextFirstDate,
          lastDate: DiaryDateBounds.openEnd(),
          onChanged: (date) => setState(() => _nextDate = date),
        ),
      ],
    );
  }
}
