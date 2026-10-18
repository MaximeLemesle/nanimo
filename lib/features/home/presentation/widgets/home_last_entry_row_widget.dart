import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';

/// « Dernière visite pour Dobby il y a 3 mois »: where a pet stands when
/// nothing is booked (NAN-115).
class HomeLastEntryRowWidget extends StatelessWidget {
  final LastHealthEntry entry;
  final String lead;
  final PetPortrait? portrait;
  final void Function(String petId)? onTap;
  final DateTime? now;

  const HomeLastEntryRowWidget({
    super.key,
    required this.entry,
    required this.lead,
    this.portrait,
    this.onTap,
    this.now,
  });

  static String labelFor(String lead, LastHealthEntry entry, {DateTime? now}) =>
      '$lead pour ${entry.pet.petName} ${DateFormatter.elapsed(entry.at, now: now)}';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(entry.pet.petId),
      child: Row(
        children: [
          SizedBox.square(
            dimension: PetAvatarSize.small.dimension,
            child: portrait == null ? null : PetAvatarWidget(portrait: portrait!, size: PetAvatarSize.small),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              labelFor(lead, entry, now: now),
              style: AppTextStyles.text.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
