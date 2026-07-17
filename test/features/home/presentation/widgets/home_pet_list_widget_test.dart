import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/home/presentation/widgets/home_pet_list_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

PetModel _pet(String id) => PetModel(
      petId: id,
      petName: 'Pet $id',
      birthdate: DateTime.utc(2022, 6, 15),
      gender: Gender.female,
      createdAt: DateTime.utc(2026, 6, 10),
      petRaceId: 'r1',
      petSpeciesId: 's1',
    );

void main() {
  /// Avatars are 80px wide with 32px gaps, so the viewport fits ~2 of them:
  /// 2 pets never overflow, 6 always do.
  const viewport = Size(240, 400);

  Widget build(List<PetModel> pets, {void Function(String)? onPetTap}) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: HomePetListWidget(
            pets: pets,
            iconsKey: const {},
            onPetTap: onPetTap,
          ),
        ),
      ),
    );
  }

  setUp(() => TestWidgetsFlutterBinding.ensureInitialized());

  Future<void> pumpAt(WidgetTester tester, Widget widget) async {
    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  testWidgets('renders one entry per pet', (tester) async {
    await pumpAt(tester, build([_pet('a'), _pet('b')]));

    expect(find.text('Pet a'), findsOneWidget);
    expect(find.text('Pet b'), findsOneWidget);
  });

  testWidgets('titles the section by pet count', (tester) async {
    await pumpAt(tester, build([_pet('a')]));
    expect(find.text('Mon Nanimo'), findsOneWidget);

    await pumpAt(tester, build([_pet('a'), _pet('b')]));
    expect(find.text('Mes Nanimo'), findsOneWidget);
  });

  testWidgets('peeks half of the overflowing avatar at the trailing edge',
      (tester) async {
    await pumpAt(
      tester,
      build([for (var i = 0; i < 6; i++) _pet('$i')]),
    );

    // One item (its GestureDetector) per pet, laid out in order.
    final items = find.byType(GestureDetector);
    expect(items, findsNWidgets(6));

    // Two avatars fit fully in the 240px viewport, so the third is cut at its
    // middle: its left edge sits exactly half an avatar (40px) from the edge.
    final peeking = tester.getTopLeft(items.at(2));
    expect(peeking.dx, moreOrLessEquals(viewport.width - 40, epsilon: 0.5));
  });

  testWidgets('lets the user scroll to the overflowed pets', (tester) async {
    await pumpAt(
      tester,
      build([for (var i = 0; i < 6; i++) _pet('$i')]),
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-1000, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pet 5'), findsOneWidget);
  });

  testWidgets('calls onPetTap with the tapped pet', (tester) async {
    String? tapped;
    await pumpAt(tester, build([_pet('a'), _pet('b')], onPetTap: (id) => tapped = id));

    await tester.tap(find.text('Pet b'));
    expect(tapped, 'b');
  });
}
