import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/onboarding/presentation/page/onboarding_page.dart';

Future<void> _loadGluten() async {
  final loader = FontLoader('Gluten')
    ..addFont(File('assets/fonts/Gluten-ExtraBold.ttf').readAsBytes().then((bytes) => bytes.buffer.asByteData()));
  await loader.load();
}

/// Text of the line holding the title's last character.
String _lastLine(String title, double maxWidth) {
  final painter = TextPainter(
    text: TextSpan(text: title, style: AppTextStyles.title02),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);
  final line = painter.getLineBoundary(TextPosition(offset: title.length - 1));
  return title.substring(line.start, line.end).trim();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadGluten);

  /// NAN-123: « rien ! » broke before the « ! » on a narrow screen.
  test('no slide title leaves its final punctuation alone on a line', () {
    for (var screen = 320.0; screen <= 440; screen++) {
      for (final title in OnboardingPage.slideTitles) {
        final last = _lastLine(title, screen - AppSpacing.lg * 2);
        expect(last.length, greaterThan(1), reason: '« $title » at $screen px ends with « $last »');
      }
    }
  });
}
