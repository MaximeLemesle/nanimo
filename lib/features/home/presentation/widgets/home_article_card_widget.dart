import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

const String _title = 'Canicule : protégez votre animal';
const String _excerpt = "Fortes chaleurs en vue. Gamelle d'eau fraîche à volonté, coins d'ombre "
    'et sorties tôt le matin ou tard le soir : les bons réflexes pour un '
    'été serein.';
const List<String> _paragraphs = [
  "L'été s'installe et, avec lui, les fortes chaleurs. Nos compagnons ne "
      'transpirent presque pas : ils régulent leur température en haletant, '
      'ce qui les rend particulièrement vulnérables aux coups de chaleur.',
  "Laissez toujours plusieurs gamelles d'eau fraîche à disposition et "
      'renouvelez-les souvent. À la maison, fermez volets et rideaux aux '
      "heures chaudes et réservez-lui un coin à l'ombre.",
  'Décalez les balades tôt le matin ou tard le soir. En pleine journée, le '
      'bitume peut dépasser 50 °C et brûler les coussinets : posez le dos de '
      'votre main au sol, si vous ne tenez pas 5 secondes, ne sortez pas.',
  "Ne laissez jamais un animal seul dans une voiture, même à l'ombre, même "
      "quelques minutes : l'habitacle devient un four en un rien de temps.",
  'Halètement excessif, salivation, abattement, gencives très rouges… Au '
      "moindre signe de coup de chaleur, mouillez votre animal à l'eau "
      'tempérée et contactez immédiatement un vétérinaire.',
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
                _excerpt,
                style: AppTextStyles.textSmall,
                maxLines: 3,
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
