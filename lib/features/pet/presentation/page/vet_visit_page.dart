import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/confirm_deletion_dialog.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/vet_visit_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/vet_document_viewer_page.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/add_vet_document_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/vet_document_picker.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/vet_visit_status_widget.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/pet_lock.dart';

/// The visit as an event (NAN-133): read from the journal and the record alike.
class VetVisitPage extends StatelessWidget {
  final VetDocumentPicker picker;

  const VetVisitPage({super.key, this.picker = const VetDocumentPicker()});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VetVisitCubit, VetVisitState>(
      listenWhen: (previous, current) =>
          current.error != null && previous.error != current.error ||
          current.status == VetVisitStatus.deleted && previous.status != VetVisitStatus.deleted,
      listener: (context, state) {
        if (state.status == VetVisitStatus.deleted) {
          context.pop();
          return;
        }
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(state.error!)));
        context.read<VetVisitCubit>().clearError();
      },
      builder: (context, state) {
        final visit = state.visit;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Visite vétérinaire', style: AppTextStyles.title02),
            actions: [
              if (visit != null && !_isLocked(context, state))
                IconButton(
                  tooltip: 'Modifier la visite',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _edit(context, visit),
                ),
            ],
          ),
          body: switch (state.status) {
            VetVisitStatus.loading => const Center(child: CircularProgressIndicator()),
            VetVisitStatus.notFound || VetVisitStatus.deleted => Center(
                child: Text('Cette visite n’existe plus.', style: AppTextStyles.text),
              ),
            VetVisitStatus.loaded => _VetVisitBody(
                state: state,
                isLocked: _isLocked(context, state),
                picker: picker,
                onEdit: () => _edit(context, visit!),
              ),
          },
        );
      },
    );
  }

  static bool _isLocked(BuildContext context, VetVisitState state) {
    final visit = state.visit;
    if (visit == null) return false;
    return PetLock.isLocked(visit.petId, state.pets, context.watch<SubscriptionCubit>().state);
  }

  void _edit(BuildContext context, VetVisitModel visit) {
    final cubit = context.read<VetVisitCubit>();
    BottomSheetWidget.show<void>(
      context,
      AddVetVisitBottomSheetWidget(
        initial: visit,
        birthdate: cubit.state.pet?.birthdate,
        onDelete: cubit.deleteVisit,
        onSubmit: (draft) => cubit.updateVisit(draft.applyTo(visit)),
      ),
    );
  }
}

class _VetVisitBody extends StatelessWidget {
  final VetVisitState state;
  final bool isLocked;
  final VetDocumentPicker picker;
  final VoidCallback onEdit;

  const _VetVisitBody({
    required this.state,
    required this.isLocked,
    required this.picker,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final visit = state.visit!;
    final hasReport = visit.report?.trim().isNotEmpty ?? false;
    final hasReason = visit.reason?.trim().isNotEmpty ?? false;
    final isUpcoming = visit.isUpcoming(DateTime.now());

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.bottomBarInset),
      children: [
        _Card(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(visit.title, style: AppTextStyles.title03)),
                VetVisitStatusWidget(visit: visit),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(_when(visit), style: AppTextStyles.text.copyWith(color: AppColors.textSecondary)),
            if (state.pet != null) _Line(icon: Icons.pets_rounded, text: state.pet!.petName),
            if (visit.vetName?.isNotEmpty ?? false) _Line(icon: Icons.person_outline_rounded, text: visit.vetName!),
            if (visit.clinicName?.isNotEmpty ?? false) _Line(icon: Icons.local_hospital_outlined, text: visit.clinicName!),
          ],
        ),
        if (hasReason) ...[
          const SizedBox(height: AppSpacing.lg),
          _Card(title: 'Motif', children: [Text(visit.reason!, style: AppTextStyles.text)]),
        ],
        if (!isUpcoming || hasReport) ...[
          const SizedBox(height: AppSpacing.lg),
          _Card(
            title: 'Compte-rendu',
            children: [
              if (hasReport)
                Text(visit.report!, style: AppTextStyles.text)
              else
                Text(
                  'Note ce que le vétérinaire a dit, pour le retrouver le jour où tu en auras besoin.',
                  style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                ),
              if (!hasReport && !isLocked) ...[
                const SizedBox(height: AppSpacing.md),
                ButtonWidget(
                  label: 'Écrire le compte-rendu',
                  type: ButtonType.secondary,
                  fullWidth: true,
                  onPressed: onEdit,
                ),
              ],
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _DocumentsCard(state: state, isLocked: isLocked, picker: picker),
      ],
    );
  }

