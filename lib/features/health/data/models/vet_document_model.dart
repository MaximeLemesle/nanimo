enum VetDocumentType {
  ordonnance('ordonnance', 'Ordonnance'),
  facture('facture', 'Facture'),
  analyses('analyses', 'Analyses'),
  compteRendu('compte_rendu', 'Compte-rendu'),
  autre('autre', 'Autre');

  final String code;
  final String label;

  const VetDocumentType(this.code, this.label);

  static VetDocumentType fromCode(String? code) =>
      values.firstWhere((type) => type.code == code, orElse: () => autre);
}

enum VetDocumentSource { camera, gallery, file }

class VetDocumentModel {
  static const maxPerVisit = 10;
  static const maxBytes = 10 * 1024 * 1024;

  final String documentId;
  final String eventId;
  final String storagePath;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final VetDocumentType type;
  final VetDocumentSource source;
  final DateTime? createdAt;

  const VetDocumentModel({
    required this.documentId,
    required this.eventId,
    required this.storagePath,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.type = VetDocumentType.autre,
    required this.source,
    this.createdAt,
  });

  bool get isPdf => mimeType == 'application/pdf';

  factory VetDocumentModel.fromJson(Map<String, dynamic> json) {
    return VetDocumentModel(
      documentId: json['id_event_document'] as String,
      eventId: json['event_id'] as String,
      storagePath: json['storage_path'] as String,
      fileName: json['file_name'] as String,
      mimeType: json['mime_type'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
      type: VetDocumentType.fromCode(json['doc_type'] as String?),
      source: VetDocumentSource.values.firstWhere(
        (source) => source.name == json['source'],
        orElse: () => VetDocumentSource.file,
      ),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_event_document': documentId,
        'event_id': eventId,
        'storage_path': storagePath,
        'file_name': fileName,
        'mime_type': mimeType,
        'size_bytes': sizeBytes,
        'doc_type': type.code,
        'source': source.name,
      };

  /// Only what the bucket accepts; anything else is refused before upload.
  static String? mimeTypeFor(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot == -1) return null;
    return switch (fileName.substring(dot + 1).toLowerCase()) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'heic' => 'image/heic',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      _ => null,
    };
  }
}
