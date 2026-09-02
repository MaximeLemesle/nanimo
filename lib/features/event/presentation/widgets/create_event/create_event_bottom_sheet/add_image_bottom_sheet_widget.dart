import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

const String multipleImagesLabel = 'Sélectionner plusieurs photos';

class AddImageBottomSheetWidget extends StatelessWidget {
  final SubscriptionState subscription;

  const AddImageBottomSheetWidget({super.key, required this.subscription});

  static Future<List<XFile>?> show(
    BuildContext context, {
    required SubscriptionState subscription,
  }) {
    return BottomSheetWidget.show<List<XFile>>(
      context,
      AddImageBottomSheetWidget(subscription: subscription),
    );
  }

  Future<void> _pickSingle(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (!context.mounted) return;
    Navigator.of(context).pop(image == null ? <XFile>[] : [image]);
  }

  Future<void> _pickMultiple(BuildContext context) async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (!context.mounted) return;
    Navigator.of(context).pop(images);
  }

  /// One photo per souvenir on the free plan makes a multi pick pointless, so
  /// the row is locked rather than hidden. The sheet closes first: the paywall
  /// and the fallback message both belong above it, not behind it.
  Future<void> _onMultipleTap(BuildContext context) async {
    if (subscription.isPremium) {
      await _pickMultiple(context);
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
    return BottomSheetWidget(
      title: 'Que voulez-vous faire ?',
      children: [
        _ActionRow(
          icon: Icons.photo_camera_outlined,
          label: 'Prendre une photo',
          onTap: () => _pickSingle(context, ImageSource.camera),
        ),
        _ActionRow(
          icon: Icons.image_outlined,
          label: 'Sélectionner une photo',
          onTap: () => _pickSingle(context, ImageSource.gallery),
        ),
        _ActionRow(
          icon: Icons.collections_outlined,
          label: multipleImagesLabel,
          enabled: subscription.isPremium,
          onTap: () => _onMultipleTap(context),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: enabled ? AppColors.primary50 : AppColors.backgroundStroke,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: foreground, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: enabled ? AppTextStyles.text : AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                ),
              ),
              if (!enabled) ...[
                const SizedBox(width: AppSpacing.sm),
                Semantics(
                  label: 'Réservé au premium',
                  child: AppIconWidget(
                    AppIcons.crown,
                    color: AppColors.tertiary,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
