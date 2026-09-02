import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_notification_section_widget.dart';

class _MockSettingsCubit extends Mock implements SettingsCubit {}

/// Every pref stored as true: the section must still render them all off.
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

  Future<void> pumpSection(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: const Scaffold(
            body: SingleChildScrollView(
              child: SettingsNotificationSectionWidget(prefs: _allEnabled),
            ),
          ),
        ),
      ),
    );
  }

  List<CupertinoSwitch> switches(WidgetTester tester) =>
      tester.widgetList<CupertinoSwitch>(find.byType(CupertinoSwitch)).toList();

  testWidgets('renders the five switches off whatever the cached prefs say', (tester) async {
    await pumpSection(tester);

    expect(find.byType(CupertinoSwitch), findsNWidgets(5));
    expect(switches(tester).every((s) => s.value == false), isTrue);
  });

  testWidgets('flags the section as coming soon without hiding it', (tester) async {
    await pumpSection(tester);

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Bientôt'), findsOneWidget);
    expect(find.text('Notifications push'), findsOneWidget);
    expect(find.text('Vaccins'), findsOneWidget);
    expect(find.text('Visites vétérinaires'), findsOneWidget);
    expect(find.text('Vermifuges'), findsOneWidget);
    expect(find.text('Anniversaires'), findsOneWidget);
  });

  testWidgets('tapping any switch shows the message and leaves it off', (tester) async {
    await pumpSection(tester);

    for (var index = 0; index < 5; index++) {
      await tester.tap(find.byType(CupertinoSwitch).at(index));
      await tester.pump();

      expect(find.text(SettingsNotificationSectionWidget.comingSoonMessage), findsOneWidget);
      expect(switches(tester)[index].value, isFalse);

      await tester.pumpAndSettle(const Duration(seconds: 5));
    }
  });

  testWidgets('tapping a tile row also shows the message', (tester) async {
    await pumpSection(tester);

    await tester.tap(find.text('Vaccins'));
    await tester.pump();

    expect(find.text(SettingsNotificationSectionWidget.comingSoonMessage), findsOneWidget);
  });

  testWidgets('no tap ever writes the notification prefs', (tester) async {
    await pumpSection(tester);

    for (var index = 0; index < 5; index++) {
      await tester.tap(find.byType(CupertinoSwitch).at(index));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    verifyNever(() => settingsCubit.updateNotificationPrefs(any()));
  });

  testWidgets('the guard is on until the V2 wiring lands', (tester) async {
    expect(kNotificationsWired, isFalse);
  });
}
