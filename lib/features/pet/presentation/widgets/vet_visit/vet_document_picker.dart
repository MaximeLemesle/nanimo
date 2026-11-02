import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';

typedef PickedVetDocument = ({File file, String fileName});

/// Camera and gallery go through image_picker so the photo is compressed;
/// only the file browser can return a PDF.
class VetDocumentPicker {
  static const _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'webp'];

  const VetDocumentPicker();

  Future<PickedVetDocument?> pick(VetDocumentSource source) async {
    switch (source) {
      case VetDocumentSource.camera:
      case VetDocumentSource.gallery:
        final image = await ImagePicker().pickImage(
          source: source == VetDocumentSource.camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 2400,
          maxHeight: 2400,
        );
        if (image == null) return null;
        return (file: File(image.path), fileName: image.name);
      case VetDocumentSource.file:
        final files = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: _allowedExtensions,
        );
        final path = files.isEmpty ? null : files.first.path;
        if (path == null) return null;
        return (file: File(path), fileName: files.first.name);
    }
  }
}
