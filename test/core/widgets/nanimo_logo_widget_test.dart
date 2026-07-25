import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/nanimo_logo_widget.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows the wordmark alone by default', (tester) async {
    await tester.pumpWidget(host(const NanimoLogoWidget()));

    expect(find.text('nanimo'), findsOneWidget);
    expect(find.text('Chaque moment compte'), findsNothing);
  });

  testWidgets('adds the tagline on request', (tester) async {
    await tester.pumpWidget(host(const NanimoLogoWidget(showTagline: true)));

    expect(find.text('nanimo'), findsOneWidget);
    expect(find.text('Chaque moment compte'), findsOneWidget);
  });

  testWidgets('sets the wordmark in Gluten at both sizes', (tester) async {
    await tester.pumpWidget(host(const NanimoLogoWidget()));
    final small = tester.widget<Text>(find.text('nanimo')).style!;

    await tester.pumpWidget(
      host(const NanimoLogoWidget(size: NanimoLogoSize.large)),
    );
    final large = tester.widget<Text>(find.text('nanimo')).style!;

    expect(small.fontFamily, 'Gluten');
    expect(large.fontFamily, 'Gluten');
    expect(large.fontSize, greaterThan(small.fontSize!));
  });

  /// The footer used to inline these two Texts; extracting them must not have
  /// changed what it renders.
  testWidgets('keeps the styles the settings footer used to inline',
      (tester) async {
    await tester.pumpWidget(host(const NanimoLogoWidget(showTagline: true)));

    final wordmark = tester.widget<Text>(find.text('nanimo')).style!;
    final tagline =
        tester.widget<Text>(find.text('Chaque moment compte')).style!;

    expect(wordmark.fontSize, AppTextStyles.title02.fontSize);
    expect(wordmark.fontWeight, AppTextStyles.title02.fontWeight);
    expect(tagline.fontSize, AppTextStyles.textLabel.fontSize);
    expect(tagline.fontStyle, AppTextStyles.textLabel.fontStyle);
  });
}
