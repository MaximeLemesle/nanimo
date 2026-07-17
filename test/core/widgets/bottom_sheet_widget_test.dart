import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';

void main() {
  Widget host({double keyboardInset = 0}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          viewInsets: EdgeInsets.only(bottom: keyboardInset),
        ),
        /// No Scaffold: it strips the bottom viewInsets from its body.
        child: const Material(
          child: BottomSheetWidget(
            title: 'Que voulez-vous faire ?',
            children: [Text('Prendre une photo')],
          ),
        ),
      ),
    );
  }

  EdgeInsets paddingOf(WidgetTester tester) {
    final padding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(BottomSheetWidget),
            matching: find.byType(Padding),
          )
          .first,
    );
    return padding.padding as EdgeInsets;
  }

  testWidgets('clears the nav bar when the keyboard is closed', (tester) async {
    await tester.pumpWidget(host());

    expect(paddingOf(tester).bottom, AppSpacing.bottomBarInset);
  });

  testWidgets('sits above the keyboard when it is open', (tester) async {
    await tester.pumpWidget(host(keyboardInset: 300));

    /// The keyboard covers the nav bar, so the two insets must not stack.
    expect(paddingOf(tester).bottom, 300 + AppSpacing.lg);
  });

  testWidgets('renders the title and the children', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('Que voulez-vous faire ?'), findsOneWidget);
    expect(find.text('Prendre une photo'), findsOneWidget);
  });

  group('bottomInsetFor', () {
    testWidgets('returns the nav bar inset with no keyboard', (tester) async {
      late double inset;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Builder(
            builder: (context) {
              inset = bottomInsetFor(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(inset, AppSpacing.bottomBarInset);
    });
  });
}
