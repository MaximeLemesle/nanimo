import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

const String petIconPickerTitle = 'Choisis son portrait';
const String petIconPickerEmpty =
    'Aucun portrait n’est encore disponible pour cette espèce.';

/// Gallery of the icons available for one species. The catalogue is filtered
/// upstream, so this sheet never has to know which species it is showing.
class PetIconPickerBottomSheetWidget extends StatelessWidget {
  final String speciesIconKey;
  final List<PetIconModel> icons;
  final String? selectedPetIconId;
  final SubscriptionState subscription;
  final ValueChanged<String?> onSelected;

  const PetIconPickerBottomSheetWidget({
    super.key,
    required this.speciesIconKey,
    required this.icons,
    required this.selectedPetIconId,
    required this.subscription,
    required this.onSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String speciesIconKey,
    required List<PetIconModel> icons,
    required String? selectedPetIconId,
    required SubscriptionState subscription,
    required ValueChanged<String?> onSelected,
  }) {
    return BottomSheetWidget.show<void>(
      context,
      PetIconPickerBottomSheetWidget(
        speciesIconKey: speciesIconKey,
        icons: icons,
        selectedPetIconId: selectedPetIconId,
        subscription: subscription,
        onSelected: onSelected,
      ),
    );
  }

  /// A locked tile stays tappable on purpose: the crown is a door to the
  /// paywall, not a wall. The sheet closes first so the paywall lands above it.
  void _onTap(BuildContext context, PetIconModel? icon) {
    final locked = icon != null && icon.isPremium && !subscription.isPremium;
    if (!locked) {
      Navigator.of(context).pop();
      onSelected(icon?.petIconId);
      return;
    }

    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final offersUpgrade = QuotaUpsell.offersUpgrade(subscription);
    Navigator.of(context).pop();

    if (offersUpgrade) {
      router.push(RouteNames.paywall);
      return;
    }
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text(subscriptionUnavailableMessage)),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (icons.isEmpty) {
      return BottomSheetWidget(
        title: petIconPickerTitle,
        children: [
          Text(petIconPickerEmpty, style: AppTextStyles.text),
        ],
      );
    }

    return BottomSheetWidget(
      title: petIconPickerTitle,
      scrollable: true,
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.85,
          children: [
            _PetIconTile(
              label: 'Par défaut',
              speciesIconKey: speciesIconKey,
              assetPath: null,
              isSelected: selectedPetIconId == null,
              isLocked: false,
              onTap: () => _onTap(context, null),
            ),
            for (final icon in icons)
              _PetIconTile(
                label: icon.petIconName,
                speciesIconKey: speciesIconKey,
                assetPath: icon.assetPath,
                isSelected: icon.petIconId == selectedPetIconId,
                isLocked: icon.isPremium && !subscription.isPremium,
                onTap: () => _onTap(context, icon),
              ),
          ],
        ),
      ],
    );
  }
}

class _PetIconTile extends StatelessWidget {
  final String label;
  final String speciesIconKey;
  final String? assetPath;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _PetIconTile({
    required this.label,
    required this.speciesIconKey,
    required this.assetPath,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor =
        isLocked ? AppColors.textSecondary : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.backgroundStroke
                    : AppColors.backgroundSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.backgroundStroke,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: SpeciesIconWidget(
                portrait: PetPortrait(
                  iconKey: speciesIconKey,
                  assetPath: assetPath,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textSmall.copyWith(color: labelColor),
                ),
              ),
              if (isLocked) ...[
                const SizedBox(width: AppSpacing.xs),
                Semantics(
                  label: 'Réservé au premium',
                  child: const AppIconWidget(
                    AppIcons.crown,
                    size: 18,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
