import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/pet_select_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import '../../../../helpers/app_icon_finder.dart';

import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:go_router/go_router.dart';

final _milo = PetModel(
  petId: 'pet-milo',
  petName: 'Milo',
  birthdate: DateTime(2022, 5, 1),
  gender: Gender.male,
  createdAt: DateTime(2022, 5, 1),
  petRaceId: 'r',
  petSpeciesId: 's-cat',
);

final _rex = PetModel(
  petId: 'pet-rex',
  petName: 'Rex',
  birthdate: DateTime(2021, 1, 1),
  gender: Gender.male,
  createdAt: DateTime(2021, 1, 1),
  petRaceId: 'r2',
  petSpeciesId: 's-dog',
);

void main() {
  Widget harness(Future<void> Function(BuildContext) onTap) => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => onTap(context),
              child: const Text('open'),
            ),
          ),
        ),
      );

  testWidgets('disables validation until a pet is picked, then returns it',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    List<String>? result;
    await tester.pumpWidget(harness((context) async {
      result = await PetSelectBottomSheetWidget.show(
        context,
        pets: [_milo, _rex],
        selectedPetIds: const [],
        portraits: const {
          'pet-milo': PetPortrait.species('cat-europeen'),
          'pet-rex': PetPortrait.species('dog-border_collie'),
        },
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir au moins un animal'), findsOneWidget);
    expect(
      find.text('Sélectionnez au moins un animal pour ce souvenir.'),
      findsOneWidget,
    );

    // Validate is disabled: tapping it should not close the sheet.
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(find.text('Choisir au moins un animal'), findsOneWidget);

    await tester.tap(find.text('Milo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    expect(result, ['pet-milo']);
  });

  testWidgets('deselects a pet when tapped twice', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    List<String>? result;
    await tester.pumpWidget(harness((context) async {
      result = await PetSelectBottomSheetWidget.show(
        context,
        pets: [_milo],
        selectedPetIds: const ['pet-milo'],
        portraits: const {
          'pet-milo': PetPortrait.species('cat-europeen'),
          'pet-rex': PetPortrait.species('dog-border_collie'),
        },
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Pre-selected: tap once to remove, validation becomes disabled again.
    await tester.tap(find.text('Milo'));
    await tester.pumpAndSettle();
    expect(
      find.text('Sélectionnez au moins un animal pour ce souvenir.'),
      findsOneWidget,
    );
    expect(result, isNull);
  });

  testWidgets('shows an empty message when there is no pet', (tester) async {
    await tester.pumpWidget(harness((context) async {
      await PetSelectBottomSheetWidget.show(
        context,
        pets: const [],
        selectedPetIds: const [],
        portraits: const {},
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Aucun animal disponible.'), findsOneWidget);
  });

  // NAN-082: such an animal can be read, not attached to a new souvenir.
  group('a pet the plan no longer covers', () {
    Widget lockedHarness(Future<void> Function(BuildContext) onTap) => MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => Scaffold(
                  body: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () => onTap(context),
                      child: const Text('open'),
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: RouteNames.paywall,
                builder: (_, __) => const Scaffold(body: Text('paywall-stub')),
              ),
            ],
          ),
        );

    Future<List<String>?> openSheet(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      List<String>? result;
      await tester.pumpWidget(lockedHarness((context) async {
        result = await PetSelectBottomSheetWidget.show(
          context,
          pets: [_milo, _rex],
          selectedPetIds: const [],
          portraits: const {},
          lockedPetIds: const {'pet-rex'},
        );
      }));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('is shown, crowned, and still listed', (tester) async {
      await openSheet(tester);

      expect(find.text('Rex'), findsOneWidget);
      expect(findAppIcon(AppIcons.crown), findsOneWidget);
    });

    testWidgets('cannot be selected, and opens the paywall', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Rex'));
      await tester.pumpAndSettle();

      expect(find.text('paywall-stub'), findsOneWidget);
    });

    testWidgets('leaves the covered animal selectable', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Milo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Valider'));
      await tester.pumpAndSettle();

      expect(find.text('paywall-stub'), findsNothing);
    });
  });
}
