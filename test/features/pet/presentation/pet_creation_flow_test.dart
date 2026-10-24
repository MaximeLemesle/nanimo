import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/presentation/pet_creation_flow.dart';

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

/// NAN-100: after the purchase, "Ajouter un nouvel animal" reopened the
/// creation on the onboarding's leftover answers, and "Créer" duplicated
/// the first pet.
void main() {
  testWidgets('the premium welcome entry starts from a clean step 1', (tester) async {
    final cubit = OnboardingCubit(referentialRepository: _MockReferentialRepository())..setPetName('Milo');
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => TextButton(
          onPressed: () => PetCreationFlow.open(context, replace: true),
          child: const Text('Ajouter un nouvel animal'),
        ),
      ),
      GoRoute(path: RouteNames.createPet, builder: (_, __) => const Text('creation')),
    ]);

    await tester.pumpWidget(BlocProvider.value(
      value: cubit,
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.tap(find.text('Ajouter un nouvel animal'));
    await tester.pumpAndSettle();

    expect(find.text('creation'), findsOneWidget);
    expect(cubit.state.petName, isEmpty);
    expect(cubit.state.currentStep, 1);
    await cubit.close();
  });
}
