import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Mirrors the page: the tap reports upward and comes back as a new selection.
class _Harness extends StatefulWidget {
  final List<PetModel> pets;

  const _Harness({required this.pets});

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late String _selectedPetId = widget.pets.first.petId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PetParkHeaderWidget(
          pets: widget.pets,
          selectedPetId: _selectedPetId,

          /// Empty map: avatars fall back to a plain sized box, which keeps the
          /// test off the asset bundle while preserving the layout width.
          portraits: const {},
          onSelect: (id) => setState(() => _selectedPetId = id),
        ),
      ),
    );
  }
}

void main() {
  Widget build(List<PetModel> pets, {void Function(String)? onSelect}) {
    return MaterialApp(
      home: Scaffold(
        body: PetParkHeaderWidget(
          pets: pets,
          selectedPetId: pets.isEmpty ? null : pets.first.petId,

          /// Empty map: avatars fall back to a plain sized box, which keeps the
          /// test off the asset bundle while preserving the layout width.
          portraits: const {},
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

  Iterable<GestureDetector> avatars(WidgetTester tester) {
    return tester.widgetList<GestureDetector>(find.descendant(
      of: find.byType(Row),
      matching: find.byType(GestureDetector),
    ));
  }

  Rect avatarRect(WidgetTester tester, int index) {
    return tester.getRect(find
        .descendant(
          of: find.byType(Row),
          matching: find.byType(GestureDetector),
        )
        .at(index));
  }

  group('centring the selection', () {
    testWidgets('opens on the selected pet already in the middle',
        (tester) async {
      await pumpAt(
        tester,
        _Harness(pets: [for (var i = 0; i < 6; i++) _pet('$i')]),
        const Size(390, 800),
      );

      expect(avatarRect(tester, 0).center.dx, closeTo(195, 0.5));
    });

    /// The first pet must land centred on the padding alone, without the strip
    /// having to scroll: an avatar has no width until its picture is decoded,
    /// and a strip that resizes afterwards never comes back to the middle.
    testWidgets('centres the first pet without scrolling', (tester) async {
      await pumpAt(
        tester,
        _Harness(pets: [for (var i = 0; i < 6; i++) _pet('$i')]),
        const Size(390, 800),
      );

      final scrollable = tester.widget<Scrollable>(find.byType(Scrollable));
      expect(scrollable.controller?.offset ?? 0, 0);
      expect(avatarRect(tester, 0).center.dx, closeTo(195, 0.5));
    });

    testWidgets('slides the newly selected pet to the middle', (tester) async {
      await pumpAt(
        tester,
        _Harness(pets: [for (var i = 0; i < 6; i++) _pet('$i')]),
        const Size(390, 800),
      );

      /// Invoked rather than tapped: the fallback box paints nothing and so
      /// fails hit testing.
      avatars(tester).last.onTap!();
      await tester.pumpAndSettle();

      expect(avatarRect(tester, 5).center.dx, closeTo(195, 0.5));
    });

    /// The strip is shorter than the screen here, so only the added slack
    /// lets the last avatar travel that far.
    testWidgets('centres a pet even when the whole list fits on screen',
        (tester) async {
      await pumpAt(
        tester,
        _Harness(pets: [_pet('a'), _pet('b')]),
        const Size(390, 800),
      );

      avatars(tester).last.onTap!();
      await tester.pumpAndSettle();

      expect(avatarRect(tester, 1).center.dx, closeTo(195, 0.5));
    });
  });

  // NAN-095: scrolling is the selection gesture, not just a way to look.
  group('scrolling the park', () {
    /// One avatar slot. The strip is padded by half a viewport minus half a
    /// slot, so dragging by this lands the next pet dead centre.
    const slot = 156.0;

    Future<void> dragBy(WidgetTester tester, double dx) async {
      await tester.drag(find.byType(Scrollable), Offset(-dx, 0));
      await tester.pumpAndSettle();
    }

    testWidgets('selects the pet it comes to rest on', (tester) async {
      String? selected;
      await pumpAt(
        tester,
        build([for (var i = 0; i < 6; i++) _pet('$i')],
            onSelect: (id) => selected = id),
        const Size(390, 800),
      );

      await dragBy(tester, slot * 2);

      expect(selected, '2');
    });

    /// Each pet crossed on the way would repaint the page below it.
    testWidgets('reports once, not for every pet crossed', (tester) async {
      final reported = <String>[];
      await pumpAt(
        tester,
        build([for (var i = 0; i < 6; i++) _pet('$i')],
            onSelect: reported.add),
        const Size(390, 800),
      );

      await dragBy(tester, slot * 3);

      expect(reported, ['3']);
    });

    /// The loop the two mechanisms would otherwise form: selecting centres,
    /// centring scrolls, scrolling would select again.
    testWidgets('centring after a selection does not select again',
        (tester) async {
      final reported = <String>[];
      await pumpAt(
        tester,
        _Harness(pets: [for (var i = 0; i < 6; i++) _pet('$i')]),
        const Size(390, 800),
      );

      await dragBy(tester, slot * 2);
      await tester.pumpAndSettle();

      expect(avatarRect(tester, 2).center.dx, closeTo(195, 0.5));
      expect(reported, isEmpty);
    });

    testWidgets('a single pet stays selected whatever the drag',
        (tester) async {
      final reported = <String>[];
      await pumpAt(
        tester,
        build([_pet('a')], onSelect: reported.add),
        const Size(390, 800),
      );

      await dragBy(tester, slot * 2);

      expect(reported, isEmpty);
    });

    testWidgets('buzzes once per pet passing the middle', (tester) async {
      var taps = 0;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'HapticFeedback.vibrate') taps++;
          return null;
        },
      );
      addTearDown(() => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null));

      await pumpAt(
        tester,
        build([for (var i = 0; i < 6; i++) _pet('$i')]),
        const Size(390, 800),
      );

      /// Stepped by hand: a single drag is one jump, which crosses the three
      /// pets at once and would buzz once.
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(Scrollable)),
      );
      for (var i = 0; i < 3; i++) {
        await gesture.moveBy(const Offset(-slot, 0));
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();

      expect(taps, 3);
    });
  });

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
