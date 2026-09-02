import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';

/// iPhone SE, the narrowest screen the app supports, minus the horizontal
/// padding of the paywall.
const double _narrowestLine = 375 - AppSpacing.lg * 2;

Future<void> _loadGeologica() async {
  final loader = FontLoader('Geologica');
  for (final path in const [
    'assets/fonts/Geologica-Light.ttf',
    'assets/fonts/Geologica-Medium.ttf',
  ]) {
    loader.addFont(
      File(path).readAsBytes().then((bytes) => bytes.buffer.asByteData()),
    );
  }
  await loader.load();
}

int _lineCount(InlineSpan span) {
  final painter = TextPainter(text: span, textDirection: TextDirection.ltr)
    ..layout(maxWidth: _narrowestLine);
  return painter.computeLineMetrics().length;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadGeologica);

  /// The benefits are rendered as a single Text.rich with a leading dash, so a
  /// wrapped line indents under the dash and reads as a second level.
  test('every benefit holds on one line on the narrowest screen', () {
    for (final benefit in paywallBenefits) {
      final span = TextSpan(
        text: '- ${benefit.subtitle} ',
        style: AppTextStyles.text,
        children: [
          TextSpan(text: benefit.title, style: AppTextStyles.textBold),
        ],
      );

      expect(
        _lineCount(span),
        1,
        reason: '"${benefit.subtitle} ${benefit.title}" wraps',
      );
    }
  });

  test('the tagline holds on one line on the narrowest screen', () {
    final span = TextSpan(text: paywallTagline, style: AppTextStyles.text);

    expect(_lineCount(span), 1, reason: '"$paywallTagline" wraps');
  });
}
