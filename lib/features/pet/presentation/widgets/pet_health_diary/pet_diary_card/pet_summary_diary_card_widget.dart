import 'package:flutter/material.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/gender_formatter.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';

class PetSummaryDiaryCardWidget extends StatelessWidget {
  final PetModel pet;
  final String speciesName;
  final String raceName;
  final List<HealthDiaryWeightLogModel> weightLogs;
  final HealthDiaryModel? diary;

  const PetSummaryDiaryCardWidget({
    super.key,
    required this.pet,
    required this.speciesName,
    required this.raceName,
    required this.weightLogs,
    this.diary,
  });

  @override
  Widget build(BuildContext context) {
    return PetDiaryCardWidget(
      title: 'Récapitulatif',
      children: [
        PetDiaryTableWidget(
          rows: [
            PetDiaryRow(
              label: 'Espèce',
              value: speciesName,
            ),
            PetDiaryRow(label: 'Race', value: raceName),
            PetDiaryRow(
                label: 'Genre', value: GenderFormatter.label(pet.gender)),
            PetDiaryRow(
              label: 'Âge',
              value: DateFormatter.ageDetailed(pet.birthdate),
            ),
            PetDiaryRow(
              label: 'Poids',
              value: weightLogs.isEmpty
                  ? '—'
                  : WeightFormatter.label(weightLogs.last.weight),
            ),
            PetDiaryRow(
              label: 'Numéro de puce',
              value: (diary?.isChipped == true && diary?.chipNumber != null)
                  ? diary?.chipNumber!
                  : 'Non',
            ),
            PetDiaryRow(
              label: 'Stérilisée',
              value: diary?.isSterilized == null
                  ? 'Non'
                  : (diary!.isSterilized! ? 'Oui' : 'Non'),
            ),
          ],
        ),
      ],
    );
  }
}
