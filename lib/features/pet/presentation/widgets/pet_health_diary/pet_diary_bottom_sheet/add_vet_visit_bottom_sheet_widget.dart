import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/time_field_widget.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/core/utils/diary_date_bounds.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

/// What the form hands back. [visitedAt] carries the time only if [hasTime].
class VetVisitDraft {
  final String title;
  final DateTime visitedAt;
  final bool hasTime;
  final String? vetName;
  final String? clinicName;
  final String? reason;
  final String? report;
  final String? petId;

  const VetVisitDraft({
    required this.title,
    required this.visitedAt,
    this.hasTime = false,
    this.vetName,
    this.clinicName,
    this.reason,
    this.report,
    this.petId,
  });

  /// Keeps what the form does not show, such as the document count.
  VetVisitModel applyTo(VetVisitModel visit) => visit.copyWith(
        title: title,
        visitedAt: visitedAt,
        hasTime: hasTime,
        petId: petId ?? visit.petId,
        vetName: () => vetName,
        clinicName: () => clinicName,
        reason: () => reason,
        report: () => report,
      );
}

typedef VetVisitSubmit = void Function(VetVisitDraft draft);

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
  late final TextEditingController _reasonController;
  late final TextEditingController _reportController;
  DateTime? _visitedAt;
  TimeOfDay? _time;
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
    _reasonController = TextEditingController(text: initial?.reason ?? '');
    _reportController = TextEditingController(text: initial?.report ?? '');
    _visitedAt = initial?.visitedAt;
    if (initial != null && initial.hasTime) {
      _time = TimeOfDay(hour: initial.visitedAt.hour, minute: initial.visitedAt.minute);
    }
  }

  /// A report only makes sense once the day of the visit has come.
  bool get _showReport {
    if (_reportController.text.isNotEmpty) return true;
    final date = _visitedAt;
    if (date == null) return false;
    return !DateTime(date.year, date.month, date.day).isAfter(DiaryDateBounds.today());
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty &&
      _visitedAt != null &&
      (!_showPetPicker || _petId != null);

  @override
  void dispose() {
    _titleController.dispose();
    _vetController.dispose();
    _clinicController.dispose();
    _reasonController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;
    final day = _visitedAt!;
    final time = _time;
    widget.onSubmit(VetVisitDraft(
      title: _titleController.text.trim(),
      visitedAt: time == null
          ? DateTime(day.year, day.month, day.day)
          : DateTime(day.year, day.month, day.day, time.hour, time.minute),
      hasTime: time != null,
      vetName: _orNull(_vetController),
      clinicName: _orNull(_clinicController),
      reason: _orNull(_reasonController),
      report: _showReport ? _orNull(_reportController) : null,
      petId: _petId,
    ));
    Navigator.of(context).pop();
  }

  static String? _orNull(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _confirmDelete() async {
    final confirmed = await confirmDeletion(
      context,
      title: 'Supprimer cette visite ?',
      message: (widget.initial?.documentCount ?? 0) > 0
          ? 'La visite et ses ${widget.initial!.documentCount} documents disparaîtront du carnet et du journal, sans retour possible.'
          : 'La visite disparaîtra du carnet de santé et ne pourra pas être récupérée.',
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
        TimeFieldWidget(
          label: 'Heure (optionnel)',
          placeholder: 'Ajouter une heure',
          value: _time == null ? null : DateTime(2000, 1, 1, _time!.hour, _time!.minute),
          onChanged: (time) => setState(() => _time = time),
        ),
        if (_time != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => _time = null),
              child: const Text('Retirer l’heure'),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        _buildField(_vetController, 'Vétérinaire (optionnel)', capitalize: true),
        const SizedBox(height: AppSpacing.md),
        _buildField(_clinicController, 'Clinique (optionnel)', capitalize: true),
        const SizedBox(height: AppSpacing.md),
        _buildField(_reasonController, 'Détails du motif (optionnel)', capitalize: true, multiline: true),
        if (_showReport) ...[
          const SizedBox(height: AppSpacing.md),
          _buildField(_reportController, 'Compte-rendu (optionnel)', capitalize: true, multiline: true),
        ],
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool capitalize = false,
    bool multiline = false,
  }) {
    return TextField(
      controller: controller,
      minLines: multiline ? 2 : 1,
      maxLines: multiline ? 5 : 1,
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
