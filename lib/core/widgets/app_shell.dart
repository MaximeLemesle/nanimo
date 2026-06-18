import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _routes = [
    RouteNames.home,
    RouteNames.pet,
    RouteNames.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    var index = 0;
    var routeLength = -1;
    for (var i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i]) && _routes[i].length > routeLength) {
        index = i;
        routeLength = _routes[i].length;
      }
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return BlocListener<PetCreationCubit, PetCreationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onPetCreationChanged,
      child: _buildScaffold(context, index),
    );
  }

  void _onPetCreationChanged(BuildContext context, PetCreationState state) {
    if (state.status != PetCreationStatus.error) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(state.error ?? 'Impossible de créer votre animal.'),
          action: SnackBarAction(
            label: 'Réessayer',
            onPressed: () => context.read<PetCreationCubit>().retry(),
          ),
        ),
      );
  }

  Widget _buildScaffold(BuildContext context, int index) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_routes[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Animal',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
