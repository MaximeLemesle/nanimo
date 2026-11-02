import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';

typedef VetDocumentChoice = ({VetDocumentSource source, VetDocumentType type});

/// The type is optional: « Autre » stays selected unless the user picks one.
class AddVetDocumentBottomSheetWidget extends StatefulWidget {
  const AddVetDocumentBottomSheetWidget({super.key});

  static Future<VetDocumentChoice?> show(BuildContext context) =>
      BottomSheetWidget.show<VetDocumentChoice>(context, const AddVetDocumentBottomSheetWidget());

  @override
  State<AddVetDocumentBottomSheetWidget> createState() => _AddVetDocumentBottomSheetWidgetState();
}

class _AddVetDocumentBottomSheetWidgetState extends State<AddVetDocumentBottomSheetWidget> {
  VetDocumentType _type = VetDocumentType.autre;

  void _pick(VetDocumentSource source) => Navigator.of(context).pop((source: source, type: _type));

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Ajouter un document',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in VetDocumentType.values)
              ChipWidget(
                label: type.label,
                isSelected: type == _type,
                onTap: () => setState(() => _type = type),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ButtonWidget(
          label: 'Prendre une photo',
          icon: Icons.photo_camera_outlined,
          iconPosition: ButtonIcon.left,
          type: ButtonType.secondary,
          fullWidth: true,
          onPressed: () => _pick(VetDocumentSource.camera),
        ),
        const SizedBox(height: AppSpacing.sm),
        ButtonWidget(
          label: 'Choisir dans la galerie',
          icon: Icons.photo_library_outlined,
          iconPosition: ButtonIcon.left,
          type: ButtonType.secondary,
          fullWidth: true,
          onPressed: () => _pick(VetDocumentSource.gallery),
        ),
        const SizedBox(height: AppSpacing.sm),
        ButtonWidget(
          label: 'Importer un fichier (PDF)',
          icon: Icons.upload_file_outlined,
          iconPosition: ButtonIcon.left,
          type: ButtonType.secondary,
          fullWidth: true,
          onPressed: () => _pick(VetDocumentSource.file),
        ),
      ],
    );
  }
}
