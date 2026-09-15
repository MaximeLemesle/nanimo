import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/gender_formatter.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_edit_button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_selection_hint_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';

class PetSummaryDiaryCardWidget extends StatefulWidget {
  final PetModel pet;
  final String speciesName;
  final String raceName;
  final List<HealthDiaryWeightLogModel> weightLogs;
  final HealthDiaryModel? diary;

  /// Opens the pet edit screen, which owns the identity fields.
  final VoidCallback? onEditIdentity;

  /// Opens the health info sheet, which owns the chip and the neutering.
  final VoidCallback? onEditHealthInfo;

  /// Opens the weight sheet.
  final VoidCallback? onEditWeight;

  const PetSummaryDiaryCardWidget({
    super.key,
    required this.pet,
    required this.speciesName,
    required this.raceName,
    required this.weightLogs,
    this.diary,
    this.onEditIdentity,
    this.onEditHealthInfo,
    this.onEditWeight,
  });

  @override
  State<PetSummaryDiaryCardWidget> createState() =>
      _PetSummaryDiaryCardWidgetState();
}

class _PetSummaryDiaryCardWidgetState extends State<PetSummaryDiaryCardWidget> {
  bool _isSelecting = false;

  /// Each row routes to the one screen that already owns its field.
  VoidCallback? _tap(VoidCallback? destination) =>
      _isSelecting ? destination : null;

  Widget? get _chevron => _isSelecting
      ? const Icon(Icons.chevron_right_rounded, color: AppColors.primary)
      : null;

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final diary = widget.diary;

    return PetDiaryCardWidget(
      title: 'Récapitulatif',
      action: PetDiaryEditButtonWidget(
        isSelecting: _isSelecting,
        tooltip: _isSelecting
            ? 'Annuler la modification'
            : 'Modifier une information',
        onPressed: () => setState(() => _isSelecting = !_isSelecting),
      ),
      children: [
        if (_isSelecting)
          const PetDiarySelectionHintWidget(
            label: 'Choisis l\'information à modifier',
          ),
        PetDiaryTableWidget(
          rows: [
            PetDiaryRow(
              label: 'Nom',
              value: pet.petName,
              trailing: _chevron,
              onTap: _tap(widget.onEditIdentity),
            ),
            PetDiaryRow(
              label: 'Espèce',
              value: widget.speciesName,
            ),
            PetDiaryRow(
              label: 'Race',
              value: widget.raceName,
              trailing: _chevron,
              onTap: _tap(widget.onEditIdentity),
            ),
            PetDiaryRow(
              label: 'Genre',
              value: GenderFormatter.label(pet.gender),
              trailing: _chevron,
              onTap: _tap(widget.onEditIdentity),
            ),

            /// Above the age, which is derived from it.
            PetDiaryRow(
              label: 'Date de naissance',
              value: DateFormatter.date(pet.birthdate),
              trailing: _chevron,
              onTap: _tap(widget.onEditIdentity),
            ),
            PetDiaryRow(
              label: 'Âge',
              value: DateFormatter.ageDetailed(pet.birthdate),
            ),
            PetDiaryRow(
              label: 'Poids',
              value: widget.weightLogs.isEmpty
                  ? '—'
                  : WeightFormatter.label(widget.weightLogs.last.weight),
              trailing: _chevron,
              onTap: _tap(widget.onEditWeight),
            ),
            PetDiaryRow(
              label: 'Numéro de puce',
              value: (diary?.isChipped == true && diary?.chipNumber != null)
                  ? diary!.chipNumber!
                  : 'Non',
              trailing: _chevron,
              onTap: _tap(widget.onEditHealthInfo),
            ),
            PetDiaryRow(
              label: 'Stérilisée',
              value: diary?.isSterilized == null
                  ? 'Non'
                  : (diary!.isSterilized! ? 'Oui' : 'Non'),
              trailing: _chevron,
              onTap: _tap(widget.onEditHealthInfo),
            ),
          ],
        ),
      ],
    );
  }
}
