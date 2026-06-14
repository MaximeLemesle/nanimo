import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/error_banner_widget.dart';

void main() {
  testWidgets('renders the provided message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ErrorBannerWidget(message: 'Identifiants invalides'),
        ),
      ),
    );

    expect(find.text('Identifiants invalides'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
