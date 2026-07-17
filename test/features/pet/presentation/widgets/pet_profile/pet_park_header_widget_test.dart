import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_park_header_widget.dart';

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
  Widget build(List<PetModel> pets, {void Function(String)? onSelect}) {
    return MaterialApp(
      home: Scaffold(
        body: PetParkHeaderWidget(
          pets: pets,
          selectedPetId: pets.isEmpty ? null : pets.first.petId,

          /// Empty map: avatars fall back to a plain sized box, which keeps the
          /// test off the SVG asset bundle while preserving the layout width.
          iconsKey: const {},
          onSelect: onSelect ?? (_) {},
        ),
      ),
    );
  }

  Future<void> pumpAt(WidgetTester tester, Widget widget, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  testWidgets('scrolls horizontally', (tester) async {
    await pumpAt(tester, build([_pet('a'), _pet('b')]), const Size(390, 800));

    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(scrollView.scrollDirection, Axis.horizontal);
  });

  testWidgets('keeps a short list centred in the park', (tester) async {
    await pumpAt(tester, build([_pet('a')]), const Size(390, 800));

    final row = tester.getRect(find.byType(Row));
    final park = tester.getRect(find.byType(PetParkHeaderWidget));
    expect(row.center.dx, closeTo(park.center.dx, 0.5));
  });

  testWidgets('lays out every pet past the three that used to fit',
      (tester) async {
    await pumpAt(
      tester,
      build([for (var i = 0; i < 6; i++) _pet('$i')]),
      const Size(390, 800),
    );

    expect(
      find.descendant(
        of: find.byType(Row),
        matching: find.byType(GestureDetector),
      ),
      findsNWidgets(6),
    );
  });

  testWidgets('does not overflow with more pets than fit on screen',
      (tester) async {
    await pumpAt(
      tester,
      build([for (var i = 0; i < 6; i++) _pet('$i')]),
      const Size(390, 800),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('reports the tapped pet', (tester) async {
    String? selected;
    await pumpAt(
      tester,
      build([_pet('a'), _pet('b')], onSelect: (id) => selected = id),
      const Size(390, 800),
    );

    /// Invoked directly rather than tapped: with no icon key the avatar is an
    /// empty SizedBox, which paints nothing and so fails hit testing.
    final detectors = tester
        .widgetList<GestureDetector>(
          find.descendant(
            of: find.byType(Row),
            matching: find.byType(GestureDetector),
          ),
        )
        .toList();
    detectors.last.onTap!();
    expect(selected, 'b');
  });
}
