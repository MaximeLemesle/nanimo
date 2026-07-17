import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';

void main() {
  testWidgets('adds the device safe area to its bottom padding', (tester) async {
    const safeAreaBottom = 34.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            padding: EdgeInsets.only(bottom: safeAreaBottom),
            viewPadding: EdgeInsets.only(bottom: safeAreaBottom),
          ),
          child: Scaffold(
            body: BottomSheetWidget(
              title: 'Titre',
              children: [Text('Contenu')],
            ),
          ),
        ),
      ),
    );

    final padding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(BottomSheetWidget),
            matching: find.byType(Padding),
          )
          .first,
    );

    expect(
      padding.padding,
      const EdgeInsets.only(
        left: AppSpacing.lg,
        top: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.xxl,
      ),
    );
  });
}
