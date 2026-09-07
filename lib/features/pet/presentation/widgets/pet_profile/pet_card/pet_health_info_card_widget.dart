import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_item_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_widget.dart';

class PetHealthInfoCardWidget extends StatelessWidget {
  final HealthDiaryModel? diary;
  final List<VetVisitModel> vetVisits;
  final VoidCallback? onFillPressed;
  final VoidCallback? onEditPressed;

  const PetHealthInfoCardWidget({
    super.key,
    this.diary,
    this.vetVisits = const [],
    this.onFillPressed,
    this.onEditPressed,
  });

  /// The most recent visit on record, falling back to the diary column
  DateTime? get _lastVetAppointment {
    DateTime? latest;
    for (final visit in vetVisits) {
      if (latest == null || visit.visitedAt.isAfter(latest)) {
        latest = visit.visitedAt;
      }
    }
    return latest ?? diary?.lastVetAppointment;
  }

  @override
  Widget build(BuildContext context) {
    final lastVetAppointment = _lastVetAppointment;
    final hasInfo = diary != null &&
        (diary?.isSterilized != null ||
            diary?.isChipped != null ||
            diary?.lastDeworming != null ||
            lastVetAppointment != null);

    switch (hasInfo) {
      case false:

        return Column(
          children: [
            PetCardWidget(
              label: 'Informations de santé',
              backgroundColor: AppColors.backgroundTertiary,
              items: [
                PetCardItemWidget(
                  label:
                      'Renseignez le carnet de santé de votre animal pour suivre sa stérilisation, sa puce et ses rendez-vous vétérinaires.',
                  value: 'Aucune information pour le moment',
                ),
              ],
              button: ButtonWidget(
                label: 'Remplir le carnet',
                fullWidth: true,
                iconPosition: ButtonIcon.left,
                icon: Icons.add,
                onPressed: onFillPressed,
              ),
            ),
          ],
        );

      case true:

        return PetCardWidget(
          label: 'Informations de santé',
          backgroundColor: AppColors.backgroundTertiary,

          /// Hidden before the diary exists: "Remplir le carnet" is the way in.
          action: onEditPressed == null
              ? null
              : IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: AppColors.textSecondary,
                  tooltip: 'Modifier les informations de santé',
                  onPressed: onEditPressed,
                ),
          items: [
            PetCardItemWidget(
              label: 'Stérilisé',
              value: diary?.isSterilized == null
                  ? '—'
                  : (diary!.isSterilized! ? 'Oui' : 'Non'),
            ),
            PetCardItemWidget(
              label: 'Pucé',
              value: diary?.isChipped == null
                  ? '—'
                  : (diary!.isChipped! ? 'Oui' : 'Non'),
              subValue: diary?.isChipped == true ? diary?.chipNumber : null,
            ),
            PetCardItemWidget(
              label: 'Dernier vermifuge',
              value: diary?.lastDeworming == null
                  ? '—'
                  : DateFormatter.date(diary!.lastDeworming!),
              subValue: 'Pensez à le refaire tous les 6 mois',
            ),
            PetCardItemWidget(
              label: 'Dernier rendez-vous vétérinaire',
              value: lastVetAppointment == null
                  ? '—'
                  : DateFormatter.date(lastVetAppointment),
              subValue: 'Pensez à en faire au moins un chaque année',
            ),
          ],
        );
    }
  }
}
