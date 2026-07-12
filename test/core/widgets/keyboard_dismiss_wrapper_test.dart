import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/keyboard_dismiss_wrapper.dart';

void main() {
  Widget buildApp(VoidCallback onPressed) {
    return MaterialApp(
      builder: (context, child) =>
          KeyboardDismissWrapper(child: child ?? const SizedBox.shrink()),
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('tap me'),
          ),
        ),
      ),
    );
  }

  testWidgets('lets the tap through the button when the keyboard is hidden',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(buildApp(() => taps++));

    await tester.tap(find.text('tap me'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('absorbs the first tap while the keyboard is visible',
      (tester) async {
    var taps = 0;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(buildApp(() => taps++));

    // The translucent barrier wins the gesture, so the button does not fire.
    await tester.tap(find.text('tap me'), warnIfMissed: false);
    await tester.pump();

    expect(taps, 0);
  });
}
