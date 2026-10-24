import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';

/// Terms, privacy and, once an account exists, the restore that guideline
/// 3.1.1 asks for, on one line under the offer.
class PaywallLegalLinksWidget extends StatelessWidget {
  final Future<bool> Function(Uri url)? onOpen;
  final VoidCallback? onRestore;

  const PaywallLegalLinksWidget({super.key, this.onOpen, this.onRestore});

  @override
  Widget build(BuildContext context) {
    final separator = Text(
      '  ·  ',
      style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _link('Conditions', () => _open(context, termsUrl)),
        separator,
        _link('Confidentialité', () => _open(context, privacyUrl)),
        if (onRestore != null) ...[separator, _link('Restaurer', onRestore!)],
      ],
    );
  }

  Widget _link(String label, VoidCallback onTap) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          // Keeps the tap target reachable without pushing the links apart.
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.textSmall.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final open = onOpen ??
        (Uri target) => launchUrl(target, mode: LaunchMode.externalApplication);

    bool opened;
    try {
      opened = await open(uri);
    } catch (e, st) {
      developer.log('could not open $url', name: 'paywall', error: e, stackTrace: st);
      opened = false;
    }

    if (opened || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir la page pour le moment.')),
      );
  }
}
