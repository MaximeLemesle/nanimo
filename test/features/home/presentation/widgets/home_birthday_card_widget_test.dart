import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/home/presentation/widgets/home_birthday_card_widget.dart';

void main() {
  late MemoryBirthdayCelebrationStore store;

  setUp(() => birthdayCelebrationStore = store = MemoryBirthdayCelebrationStore());
  tearDown(() => birthdayCelebrationStore = MemoryBirthdayCelebrationStore(celebrates: false));

  Widget card({VoidCallback? onAddMemory, int age = 3}) => MaterialApp(
        home: Scaffold(
          body: HomeBirthdayCardWidget(
            petId: 'p1',
            petName: 'Milo',
            age: age,
            portrait: null,
            now: DateTime(2026, 10, 22),
            onAddMemory: onAddMemory ?? () {},
          ),
        ),
      );

  testWidgets('wishes the birthday with the age', (tester) async {
    await tester.pumpWidget(card());
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Joyeux anniversaire'), findsOneWidget);
    expect(find.text('Milo\u00a0!'), findsOneWidget);
    expect(find.text('3 ans aujourd’hui !'), findsOneWidget);
    expect(HomeBirthdayCardWidget.ageLabel(1), '1 an aujourd’hui !');
  });

  testWidgets('the button adds a memory', (tester) async {
    var tapped = false;
    await tester.pumpWidget(card(onAddMemory: () => tapped = true));
    await tester.pump(const Duration(seconds: 5));

    await tester.tap(find.text('Ajouter un souvenir'));
    expect(tapped, isTrue);
  });

  testWidgets('the confetti fall once per pet and per year', (tester) async {
    await tester.pumpWidget(card());
    await tester.pump(const Duration(seconds: 5));
    expect(store.claimed, {'p1:2026'});
    expect(await store.claim('p1:2026'), isFalse);
  });
}
