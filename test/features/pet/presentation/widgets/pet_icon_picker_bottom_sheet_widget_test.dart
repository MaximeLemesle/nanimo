import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_icon_picker_bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

import '../../../../helpers/app_icon_finder.dart';

/// [assetPath] points at an asset the app really ships: the test bundle serves
/// the pubspec assets, so a made-up path would fail to decode.
PetIconModel buildIcon(
  String id, {
  required String name,
  String assetPath = 'assets/icons/species/dog.png',
  bool isPremium = false,
}) {
  return PetIconModel(
    petIconId: id,
    petIconName: name,
    assetPath: assetPath,
    isPremium: isPremium,
    petSpeciesId: 'sp-dog',
  );
}

SubscriptionState plan(String planName) =>
    SubscriptionState.loaded(SubscriptionConfigModel(
      configId: 'cfg',
      planName: planName,
      maxImagesPerEvent: 1,
      maxPets: 1,
    ));

void main() {
  final icons = [
    buildIcon('collie', name: 'Collie'),
    buildIcon('husky',
        name: 'Husky',
        assetPath: 'assets/icons/species/cat.png',
        isPremium: true),
  ];

  late List<String?> selections;

  Future<void> pumpSheet(
    WidgetTester tester,
    SubscriptionState subscription, {
    String? selectedPetIconId,
    List<PetIconModel>? catalogue,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    selections = [];
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => PetIconPickerBottomSheetWidget.show(
                  context,
                  speciesIconKey: 'dog',
                  icons: catalogue ?? icons,
                  selectedPetIconId: selectedPetIconId,
                  subscription: subscription,
                  onSelected: selections.add,
                ),
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
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('lists the default tile and every icon of the species',
      (tester) async {
    await pumpSheet(tester, plan('free'));

    expect(find.text(petIconPickerTitle), findsOneWidget);
    expect(find.text('Par défaut'), findsOneWidget);
    expect(find.text('Collie'), findsOneWidget);
    expect(find.text('Husky'), findsOneWidget);
  });

  testWidgets('picking a free icon reports it and closes the sheet',
      (tester) async {
    await pumpSheet(tester, plan('free'));

    await tester.tap(find.text('Collie'));
    await tester.pumpAndSettle();

    expect(selections, ['collie']);
    expect(find.text(petIconPickerTitle), findsNothing);
  });

  testWidgets('the default tile clears the choice', (tester) async {
    await pumpSheet(tester, plan('free'), selectedPetIconId: 'collie');

    await tester.tap(find.text('Par défaut'));
    await tester.pumpAndSettle();

    expect(selections, [null]);
  });

  testWidgets('a premium icon is crowned for a free account', (tester) async {
    await pumpSheet(tester, plan('free'));

    expect(findAppIcon(AppIcons.crown), findsOneWidget);
  });

  testWidgets('a premium icon opens the paywall instead of being picked',
      (tester) async {
    await pumpSheet(tester, plan('free'));

    await tester.tap(find.text('Husky'));
    await tester.pumpAndSettle();

    expect(selections, isEmpty);
    expect(find.text('paywall-stub'), findsOneWidget);
  });

  testWidgets('a subscriber sees no crown and picks the premium icon',
      (tester) async {
    await pumpSheet(tester, plan('premium'));

    expect(findAppIcon(AppIcons.crown), findsNothing);

    await tester.tap(find.text('Husky'));
    await tester.pumpAndSettle();

    expect(selections, ['husky']);
    expect(find.text('paywall-stub'), findsNothing);
  });

  /// Plan unknown: nothing is capped, so no paywall is pushed.
  testWidgets('an unloaded plan shows the message instead of the paywall',
      (tester) async {
    await pumpSheet(tester, const SubscriptionState.unknown());

    expect(findAppIcon(AppIcons.crown), findsOneWidget);

    await tester.tap(find.text('Husky'));
    await tester.pumpAndSettle();

    expect(selections, isEmpty);
    expect(find.text('paywall-stub'), findsNothing);
    expect(find.text(subscriptionUnavailableMessage), findsOneWidget);
  });

  testWidgets('an empty catalogue explains itself', (tester) async {
    await pumpSheet(tester, plan('free'), catalogue: const []);

    expect(find.text(petIconPickerEmpty), findsOneWidget);
  });
}
