import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';

/// Images stream from a signed url; a PDF has to be on disk for the renderer.
class VetDocumentViewerPage extends StatefulWidget {
  final VetDocumentModel document;
  final Future<String?> Function(VetDocumentModel) urlResolver;
  final Future<File?> Function(VetDocumentModel) fileResolver;
  final VoidCallback onShare;

  const VetDocumentViewerPage({
    super.key,
    required this.document,
    required this.urlResolver,
    required this.fileResolver,
    required this.onShare,
  });

  static Future<void> open(
    BuildContext context, {
    required VetDocumentModel document,
    required Future<String?> Function(VetDocumentModel) urlResolver,
    required Future<File?> Function(VetDocumentModel) fileResolver,
    required VoidCallback onShare,
  }) {
    return Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
      builder: (_) => VetDocumentViewerPage(
        document: document,
        urlResolver: urlResolver,
        fileResolver: fileResolver,
        onShare: onShare,
      ),
    ));
  }

  @override
  State<VetDocumentViewerPage> createState() => _VetDocumentViewerPageState();
}

class _VetDocumentViewerPageState extends State<VetDocumentViewerPage> {
  late final Future<Object?> _source = widget.document.isPdf
      ? widget.fileResolver(widget.document)
      : widget.urlResolver(widget.document);
  PdfControllerPinch? _pdfController;

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundInvert,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundInvert,
        foregroundColor: AppColors.textInvert,
        title: Text(
          widget.document.type == VetDocumentType.autre ? widget.document.fileName : widget.document.type.label,
          style: AppTextStyles.textBold.copyWith(color: AppColors.textInvert),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'Partager',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: widget.onShare,
          ),
        ],
      ),
      body: FutureBuilder<Object?>(
        future: _source,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: AppColors.textInvert));
          }
          final source = snapshot.data;
          if (source == null) return const _Unavailable();
          if (source is File) {
            _pdfController ??= PdfControllerPinch(document: PdfDocument.openFile(source.path));
            return PdfViewPinch(controller: _pdfController!);
          }
          return InteractiveViewer(
            maxScale: 5,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: source as String,
                cacheKey: widget.document.storagePath,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => const _Unavailable(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Le document n’a pas pu être ouvert.\nVérifie ta connexion, puis réessaie.',
        textAlign: TextAlign.center,
        style: AppTextStyles.text.copyWith(color: AppColors.textInvert),
      ),
    );
  }
}
