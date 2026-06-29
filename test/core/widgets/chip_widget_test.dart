import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';

void main() {
  Widget build({
    bool isActivated = false,
    IconData? leadingIcon,
    IconData? trailingIcon,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ChipWidget(
          label: 'Filtres',
          isSelected: isActivated,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          onTap: onTap,
        ),
      ),
    );
  }

  testWidgets('renders the label and both icons', (tester) async {
    await tester.pumpWidget(
      build(leadingIcon: Icons.tune, trailingIcon: Icons.close),
    );

    expect(find.text('Filtres'), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('turns primary when activated', (tester) async {
    await tester.pumpWidget(build(isActivated: true));

    final material = tester.widget<Material>(
      find
          .descendant(
              of: find.byType(ChipWidget), matching: find.byType(Material))
          .first,
    );
    expect(material.color, AppColors.primary);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(build(onTap: () => tapped = true));

    await tester.tap(find.byType(ChipWidget));
    expect(tapped, isTrue);
  });
}
