import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_menu_widget.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_widget.dart';

import '../../helpers/app_icon_finder.dart';

void main() {
  Future<void> pumpMenu(
    WidgetTester tester, {
    bool isAddPetPremiumLocked = false,
    VoidCallback? onAddPet,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomBarMenuWidget(
            isOpen: true,
            isAddPetPremiumLocked: isAddPetPremiumLocked,
            onAddWeight: () {},
            onAddEvent: () {},
            onAddPet: onAddPet ?? () {},
          ),
        ),
      ),
    );
  }

  group('BottomBarWidget', () {
    Future<void> pumpBar(
      WidgetTester tester, {
      int currentIndex = 0,
      bool isCreateMenuOpen = false,
      ValueChanged<int>? onTabSelected,
      VoidCallback? onCreateTap,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomBarWidget(
              currentIndex: currentIndex,
              isCreateMenuOpen: isCreateMenuOpen,
              onTabSelected: onTabSelected ?? (_) {},
              onCreateTap: onCreateTap ?? () {},
            ),
          ),
        ),
      );
    }

    testWidgets('shows the 3 tabs and the create button', (tester) async {
      await pumpBar(tester);

      expect(find.byType(AppIconWidget), findsExactly(3));
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('highlights only the selected tab with the blurred pill', (tester) async {
      await pumpBar(tester, currentIndex: 2);

      expect(find.byType(BackdropFilter), findsOneWidget);
      final selected =
          tester.widget<AppIconWidget>(findAppIcon(AppIcons.petPawSolid));
      final other =
          tester.widget<AppIconWidget>(findAppIcon(AppIcons.homeSolid));
      expect(selected.color, AppColors.textPrimary);
      expect(other.color, AppColors.textSecondary);
    });

    testWidgets('tab tap reports the index', (tester) async {
      int? tapped;
      await pumpBar(tester, onTabSelected: (i) => tapped = i);
      await tester.tap(findAppIcon(AppIcons.petPawSolid));
      expect(tapped, 2);
    });

    testWidgets('create button tap fires onCreateTap', (tester) async {
      var tapped = false;
      await pumpBar(tester, onCreateTap: () => tapped = true);

      await tester.tap(find.byIcon(Icons.add_rounded));
      expect(tapped, isTrue);
    });
  });

  group('AppCreateMenuWidget', () {
    Color labelColor(WidgetTester tester, String label) =>
        tester.widget<Text>(find.text(label)).style!.color!;

    Color tileColor(WidgetTester tester, String icon) {
      final container = tester.widget<Container>(
        find
            .ancestor(of: findAppIcon(icon), matching: find.byType(Container))
            .first,
      );
      return (container.decoration! as ShapeDecoration).color!;
    }

    testWidgets('shows the 3 actions and reports taps', (tester) async {
      var weight = false, event = false, pet = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottomBarMenuWidget(
              isOpen: true,
              onAddWeight: () => weight = true,
              onAddEvent: () => event = true,
              onAddPet: () => pet = true,
            ),
          ),
        ),
      );

      expect(find.text('Ajouter un nouveau poids'), findsOneWidget);
      expect(find.text('Ajouter un évènement'), findsOneWidget);
      expect(find.text('Ajouter un animal'), findsOneWidget);

      await tester.tap(find.text('Ajouter un nouveau poids'));
      await tester.tap(find.text('Ajouter un évènement'));
      await tester.tap(find.text('Ajouter un animal'));
      expect(weight && event && pet, isTrue);
    });

    testWidgets('ignores taps when closed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottomBarMenuWidget(
              isOpen: false,
              onAddWeight: () => tapped = true,
              onAddEvent: () => tapped = true,
              onAddPet: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(
        find.text('Ajouter un évènement'),
        warnIfMissed: false,
      );
      expect(tapped, isFalse);
    });

    testWidgets('unlocked, the pet row carries no crown and stays bright',
        (tester) async {
      await pumpMenu(tester);

      expect(findAppIcon(AppIcons.crown), findsNothing);
      expect(labelColor(tester, 'Ajouter un animal'), AppColors.textInvert);
      expect(tileColor(tester, AppIcons.petPawSolid2), AppColors.backgroundSurface);
    });

    testWidgets('locked, the pet row carries a crown and reads as disabled',
        (tester) async {
      await pumpMenu(tester, isAddPetPremiumLocked: true);

      expect(findAppIcon(AppIcons.crown), findsOneWidget);
      expect(
        tester.widget<AppIconWidget>(findAppIcon(AppIcons.crown)).color,
        AppColors.tertiary300,
      );
      expect(labelColor(tester, 'Ajouter un animal'), AppColors.textSecondary);
      expect(tileColor(tester, AppIcons.petPawSolid2), AppColors.textSecondary);
      expect(
        tester.widget<AppIconWidget>(findAppIcon(AppIcons.petPawSolid2)).color,
        AppColors.neutral50,
      );
    });

    /// NAN-059: the locked row is the conversion path, so it must still fire.
    testWidgets('locked, tapping the pet row still reports the tap',
        (tester) async {
      var pet = false;
      await pumpMenu(
        tester,
        isAddPetPremiumLocked: true,
        onAddPet: () => pet = true,
      );

      await tester.tap(find.text('Ajouter un animal'));
      expect(pet, isTrue);
    });

    testWidgets('locked, the two other rows keep their appearance',
        (tester) async {
      await pumpMenu(tester, isAddPetPremiumLocked: true);

      for (final label in ['Ajouter un nouveau poids', 'Ajouter un évènement']) {
        expect(labelColor(tester, label), AppColors.textInvert);
      }
      for (final icon in [AppIcons.addSquare, AppIcons.addCalendar]) {
        expect(tileColor(tester, icon), AppColors.backgroundSurface);
        expect(
          tester.widget<AppIconWidget>(findAppIcon(icon)).color,
          AppColors.textPrimary,
        );
      }
    });
  });
}
