import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';

/// The one way into the in-app pet creation. The onboarding hands its answers
/// to the paywall without resetting them, so any entry that skips the reset
/// reopens step 3 with the first pet already filled in (NAN-100).
abstract final class PetCreationFlow {
  static void open(BuildContext context, {bool replace = false}) {
    context.read<OnboardingCubit>().reset();
    if (replace) {
      context.pushReplacement(RouteNames.createPet);
    } else {
      context.push(RouteNames.createPet);
    }
  }
}
