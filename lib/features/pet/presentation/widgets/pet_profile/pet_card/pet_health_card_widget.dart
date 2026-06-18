import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card/pet_card_item_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card/pet_card_widget.dart';

class PetHealthCardWidget extends StatelessWidget {
  final HealthDiaryModel? diary;
  final VoidCallback? onFillPressed;

  const PetHealthCardWidget({super.key, this.diary, this.onFillPressed});

  @override
  Widget build(BuildContext context) {
    final hasInfo = diary != null &&
        (diary?.isSterilized != null ||
            diary?.isChipped != null ||
            diary?.lastDeworming != null ||
            diary?.lastVetAppointment != null);

    switch (hasInfo) {
      case false:

        /// Return a card to invite the user to complete the health diary
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

        /// Return card with pet information
        return PetCardWidget(
          label: 'Informations de santé',
          backgroundColor: AppColors.backgroundTertiary,
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
              value: diary?.lastVetAppointment == null
                  ? '—'
                  : DateFormatter.date(diary!.lastVetAppointment!),
              subValue: 'Pensez à en faire au moins un chaque année',
            ),
          ],
        );
    }
  }
}
