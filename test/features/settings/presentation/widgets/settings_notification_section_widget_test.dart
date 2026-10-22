import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_notification_section_widget.dart';

import '../../../../core/notifications/fake_notification_client.dart';

class _MockSettingsCubit extends Mock implements SettingsCubit {}

const _allEnabled = NotificationPrefsModel();

void main() {
  late _MockSettingsCubit settingsCubit;

  setUpAll(() {
    registerFallbackValue(NotificationPrefsModel.defaults);
  });

  setUp(() {
    settingsCubit = _MockSettingsCubit();
    when(() => settingsCubit.state).thenReturn(const SettingsState());
    when(() => settingsCubit.stream).thenAnswer((_) => const Stream<SettingsState>.empty());
    when(() => settingsCubit.updateNotificationPrefs(any())).thenAnswer((_) async {});
  });

  Future<void> pumpSection(WidgetTester tester, {NotificationPrefsModel prefs = _allEnabled}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: Scaffold(
            body: SingleChildScrollView(
              child: SettingsNotificationSectionWidget(prefs: prefs),
            ),
          ),
        ),
      ),
    );
  }

  List<CupertinoSwitch> switches(WidgetTester tester) =>
      tester.widgetList<CupertinoSwitch>(find.byType(CupertinoSwitch)).toList();

  /// NAN-106: local reminders exist, the toggles drive them for real.
  testWidgets('shows the four live switches with the stored prefs', (tester) async {
    await pumpSection(tester);

    expect(find.text('Bientôt'), findsNothing);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Tous les rappels'), findsOneWidget);
    expect(find.text('Vaccins et vermifuges'), findsOneWidget);
    expect(find.text('Visites vétérinaires'), findsOneWidget);
    expect(find.text('Anniversaires'), findsOneWidget);
    expect(find.text('Vermifuges'), findsNothing);
    expect(switches(tester), hasLength(4));
    expect(switches(tester).every((s) => s.value), isTrue);
  });

  testWidgets('turning vaccines off writes the prefs', (tester) async {
    await pumpSection(tester);

    await tester.tap(find.byType(CupertinoSwitch).at(1));
    await tester.pump();

    final saved = verify(() => settingsCubit.updateNotificationPrefs(captureAny())).captured.single as NotificationPrefsModel;
    expect(saved.vaccineReminders, isFalse);
    expect(saved.pushEnabled, isTrue);
  });

  testWidgets('with notifications off, the detail switches are locked', (tester) async {
    await pumpSection(tester, prefs: _allEnabled.copyWith(pushEnabled: false));

    expect(switches(tester).skip(1).every((s) => s.onChanged == null), isTrue);
  });

  group('blocked by the system', () {
    late NotificationPriming previous;
    late FakeNotificationClient client;
    late MemoryPrimingStore store;

    setUp(() {
      previous = notificationPriming;
      client = FakeNotificationClient();
      store = MemoryPrimingStore();
      notificationPriming = NotificationPriming(client: () => client, store: store);
    });

    tearDown(() => notificationPriming = previous);

    testWidgets('after a refusal, offers the way to the phone settings', (tester) async {
      store.shown = true;
      await pumpSection(tester);
      await tester.pumpAndSettle();

      expect(find.text('Notifications bloquées sur ce téléphone'), findsOneWidget);
      await tester.tap(find.text('Ouvrir les réglages du téléphone'));
      expect(client.openSettingsCount, 1);
    });

    testWidgets('never asked, or granted: no such line', (tester) async {
      await pumpSection(tester);
      await tester.pumpAndSettle();
      expect(find.text('Notifications bloquées sur ce téléphone'), findsNothing);

      client.granted = true;
      store.shown = true;
      await pumpSection(tester);
      await tester.pumpAndSettle();
      expect(find.text('Notifications bloquées sur ce téléphone'), findsNothing);
    });
  });
}
