import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/vaccine_status.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

void main() {
  testWidgets('shows the pet icon and vaccine due date', (tester) async {
    final pet = PetModel(
      petId: 'pet-1',
      petName: 'Milo',
      birthdate: DateTime(2022, 6, 15),
      gender: Gender.male,
      createdAt: DateTime(2026, 6, 10),
      petRaceId: 'race-1',
      petSpeciesId: 'species-1',
    );
    final vaccine = HealthDiaryVaccineModel(
      healthDiaryVaccineId: 'vaccine-1',
      vaccineName: 'Rage',
      lastDate: DateTime(2025, 8, 24),
      nextDate: DateTime(2026, 8, 24),
      recurrence: 365,
      doseNumber: 1,
      totalDoseNumber: 1,
      healthDiaryId: 'diary-1',
    );
    final VaccineAlert alert = (
      vaccine: vaccine,
      pet: pet,
      status: VaccineStatus.soon,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeHealthCardWidget(
            alerts: [alert],
            portraits: const {'pet-1': PetPortrait.species('cat-europeen')},
          ),
        ),
      ),
    );

    expect(find.byType(PetAvatarWidget), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsNothing);
    expect(find.text('24/08/2026'), findsOneWidget);
    expect(find.text('Milo'), findsNothing);
  });
}
