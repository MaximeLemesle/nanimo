import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/diary_date_bounds.dart';
import 'package:nanimo/core/utils/vaccine_schedule.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';

typedef VaccineSubmit = void Function({
  required String vaccineName,
  DateTime? lastDate,
  DateTime? nextDate,
  required int recurrence,
  String? petId,
});

/// One date field, the same everywhere (NAN-096). A future date is the
/// booster to come; a past one asks when the next is due.
class AddVaccineBottomSheetWidget extends StatefulWidget {
  final VaccineSubmit onSubmit;
  final HealthDiaryVaccineModel? initial;

  /// Floor of the date picker. Ignored when [pets] carries the animal.
  final DateTime birthdate;

  /// Opt-in animal selector, same contract as [AddVetVisitBottomSheetWidget].
  final List<PetModel> pets;
  final Map<String, PetPortrait> portraits;
  final String? initialPetId;

  /// Offered in edit mode only, behind a confirmation.
  final VoidCallback? onDelete;

  const AddVaccineBottomSheetWidget({
    super.key,
    required this.onSubmit,
    required this.birthdate,
    this.initial,
    this.pets = const [],
    this.portraits = const {},
    this.initialPetId,
    this.onDelete,
  });

  @override
  State<AddVaccineBottomSheetWidget> createState() => _AddVaccineBottomSheetWidgetState();
}

class _AddVaccineBottomSheetWidgetState extends State<AddVaccineBottomSheetWidget> {
  late final TextEditingController _nameController;
  DateTime? _date;
  int? _months;
  bool _unknown = false;

  /// A saved booster whose date matches none of the offered intervals.
  DateTime? _keptNextDate;

  late String? _petId = widget.initialPetId ??
      (widget.pets.isNotEmpty ? widget.pets.first.petId : null);

  /// An existing vaccine already belongs to a diary, nothing left to pick.
  bool get _showPetPicker => widget.initial == null && widget.pets.length > 1;

  /// The picker may change the animal under the date field.
  DateTime get _birthdate {
    for (final pet in widget.pets) {
      if (pet.petId == _petId) return pet.birthdate;
    }
    return widget.birthdate;
  }

  bool get _asksNext => _date != null && !VaccineSchedule.isUpcoming(_date!);

  bool get _nextChosen => _months != null || _unknown || _keptNextDate != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.vaccineName ?? '');
    if (initial == null) return;

    final last = initial.lastDate;
    final next = initial.nextDate;
    if (last == null) {
      _date = next;
      return;
    }
    _date = last;
    if (next == null) {
      _unknown = true;
      return;
    }
    final months = VaccineSchedule.monthsFromRecurrence(initial.recurrence);
    if (months != null && VaccineSchedule.addMonths(last, months) == DateTime(next.year, next.month, next.day)) {
      _months = months;
    } else {
      _keptNextDate = next;
    }
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _date != null &&
      (!_asksNext || _nextChosen) &&
      (!_showPetPicker || _petId != null);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _choose({int? months, bool unknown = false}) {
    setState(() {
      _months = months;
      _unknown = unknown;
      _keptNextDate = null;
    });
  }

  void _submit() {
    if (!_isValid) return;
    final kept = _keptNextDate;
    final resolved = _asksNext && kept != null
        ? (lastDate: _date, nextDate: kept, recurrence: widget.initial?.recurrence ?? 0)
        : VaccineSchedule.resolve(date: _date!, monthsUntilNext: _unknown ? null : _months);
    widget.onSubmit(
      vaccineName: _nameController.text.trim(),
      lastDate: resolved.lastDate,
      nextDate: resolved.nextDate,
      recurrence: resolved.recurrence,
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
          label: 'Date du vaccin',
          value: _date,
          firstDate: _birthdate,
          lastDate: DiaryDateBounds.openEnd(),
          onChanged: (date) => setState(() => _date = date),
        ),
        if (_asksNext) ...[
          const SizedBox(height: AppSpacing.md),
          Text('Quand est le prochain rappel ?', style: AppTextStyles.textBold),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (_keptNextDate case final kept?)
                ChipWidget(label: 'Le ${DateFormatter.date(kept)}', isSelected: true),
              for (final months in VaccineSchedule.intervals)
                ChipWidget(
                  label: 'Dans $months mois',
                  isSelected: _months == months && !_unknown,
                  onTap: () => _choose(months: months),
                ),
              ChipWidget(
                label: 'Je ne sais pas',
                isSelected: _unknown,
                onTap: () => _choose(unknown: true),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