  static String _when(VetVisitModel visit) {
    final day = 'Le ${DateFormatter.date(visit.visitedAt)}';
    if (!visit.hasTime) return day;
    final minutes = visit.visitedAt.minute.toString().padLeft(2, '0');
    return '$day à ${visit.visitedAt.hour}h$minutes';
  }
}

class _DocumentsCard extends StatelessWidget {
  final VetVisitState state;
  final bool isLocked;
  final VetDocumentPicker picker;

  const _DocumentsCard({required this.state, required this.isLocked, required this.picker});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VetVisitCubit>();
    return _Card(
      title: 'Documents',
      trailing: Text(
        '${state.documents.length}/${VetDocumentModel.maxPerVisit}',
        style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
      ),
      children: [
        switch (state.documentsStatus) {
          VetDocumentsStatus.loading => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
          VetDocumentsStatus.error => _Retry(onRetry: cubit.refreshDocuments),
          VetDocumentsStatus.loaded when state.documents.isEmpty => Text(
              'Ordonnance, facture, résultats d’analyses : garde-les ici, prêts à être montrés.',
              style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
            ),
          VetDocumentsStatus.loaded => Column(
              children: [
                for (final document in state.documents)
                  _DocumentTile(document: document, canDelete: !isLocked),
              ],
            ),
        },
        if (!isLocked) ...[
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: state.isUploading ? 'Envoi en cours…' : 'Ajouter un document',
            type: ButtonType.secondary,
            icon: Icons.add,
            iconPosition: ButtonIcon.left,
            fullWidth: true,
            state: state.canAddDocument ? ButtonState.normal : ButtonState.disabled,
            onPressed: state.canAddDocument ? () => _add(context) : null,
          ),
        ],
      ],
    );
  }

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<VetVisitCubit>();
    final choice = await AddVetDocumentBottomSheetWidget.show(context);
    if (choice == null) return;
    final picked = await picker.pick(choice.source);
    if (picked == null) return;
    await cubit.addDocument(
      file: picked.file,
      fileName: picked.fileName,
      source: choice.source,
      type: choice.type,
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final VetDocumentModel document;
  final bool canDelete;

  const _DocumentTile({required this.document, required this.canDelete});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VetVisitCubit>();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        document.isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
        color: AppColors.primary,
      ),
      title: Text(document.type.label, style: AppTextStyles.textBold),
      subtitle: Text(document.fileName, overflow: TextOverflow.ellipsis, style: AppTextStyles.textSmall),
      onTap: () => VetDocumentViewerPage.open(
        context,
        document: document,
        urlResolver: cubit.documentUrl,
        fileResolver: cubit.documentFile,
        onShare: () => _share(cubit),
      ),
      trailing: PopupMenuButton<String>(
        tooltip: 'Actions du document',
        onSelected: (action) async {
          if (action == 'share') return _share(cubit);
          final confirmed = await confirmDeletion(
            context,
            title: 'Supprimer ce document ?',
            message: 'Il disparaîtra de la visite et ne pourra pas être récupéré.',
          );
          if (confirmed) await cubit.deleteDocument(document);
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'share', child: Text('Partager')),
          if (canDelete) const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
        ],
      ),
    );
  }

  Future<void> _share(VetVisitCubit cubit) async {
    final file = await cubit.fileToShare(document);
    if (file == null) return;
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: document.mimeType)]));
  }
}

class _Card extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final List<Widget> children;

  const _Card({this.title, this.trailing, required this.children});

  @override
  Widget build(BuildContext context) {
    return RoundedBorderWidget(
      backgroundColor: AppColors.backgroundSurface,
      borderColor: AppColors.backgroundStroke,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(child: Text(title!, style: AppTextStyles.title03)),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Line({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTextStyles.text)),
        ],
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  final VoidCallback onRetry;

  const _Retry({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Les documents demandent une connexion internet.',
            style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Réessayer')),
      ],
    );
  }
}
