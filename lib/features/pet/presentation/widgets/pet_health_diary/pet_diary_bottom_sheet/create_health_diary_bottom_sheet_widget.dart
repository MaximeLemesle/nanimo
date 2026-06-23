import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_section/birth_weight_section_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_section/health_diary_section_widget.dart';

typedef VaccineEntry = ({
  String name,
  DateTime lastDate,
  DateTime nextDate,
  int recurrence,
});

typedef VetVisitEntry = ({
  String title,
  DateTime visitedAt,
  String? vetName,
  String? clinicName,
});

typedef CreateHealthDiarySubmit = void Function({
  double? birthWeight,
  DateTime? birthWeightDate,
  bool? isSterilized,
  bool? isChipped,
  String? chipNumber,
  DateTime? lastDeworming,
  required List<VaccineEntry> vaccines,
  required List<VetVisitEntry> vetVisits,
});

class CreateHealthDiaryBottomSheetWidget extends StatefulWidget {
  final String petName;
  final DateTime birthdate;
  final List<RecommendedVaccineModel> recommendedVaccines;
  final CreateHealthDiarySubmit onSubmit;

  const CreateHealthDiaryBottomSheetWidget({
    super.key,
    required this.petName,
    required this.birthdate,
    required this.recommendedVaccines,
    required this.onSubmit,
  });

  @override
  State<CreateHealthDiaryBottomSheetWidget> createState() =>
      _CreateHealthDiaryBottomSheetWidgetState();
}

class _CreateHealthDiaryBottomSheetWidgetState
    extends State<CreateHealthDiaryBottomSheetWidget> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chipController = TextEditingController();

  late DateTime _birthWeightDate;
  bool _isSterilized = false;
  bool _isChipped = false;
  bool _isDewormed = false;
  DateTime? _lastDeworming;
  bool _hasVaccines = false;
  final Map<String, DateTime> _checkedVaccines = {};
  bool _hasVetVisits = false;
  final List<VetVisitEntry> _vetVisits = [];

  @override
  void initState() {
    super.initState();
    _birthWeightDate = widget.birthdate;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _chipController.dispose();
    super.dispose();
  }

  /// Opens the vet visit sheet and appends the created visit.
  Future<void> _addVetVisit() async {
    final result = await BottomSheetWidget.show<VetVisitEntry?>(
      context,
      AddVetVisitBottomSheetWidget(
        onSubmit: ({
          required String title,
          required DateTime visitedAt,
          String? vetName,
          String? clinicName,
        }) {
          Navigator.of(context).pop((
            title: title,
            visitedAt: visitedAt,
            vetName: vetName,
            clinicName: clinicName,
          ));
        },
      ),
    );
    if (result != null && mounted) {
      setState(() => _vetVisits.add(result));
    }
  }

  void _submit() {
    final vaccines = _hasVaccines
        ? [
            for (final vaccine in widget.recommendedVaccines)
              if (_checkedVaccines.containsKey(vaccine.name))
                (
                  name: vaccine.name,
                  lastDate: _checkedVaccines[vaccine.name]!,
                  nextDate: _checkedVaccines[vaccine.name]!
                      .add(Duration(days: vaccine.recurrenceDays)),
                  recurrence: vaccine.recurrenceDays,
                ),
          ]
        : <VaccineEntry>[];

    widget.onSubmit(
      birthWeight: WeightFormatter.parseWeight(_weightController.text),
      birthWeightDate: _birthWeightDate,
      isSterilized: _isSterilized,
      isChipped: _isChipped,
      chipNumber: _isChipped && _chipController.text.trim().isNotEmpty
          ? _chipController.text.trim()
          : null,
      lastDeworming: _isDewormed ? (_lastDeworming ?? DateTime.now()) : null,
      vaccines: vaccines,
      vetVisits: _hasVetVisits ? _vetVisits : <VetVisitEntry>[],
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Création du carnet de santé',
      scrollable: true,
      action: ButtonWidget(
        label: 'Enregistrer',
        fullWidth: true,
        onPressed: _submit,
      ),
      children: [
        /// Add pet's birth weight
        BirthWeightSectionWidget(
          petName: widget.petName,
          weightController: _weightController,
          weightDate: _birthWeightDate,
          onWeightChanged: () => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),

        /// Sterilized
        HealthDiarySectionWidget(
          label: 'Stérilisé',
          value: _isSterilized,
          onChanged: (value) => setState(() => _isSterilized = value),
        ),

        /// Dewormed
        HealthDiarySectionWidget(
          label: 'Vermifugé',
          value: _isDewormed,
          onChanged: (value) => setState(() => _isDewormed = value),
          child: DateFieldWidget(
            label: 'Dernier vermifuge',
            value: _lastDeworming,
            onChanged: (date) => setState(() => _lastDeworming = date),
          ),
        ),

        /// Chipped
        HealthDiarySectionWidget(
          label: 'Pucé',
          value: _isChipped,
          onChanged: (value) => setState(() => _isChipped = value),
          child: TextFieldWidget(
            controller: _chipController,
            label: 'Numéro de puce',
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
        ),

        /// Vaccines
        HealthDiarySectionWidget(
          label: 'Déjà reçu des vaccins ?',
          value: _hasVaccines,
          onChanged: (value) => setState(() => _hasVaccines = value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.recommendedVaccines.map(_vaccineRow).toList(),
          ),
        ),

        /// Vet visits
        HealthDiarySectionWidget(
          label: 'Déjà allé chez le véto ?',
          value: _hasVetVisits,
          onChanged: (value) => setState(() => _hasVetVisits = value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._vetVisits.asMap().entries.map(_vetVisitRow),
              TextButton.icon(
                onPressed: _addVetVisit,
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: Text(
                  'Ajouter une visite',
                  style: AppTextStyles.textSmallBold
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// List of recommended vaccines
  Widget _vaccineRow(RecommendedVaccineModel vaccine) {
    final isChecked = _checkedVaccines.containsKey(vaccine.name);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.lg,
                height: AppSpacing.lg,
                child: Checkbox(
                  value: isChecked,
                  activeColor: AppColors.primary,
                  onChanged: (checked) => setState(() {
                    if (checked == true) {
                      _checkedVaccines[vaccine.name] = DateTime.now();
                    } else {
                      _checkedVaccines.remove(vaccine.name);
                    }
                  }),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(vaccine.name, style: AppTextStyles.text)),
            ],
          ),
          if (isChecked) ...[
            const SizedBox(height: AppSpacing.sm),
            DateFieldWidget(
              label: 'Date du vaccin',
              value: _checkedVaccines[vaccine.name],
              onChanged: (date) =>
                  setState(() => _checkedVaccines[vaccine.name] = date),
            ),
          ],
        ],
      ),
    );
  }

  /// List of vet visit
  Widget _vetVisitRow(MapEntry<int, VetVisitEntry> entry) {
    final visit = entry.value;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${visit.title} — ${DateFormatter.date(visit.visitedAt)}',
              style: AppTextStyles.text,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () => setState(() => _vetVisits.removeAt(entry.key)),
          ),
        ],
      ),
    );
  }
}
