import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/onboarding/presentation/page/onboarding_page.dart';

/// iPhone SE width, minus the page padding, the icon and its gap.
const double _benefitLine = 375 - AppSpacing.xl * 2 - 24 - AppSpacing.md;

Future<void> _loadGeologica() async {
  final loader = FontLoader('Geologica');
  for (final path in const [
    'assets/fonts/Geologica-Light.ttf',
    'assets/fonts/Geologica-Regular.ttf',
    'assets/fonts/Geologica-Medium.ttf',
  ]) {
    loader.addFont(File(path).readAsBytes().then((bytes) => bytes.buffer.asByteData()));
  }
  await loader.load();
}

void main() {
  setUpAll(_loadGeologica);

  testWidgets('lists the three benefits, health first', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));

    final labels = OnboardingPage.benefits.map((b) => b.label).toList();
    expect(labels.first, 'Ne rate plus un rappel de vaccin');
    for (final label in labels) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Commencer'), findsOneWidget);
    expect(find.text('J\'ai déjà un compte'), findsOneWidget);
  });

  testWidgets('fits an iPhone SE without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));

    expect(tester.takeException(), isNull);
  });

  test('each benefit holds on one line on an iPhone SE', () {
    for (final benefit in OnboardingPage.benefits) {
      final painter = TextPainter(
        text: TextSpan(text: benefit.label, style: AppTextStyles.text),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: _benefitLine);
      expect(painter.computeLineMetrics().length, 1, reason: benefit.label);
    }
  });
}
