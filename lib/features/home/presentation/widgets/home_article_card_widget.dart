import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

const String _title = 'La mue d’automne : le grand retour des poils partout';
const List<String> _paragraphs = [
  "Tu retrouves des poils sur le canapé, tes vêtements… et dans des endroits improbables ? Pas de panique : avec l’arrivée de l’automne, ton animal peut simplement être en pleine mue saisonnière.",
  "Chez le chien comme chez le chat, le pelage se renouvelle pour se préparer aux températures plus fraîches. Résultat : pendant quelques semaines, ça peut tomber beaucoup plus que d’habitude !",
  "Le bon réflexe ? Un petit coup de brosse régulier pour retirer les poils morts, éviter les nœuds et limiter l’invasion à la maison. Chez le chat, ça permet aussi qu’il avale moins de poils pendant sa toilette.",
  "Profites-en pour surveiller sa peau : rougeurs, démangeaisons ou zones sans poils doivent t’alerter.",
  "Sinon, rassure-toi : quelques poils partout, c’est aussi ça, l’automne avec nos animaux !",
];

class HomeArticleCardWidget extends StatelessWidget {
  const HomeArticleCardWidget({super.key});

  void _openArticle(BuildContext context) {
    BottomSheetWidget.show<void>(context, const _ArticleBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Le conseil de la semaine',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        RoundedBorderWidget(
          backgroundColor: AppColors.backgroundPrimary,
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () => _openArticle(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_title, style: AppTextStyles.title03),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _paragraphs.first,
                style: AppTextStyles.textSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Text(
                    'Lire la suite',
                    style: AppTextStyles.textSmallBold,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.arrow_forward,
                    size: AppSpacing.md,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArticleBottomSheet extends StatelessWidget {
  const _ArticleBottomSheet();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(_title, style: AppTextStyles.title02),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _paragraphs.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.md),
                      Text(_paragraphs[i], style: AppTextStyles.text),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
