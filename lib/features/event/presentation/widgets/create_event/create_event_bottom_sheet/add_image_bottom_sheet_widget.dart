import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';

class AddImageBottomSheetWidget extends StatelessWidget {
  const AddImageBottomSheetWidget({super.key});

  static Future<List<XFile>?> show(BuildContext context) {
    return BottomSheetWidget.show<List<XFile>>(
      context,
      const AddImageBottomSheetWidget(),
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
          label: 'Sélectionner plusieurs photos',
          onTap: () => _pickMultiple(context),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(label, style: AppTextStyles.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
