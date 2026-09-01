import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/page/settings_page.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

class _MockSettingsCubit extends Mock implements SettingsCubit {}

class _MockAuthCubit extends Mock implements AuthCubit {}

const _user = UserModel(
  userId: 'user-1',
  userName: 'Maxime',
  mail: 'max@example.com',
  subscriptionStatus: SubscriptionStatus.freemium,
);

const _loadedState = SettingsState(
  status: SettingsStatus.loaded,
  user: _user,
);

void main() {
  late _MockSettingsCubit settingsCubit;
  late _MockAuthCubit authCubit;
  late StreamController<SettingsState> settingsStates;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(NotificationPrefsModel.defaults);
    PackageInfo.setMockInitialValues(
      appName: 'nanimo',
      packageName: 'com.nanimo.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() {
    settingsCubit = _MockSettingsCubit();
    authCubit = _MockAuthCubit();
    settingsStates = StreamController<SettingsState>.broadcast();

    when(() => settingsCubit.state).thenReturn(_loadedState);
    when(() => settingsCubit.stream).thenAnswer((_) => settingsStates.stream);
    when(() => settingsCubit.restorePurchases()).thenAnswer((_) async {});
    when(() => settingsCubit.clearError()).thenReturn(null);
    when(() => settingsCubit.clearRestoreResult()).thenReturn(null);
    when(() => settingsCubit.updateNotificationPrefs(any())).thenAnswer((_) async {});
    when(() => settingsCubit.deleteAccount()).thenAnswer((_) async {});
    when(() => authCubit.state).thenReturn(const AuthState.authenticated());
    when(() => authCubit.stream).thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => authCubit.logout()).thenAnswer((_) async {});
  });

  tearDown(() => settingsStates.close());

  Future<void> pumpPage(WidgetTester tester) async {
    /// Tall surface so the lazy ListView builds every section
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SettingsCubit>.value(value: settingsCubit),
            BlocProvider<AuthCubit>.value(value: authCubit),
          ],
          child: const SettingsPage(),
        ),
      ),
    );

    /// Flush the async PackageInfo read so the footer shows the version
    await tester.pumpAndSettle();
  }

  testWidgets('renders every section with the user info', (tester) async {
    await pumpPage(tester);

    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Mon compte'), findsOneWidget);
    expect(find.text('Prénom'), findsOneWidget);
    expect(find.text('Maxime'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('max@example.com'), findsOneWidget);
    expect(find.text('Abonnement'), findsOneWidget);
    expect(find.text('Freemium'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byType(CupertinoSwitch), findsNWidgets(5));
    expect(find.text('Se déconnecter'), findsOneWidget);
    expect(find.text('Supprimer mon compte'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
  });

  testWidgets('shows the premium badge for a premium user', (tester) async {
    when(() => settingsCubit.state).thenReturn(
      SettingsState(
        status: SettingsStatus.loaded,
        user: UserModel(
          userId: _user.userId,
          userName: _user.userName,
          mail: _user.mail,
          subscriptionStatus: SubscriptionStatus.premium,
          subscriptionExpiresAt: DateTime(2026, 12, 31),
        ),
      ),
    );
    await pumpPage(tester);

    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Jusqu\'au 31/12/2026'), findsOneWidget);
  });

  testWidgets('toggling a switch saves the matching pref', (tester) async {
    await pumpPage(tester);

    /// Second switch is the vaccine reminders one
    await tester.tap(find.byType(CupertinoSwitch).at(1));
    await tester.pump();

    verify(() => settingsCubit.updateNotificationPrefs(
          const NotificationPrefsModel(vaccineReminders: false),
        )).called(1);
  });

  testWidgets('logout button calls AuthCubit.logout', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Se déconnecter'));
    await tester.pump();

    verify(() => authCubit.logout()).called(1);
  });

  testWidgets('account deletion asks for confirmation first', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Supprimer mon compte'));
    await tester.pumpAndSettle();

    expect(find.text('Supprimer votre compte ?'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    verifyNever(() => settingsCubit.deleteAccount());
  });

  testWidgets('confirming the dialog deletes the account', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Supprimer mon compte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    verify(() => settingsCubit.deleteAccount()).called(1);
  });

  testWidgets('the restore tile is offered whatever the plan', (tester) async {
    await pumpPage(tester);

    expect(find.text('Restaurer mes achats'), findsOneWidget);
    expect(find.text('Gérer mon abonnement'), findsNothing);

    await tester.tap(find.text('Restaurer mes achats'));
    await tester.pump();

    verify(() => settingsCubit.restorePurchases()).called(1);
  });

  testWidgets('a restore outcome is reported in a snackbar', (tester) async {
    await pumpPage(tester);

    const restored = SettingsState(
      status: SettingsStatus.loaded,
      user: _user,
      restoreResult: RestoreResult(
        RestoreOutcome.nothingFound,
        SubscriptionRestorer.nothingFoundMessage,
      ),
    );
    when(() => settingsCubit.state).thenReturn(restored);
    settingsStates.add(restored);
    await tester.pump();
    await tester.pump();

    expect(
      find.text(SubscriptionRestorer.nothingFoundMessage),
      findsOneWidget,
    );
    verify(() => settingsCubit.clearRestoreResult()).called(1);
  });

  testWidgets('tapping the name tile opens the edit bottom sheet', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Prénom'));
    await tester.pumpAndSettle();

    expect(find.text('Modifier mon prénom'), findsOneWidget);
    expect(find.text('Enregistrer'), findsOneWidget);
  });
}
