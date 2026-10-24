import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_menu_widget.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_widget.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/pet_creation_flow.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/notifications/notification_priming_sheet.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/notifications/reminder_planner.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final ValueListenable<bool> isModalOpen;

  /// A sheet left open stays under the pages a tapped notification opens.
  final VoidCallback? closeModals;

  const AppShell({
    super.key,
    required this.child,
    required this.isModalOpen,
    this.closeModals,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  bool _isCreateMenuOpen = false;
  bool _notificationNavigationScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pendingNotificationTap.addListener(_openTappedReminder);
    notificationPriming.offer.addListener(_showPriming);
    WidgetsBinding.instance.addPostFrameCallback((_) => _openTappedReminder());
  }

  @override
  void dispose() {
    pendingNotificationTap.removeListener(_openTappedReminder);
    notificationPriming.offer.removeListener(_showPriming);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Waits for the add sheet to close before opening its own.
  Future<void> _showPriming() async {
    final offer = notificationPriming.offer.value;
    if (offer == null || !mounted) return;
    final accepted = await BottomSheetWidget.show<bool>(
        context, NotificationPrimingSheet(offer: offer));
    if (accepted == true) {
      await notificationPriming.accept();
    } else {
      await notificationPriming.postpone();
    }
  }

  /// Keeps cold-start taps until the shell and its cached animals are ready.
  void _openTappedReminder() {
    if (!mounted ||
        pendingNotificationTap.value == null ||
        _notificationNavigationScheduled) {
      return;
    }
    _notificationNavigationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationNavigationScheduled = false;
      if (!mounted) return;
      final payload = pendingNotificationTap.value;
      if (payload == null) return;
      final reminder = parseReminderPayload(payload);
      if (reminder == null) {
        pendingNotificationTap.value = null;
        return;
      }
      final petDetails = context.read<PetDetailsCubit>();
      if (reminder.kind != ReminderKind.trialEnd) {
        if (petDetails.state.status == PetDetailsStatus.loading ||
            petDetails.state.pets.isEmpty) {
          return;
        }
        if (!petDetails.state.pets.any((pet) => pet.petId == reminder.petId)) {
          pendingNotificationTap.value = null;
          context.go(RouteNames.home);
          _showSnackBar('Cet animal n’est plus disponible.');
          return;
        }
      }
      pendingNotificationTap.value = null;
      widget.closeModals?.call();
      analytics.capture(AnalyticsEvents.notificationOpened,
          properties: {AnalyticsProperties.kind: reminder.kind.name});
      if (reminder.kind == ReminderKind.trialEnd) {
        context.go(RouteNames.settings);
        return;
      }
      petDetails.selectPet(reminder.petId);
      if (reminder.kind == ReminderKind.birthday) {
        context.go(Uri(
            path: RouteNames.createEvent,
            queryParameters: {'petId': reminder.petId}).toString());
      } else {
        context.go(RouteNames.healthDiary);
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
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
      if (location.startsWith(_tabRoutes[i]) &&
          _tabRoutes[i].length > routeLength) {
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
        portraits: petDetails.state.portraits,
        initialPetId: petDetails.state.selectedPetId,
        birthdate: petDetails.state.selectedPet?.birthdate,
        onSubmit: (weight, loggedAt, {petId}) =>
            petDetails.addWeightLog(weight, loggedAt,
                petId: petId, source: WeightSource.createMenu),
      ),
    );
  }

  void _onAddEvent() {
    _closeCreateMenu();
    context.push(RouteNames.createEvent);
  }

  void _onAddPet() {
    _closeCreateMenu();
    final subscription = context.read<SubscriptionCubit>().state;
    final petCount = context.read<PetDetailsCubit>().state.pets.length;
    if (!subscription.canCreatePet(petCount)) {
      QuotaUpsell.petQuotaReached(context, subscription);
      return;
    }

    PetCreationFlow.open(context);
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<PetDetailsCubit, PetDetailsState>(
          listenWhen: (previous, current) =>
              previous.pets != current.pets ||
              previous.status != current.status,
          listener: (_, __) => _openTappedReminder(),
        ),
        BlocListener<PetCreationCubit, PetCreationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onPetCreationChanged,
        ),
      ],
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

  /// Only a free user whose plan is known and already full gets the marker:
  /// a premium user has nothing to buy, an unknown plan tells us nothing.
  bool _isAddPetPremiumLocked(SubscriptionState subscription, int petCount) =>
      QuotaUpsell.offersUpgrade(subscription) &&
      !subscription.canCreatePet(petCount);

  Widget _buildCreateMenu() {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, subscription) =>
          BlocBuilder<PetDetailsCubit, PetDetailsState>(
        builder: (context, petDetails) => BottomBarMenuWidget(
          isOpen: _isCreateMenuOpen,
          isAddPetPremiumLocked:
              _isAddPetPremiumLocked(subscription, petDetails.pets.length),
          onAddWeight: _onAddWeight,
          onAddEvent: _onAddEvent,
          onAddPet: _onAddPet,
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
            child: _buildCreateMenu(),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: widget.isModalOpen,
        builder: (context, isModalOpen, bar) {
          return IgnorePointer(
            key: const Key('bottom_bar_ignore_pointer'),
            ignoring: isModalOpen,
            child: AnimatedOpacity(
              opacity: isModalOpen ? 0 : 1,
              duration: const Duration(milliseconds: 150),
              child: bar,
            ),
          );
        },
        child: Container(
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
            onCreateTap: () =>
                setState(() => _isCreateMenuOpen = !_isCreateMenuOpen),
          ),
        ),
      ),
    );
  }
}
