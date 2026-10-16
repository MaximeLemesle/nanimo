import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_vaccine_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_vet_visit_diary_card_widget.dart';

/// NAN-109: an empty section says what it is for and offers one action.
void main() {
  final birthdate = DateTime(2022, 6, 15);

  Future<void> pump(WidgetTester tester, Widget card) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(child: card))));
  }

  testWidgets('empty vaccines explain the section and offer to add one', (tester) async {
    await pump(tester, PetVaccineDiaryCardWidget(vaccines: const [], birthdate: birthdate));

    expect(find.text('Note ses vaccins ici, on te préviendra avant chaque rappel.'), findsOneWidget);
    expect(find.text('Ajouter un vaccin'), findsOneWidget);
  });

  testWidgets('empty visits offer to plan one', (tester) async {
    await pump(tester, PetVetVisitDiaryCardWidget(visits: const [], birthdate: birthdate));

    expect(find.textContaining('Note ses visites chez le vétérinaire'), findsOneWidget);
    expect(find.text('Prévoir une visite'), findsOneWidget);
  });

  testWidgets('a read-only animal offers no way to add', (tester) async {
    await pump(tester, Column(children: [
      PetVaccineDiaryCardWidget(vaccines: const [], birthdate: birthdate, readOnly: true),
      PetVetVisitDiaryCardWidget(visits: const [], birthdate: birthdate, readOnly: true),
    ]));

    expect(find.text('Ajouter un vaccin'), findsNothing);
    expect(find.text('Prévoir une visite'), findsNothing);
  });
}
