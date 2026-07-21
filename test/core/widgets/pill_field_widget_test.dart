import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/pill_field_widget.dart';

void main() {
  Widget build({VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: PillFieldWidget(
          semanticLabel: 'Date',
          onTap: onTap ?? () {},
          child: const Text('17/07/2026'),
        ),
      ),
    );
  }

  testWidgets('renders the value', (tester) async {
    await tester.pumpWidget(build());

    expect(find.text('17/07/2026'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(build(onTap: () => tapped = true));

    await tester.tap(find.byType(PillFieldWidget));
    expect(tapped, isTrue);
  });

  testWidgets('exposes itself as a labelled button to screen readers',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(build());

    final semantics = tester.getSemantics(find.byType(PillFieldWidget));
    final data = semantics.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(semantics.label, contains('Date'));

    handle.dispose();
  });
}
