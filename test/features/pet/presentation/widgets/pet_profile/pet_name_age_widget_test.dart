import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_name_age_widget.dart';

/// What an iPhone SE leaves: 375 minus the page padding and the edit button.
const _smallestWidth = 295.0;
const _longName = 'Marmelade de Bourgogne';

void main() {
  final now = DateTime(2026, 6, 15);

  Widget harness(String name, DateTime birthdate, {double width = _smallestWidth}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: PetNameAgeWidget(name: name, birthdate: birthdate, now: now),
          ),
        ),
      ),
    );
  }

  testWidgets('renders the age in days under a month', (tester) async {
    await tester.pumpWidget(harness(_longName, DateTime(2026, 5, 25)));

    expect(find.text('21 jours'), findsOneWidget);
  });

  // NAN-092: the age took the width it needed, the name got the remainder.
  testWidgets('gives the name the same width whatever the age string',
      (tester) async {
    await tester.pumpWidget(harness(_longName, DateTime(2026, 5, 25)));
    final withDays = tester.getRect(find.text(_longName));

    await tester.pumpWidget(harness(_longName, DateTime(2023, 1, 1)));
    final withYears = tester.getRect(find.text(_longName));

    expect(find.text('3 ans'), findsOneWidget);
    expect(withDays.width, withYears.width);
  });

  testWidgets('never clips the name, however long it is', (tester) async {
    await tester.pumpWidget(harness(_longName, DateTime(2026, 5, 25)));

    final paragraph = tester.renderObject<RenderParagraph>(find.text(_longName));
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(paragraph.size.width, lessThanOrEqualTo(_smallestWidth));
  });

  testWidgets('drops the age below the name when the pair does not fit',
      (tester) async {
    await tester.pumpWidget(harness(_longName, DateTime(2026, 5, 25)));

    final name = tester.getRect(find.text(_longName));
    final age = tester.getRect(find.text('21 jours'));
    expect(age.top, greaterThanOrEqualTo(name.bottom));
  });

  testWidgets('keeps name and age on one line when there is room',
      (tester) async {
    await tester.pumpWidget(harness('Milo', DateTime(2026, 5, 25), width: 700));

    final name = tester.getRect(find.text('Milo'));
    final age = tester.getRect(find.text('21 jours'));
    expect(age.top, lessThan(name.bottom));
  });

  testWidgets('pins the age to the right edge when both fit', (tester) async {
    const width = 700.0;
    await tester.pumpWidget(harness('Milo', DateTime(2026, 5, 25), width: width));

    final host = tester.getRect(find.byType(PetNameAgeWidget));
    final name = tester.getRect(find.text('Milo'));
    final age = tester.getRect(find.text('21 jours'));

    expect(name.left, host.left);
    expect(age.right, moreOrLessEquals(host.right, epsilon: 0.5));
  });

  testWidgets('keeps the age on the right edge once it has wrapped',
      (tester) async {
    await tester.pumpWidget(harness(_longName, DateTime(2026, 5, 25)));

    final host = tester.getRect(find.byType(PetNameAgeWidget));
    final age = tester.getRect(find.text('21 jours'));

    expect(age.right, moreOrLessEquals(host.right, epsilon: 0.5));
  });

  testWidgets('gives the name every pixel the age leaves', (tester) async {
    const width = 700.0;
    await tester.pumpWidget(harness('Milo', DateTime(2026, 5, 25), width: width));

    final name = tester.getRect(find.text('Milo'));
    final age = tester.getRect(find.text('21 jours'));

    expect(name.width, moreOrLessEquals(width - age.width - 8, epsilon: 0.5));
  });
}
