import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';

void main() {
  testWidgets('renders the streamline asset at the given size and color', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppIconWidget(
            AppIcons.openBookSolid,
            size: 32,
            color: AppColors.primary,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.width, 32);
    expect(svg.height, 32);
    expect(
      svg.colorFilter,
      const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
    );
    expect(tester.takeException(), isNull);
  });
}
