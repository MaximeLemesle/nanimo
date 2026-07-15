import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_menu_widget.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_widget.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  bool _isCreateMenuOpen = false;

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

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    var index = 0;
    var routeLength = -1;
    for (var i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i]) && _tabRoutes[i].length > routeLength) {
        index = i;
        routeLength = _tabRoutes[i].length;
      }
    }
    return index;
  }

  void _closeCreateMenu() {
    if (_isCreateMenuOpen) setState(() => _isCreateMenuOpen = false);
  }

  void _onTabSelected(BuildContext context, int index) {
    _closeCreateMenu();
    context.go(_tabRoutes[index]);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onAddWeight() {
    _closeCreateMenu();
    final petDetails = context.read<PetDetailsCubit>();
    if (petDetails.state.pets.isEmpty) {
      _showSnackBar('Ajoutez d\'abord un animal.');
      return;
    }
    BottomSheetWidget.show(
      context,
      AddWeightBottomSheetWidget(
        pets: petDetails.state.pets,
        iconsKey: petDetails.state.iconsKey,
        initialPetId: petDetails.state.selectedPetId,
        onSubmit: (weight, loggedAt, {petId}) => petDetails.addWeightLog(weight, loggedAt, petId: petId),
      ),
    );
  }

  void _onAddEvent() {
    _closeCreateMenu();
    context.push(RouteNames.createEvent);
  }

  String _petQuotaMessage(SubscriptionState subscription) {
    if (!subscription.isLoaded) {
      return 'Impossible de vérifier votre abonnement. Vérifiez votre connexion, puis réessayez.';
    }
    if (subscription.isPremium) {
      return 'Limite de ${subscription.maxPets} animaux atteinte.';
    }
    return 'Limite d\'animaux atteinte. Passez Premium pour en ajouter un nouveau.';
  }

  void _onAddPet() {
    _closeCreateMenu();
    final subscription = context.read<SubscriptionCubit>().state;
    final petCount = context.read<PetDetailsCubit>().state.pets.length;
    if (!subscription.canCreatePet(petCount)) {
      _showSnackBar(_petQuotaMessage(subscription));
      return;
    }

    /// Start the create-pet flow from a clean step 1
    context.read<OnboardingCubit>().reset();
    context.push(RouteNames.createPet);
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
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(child: widget.child),

          /// Tap outside the create menu closes it
          if (_isCreateMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeCreateMenu,
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBarMenuWidget(
              isOpen: _isCreateMenuOpen,
              onAddWeight: _onAddWeight,
              onAddEvent: _onAddEvent,
              onAddPet: _onAddPet,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x002D8B83), Color(0x302D8B83)],
          ),
        ),
        child: BottomBarWidget(
          currentIndex: index,
          isCreateMenuOpen: _isCreateMenuOpen,
          onTabSelected: (i) => _onTabSelected(context, i),
          onCreateTap: () => setState(() => _isCreateMenuOpen = !_isCreateMenuOpen),
        ),
      ),
    );
  }
}
