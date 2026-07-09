import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Pull fresh data when the user comes back to the app
    if (state == AppLifecycleState.resumed) {
      context.read<AuthCubit>().resync();
    }
  }

  static const _tabRoutes = [
    RouteNames.home,
    RouteNames.journal,
    RouteNames.pet,
  ];

  static const _createIndex = 3;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RouteNames.createEvent)) return _createIndex;

    var index = 0;
    var routeLength = -1;
    for (var i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i]) &&
          _tabRoutes[i].length > routeLength) {
        index = i;
        routeLength = _tabRoutes[i].length;
      }
    }
    return index;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == _createIndex) {
      context.push(RouteNames.createEvent);
    } else {
      context.go(_tabRoutes[index]);
    }
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
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => _onDestinationSelected(context, i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Animal',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Créer',
          ),
        ],
      ),
    );
  }
}
