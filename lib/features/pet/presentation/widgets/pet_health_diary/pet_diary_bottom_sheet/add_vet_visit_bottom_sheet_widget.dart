import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/core/utils/diary_date_bounds.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

typedef VetVisitSubmit = void Function({
  required String title,
  required DateTime visitedAt,
  String? vetName,
  String? clinicName,
  String? petId,
});

class AddVetVisitBottomSheetWidget extends StatefulWidget {
  final VetVisitSubmit onSubmit;

  /// Non-null turns the sheet into a pre-filled edit form, like [AddVaccineBottomSheetWidget].
  final VetVisitModel? initial;

  /// Floor of the date picker. Ignored when [pets] carries the selected animal.
  final DateTime? birthdate;

  /// Opt-in animal selector, same contract as [AddWeightBottomSheetWidget].
  final List<PetModel> pets;
  final Map<String, PetPortrait> portraits;
  final String? initialPetId;

  /// Offered in edit mode only, behind a confirmation.
  final VoidCallback? onDelete;

  /// Books ahead: the floor becomes today instead of the birthdate.
  final bool upcomingOnly;

  const AddVetVisitBottomSheetWidget({
    super.key,
    required this.onSubmit,
    this.birthdate,
    this.initial,
    this.pets = const [],
    this.portraits = const {},
    this.initialPetId,
    this.onDelete,
    this.upcomingOnly = false,
  });

  @override
  State<AddVetVisitBottomSheetWidget> createState() => _AddVetVisitBottomSheetWidgetState();
}

class _AddVetVisitBottomSheetWidgetState extends State<AddVetVisitBottomSheetWidget> {
  late final TextEditingController _titleController;
  late final TextEditingController _vetController;
  late final TextEditingController _clinicController;
  DateTime? _visitedAt;
  late String? _petId = widget.initial?.petId ??
      widget.initialPetId ??
      (widget.pets.isNotEmpty ? widget.pets.first.petId : null);

  /// An existing visit already belongs to an animal, nothing left to pick.
  bool get _showPetPicker => widget.initial == null && widget.pets.length > 1;

  /// The picker may change the animal under the date field.
  DateTime? get _birthdate {
    for (final pet in widget.pets) {
      if (pet.petId == _petId) return pet.birthdate;
    }
    return widget.birthdate;
  }

  /// Booking ahead, a past date is not a visit to come.
  DateTime? get _firstDate =>
      widget.upcomingOnly ? DiaryDateBounds.today() : _birthdate;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _vetController = TextEditingController(text: initial?.vetName ?? '');
    _clinicController = TextEditingController(text: initial?.clinicName ?? '');
    _visitedAt = initial?.visitedAt;
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty &&
      _visitedAt != null &&
      (!_showPetPicker || _petId != null);

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
      petId: _petId,
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
        if (_showPetPicker) ...[
          PetPickerWidget.single(
            pets: widget.pets,
            portraits: widget.portraits,
            selectedPetId: _petId,
            onSelected: (id) => setState(() => _petId = id),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        _buildField(_titleController, 'Motif de la visite', capitalize: true),
        const SizedBox(height: AppSpacing.md),
        DateFieldWidget(
          label: 'Date de la visite',
          value: _visitedAt,
          firstDate: _firstDate,
          lastDate: DiaryDateBounds.openEnd(),
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
