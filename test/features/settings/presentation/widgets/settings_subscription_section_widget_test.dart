import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_subscription_section_widget.dart';

class _MockSettingsCubit extends Mock implements SettingsCubit {}

UserModel _user(SubscriptionStatus status, {DateTime? expiresAt}) => UserModel(
      userId: 'user-1',
      userName: 'Maxime',
      mail: 'max@example.com',
      subscriptionStatus: status,
      subscriptionExpiresAt: expiresAt,
    );

void main() {
  late _MockSettingsCubit cubit;

  setUp(() {
    cubit = _MockSettingsCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream<SettingsState>.empty());
    when(() => cubit.restorePurchases()).thenAnswer((_) async {});
  });

  Future<void> pumpSection(
    WidgetTester tester,
    SettingsState state, {
    Future<bool> Function(Uri url)? onOpenStore,
    TargetPlatform platform = TargetPlatform.iOS,
  }) async {
    when(() => cubit.state).thenReturn(state);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: SingleChildScrollView(
              child: SettingsSubscriptionSectionWidget(
                state: state,
                onOpenStore: onOpenStore,
              ),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.paywall,
          builder: (_, __) => const Scaffold(body: Text('paywall')),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<SettingsCubit>.value(
        value: cubit,
        child: MaterialApp.router(
          theme: ThemeData(platform: platform),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('freemium shows the badge, the upgrade CTA and the restore tile',
      (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.freemium),
      ),
    );

    expect(find.text('Freemium'), findsOneWidget);
    expect(find.text('Gratuite'), findsOneWidget);
    expect(find.text('Passer premium'), findsOneWidget);
    expect(find.text('Restaurer mes achats'), findsOneWidget);
    expect(find.text('Gérer mon abonnement'), findsNothing);
  });

  testWidgets('premium shows the expiry, the manage tile and no upgrade CTA',
      (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(
          SubscriptionStatus.premium,
          expiresAt: DateTime(2026, 12, 31),
        ),
      ),
    );

    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Jusqu\'au 31/12/2026'), findsOneWidget);
    expect(find.text('Gérer mon abonnement'), findsOneWidget);
    expect(find.text('Restaurer mes achats'), findsOneWidget);
    expect(find.text('Passer premium'), findsNothing);
  });

  testWidgets('a premium plan without an expiry date reads as active',
      (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.premium),
      ),
    );

    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('an unloaded subscription offers neither upgrade nor management',
      (tester) async {
    await pumpSection(tester, const SettingsState(status: SettingsStatus.loaded));

    expect(find.text('Passer premium'), findsNothing);
    expect(find.text('Gérer mon abonnement'), findsNothing);
    expect(find.text('Restaurer mes achats'), findsOneWidget);
    expect(find.text('Gratuite'), findsOneWidget);
  });

  testWidgets('tapping restore delegates to the cubit', (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.freemium),
      ),
    );

    await tester.tap(find.text('Restaurer mes achats'));
    await tester.pump();

    verify(() => cubit.restorePurchases()).called(1);
  });

  testWidgets('a running restore shows a spinner and ignores taps',
      (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.freemium),
        isRestoring: true,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.text('Restaurer mes achats'));
    await tester.pump();

    verifyNever(() => cubit.restorePurchases());
  });

  testWidgets('the upgrade CTA pushes the paywall', (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.freemium),
      ),
    );

    await tester.tap(find.text('Passer premium'));
    await tester.pumpAndSettle();

    expect(find.text('paywall'), findsOneWidget);
  });

  testWidgets('managing on iOS opens the App Store subscriptions page',
      (tester) async {
    final opened = <Uri>[];
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.premium),
      ),
      onOpenStore: (uri) async {
        opened.add(uri);
        return true;
      },
    );

    await tester.tap(find.text('Gérer mon abonnement'));
    await tester.pumpAndSettle();

    expect(opened, [Uri.parse(appStoreSubscriptionsUrl)]);
  });

  testWidgets('managing on Android opens the Play Store subscriptions page',
      (tester) async {
    final opened = <Uri>[];
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.premium),
      ),
      onOpenStore: (uri) async {
        opened.add(uri);
        return true;
      },
      platform: TargetPlatform.android,
    );

    await tester.tap(find.text('Gérer mon abonnement'));
    await tester.pumpAndSettle();

    expect(opened, [Uri.parse(playStoreSubscriptionsUrl)]);
  });

  testWidgets('a store that will not open surfaces a snackbar', (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.premium),
      ),
      onOpenStore: (_) async => false,
    );

    await tester.tap(find.text('Gérer mon abonnement'));
    await tester.pumpAndSettle();

    expect(
      find.text('Impossible d’ouvrir les réglages d’abonnement.'),
      findsOneWidget,
    );
  });

  testWidgets('a launcher that throws surfaces the same snackbar',
      (tester) async {
    await pumpSection(
      tester,
      SettingsState(
        status: SettingsStatus.loaded,
        user: _user(SubscriptionStatus.premium),
      ),
      onOpenStore: (_) async => throw Exception('no launcher'),
    );

    await tester.tap(find.text('Gérer mon abonnement'));
    await tester.pumpAndSettle();

    expect(
      find.text('Impossible d’ouvrir les réglages d’abonnement.'),
      findsOneWidget,
    );
  });
}
