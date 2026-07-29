import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanimo/config/router/app_router.dart';
import 'package:nanimo/config/theme/app_theme.dart';
import 'package:nanimo/core/isar/database/isar_service.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/core/widgets/keyboard_dismiss_wrapper.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/subscription/data/purchase_client.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final String? url = dotenv.env['SUPABASE_URL'];
  final String? anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  final String? iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
  final String? webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
  final String? appleServiceId = dotenv.env['APPLE_SERVICE_ID'];
  if (url == null || anonKey == null) {
    throw Exception(
      'Please add SUPABASE_URL and SUPABASE_ANON_KEY to your .env file',
    );
  }
  if (iosClientId == null || webClientId == null || appleServiceId == null) {
    throw Exception(
      'Please add GOOGLE_IOS_CLIENT_ID, GOOGLE_WEB_CLIENT_ID and APPLE_SERVICE_ID to your .env file',
    );
  }

  await Supabase.initialize(url: url, anonKey: anonKey);
  await IsarService.initialize();

  final supabase = Supabase.instance.client;
  final isar = IsarService.instance;

  final authRepository = AuthRepository(
    supabase,
    isar,
    googleIosClientId: iosClientId,
    googleWebClientId: webClientId,
  );
  final subscriptionRepository = SubscriptionRepository(supabase, isar);
  final referentialRepository = ReferentialRepository(supabase, isar);
  final petRepository = PetRepository(supabase, isar);
  final healthRepository = HealthRepository(supabase, isar);
  final eventRepository = EventRepository(supabase, isar);
  final settingsRepository = SettingsRepository(supabase, isar);

  final purchaseRepository = PurchaseRepository(RevenueCatPurchaseClient());
  await _configurePurchases(purchaseRepository);

  final authCubit = AuthCubit(
    repository: authRepository,
    syncService: SyncService(supabase, isar),
  );

  /// Keeps the RevenueCat account aligned with the Supabase user, so the
  /// webhook can map `app_user_id` back to a row in `users`.
  authCubit.stream.listen((auth) {
    final userId = authRepository.currentUserId;
    if (auth.isAuthenticated && userId != null) {
      purchaseRepository.identify(userId);
    } else if (auth.isUnauthenticated) {
      purchaseRepository.forget();
    }
  });
  if (authCubit.state.isAuthenticated && authRepository.currentUserId != null) {
    await purchaseRepository.identify(authRepository.currentUserId!);
  }

  final subscriptionCubit = SubscriptionCubit(
    authCubit: authCubit,
    authRepository: authRepository,
    subscriptionRepository: subscriptionRepository,
  );

  final onboardingCubit = OnboardingCubit(
    referentialRepository: referentialRepository,
  );

  final petCreationCubit = PetCreationCubit(
    authCubit: authCubit,
    petRepository: petRepository,
  );

  runApp(MyApp(
    authCubit: authCubit,
    authRepository: authRepository,
    subscriptionCubit: subscriptionCubit,
    onboardingCubit: onboardingCubit,
    petCreationCubit: petCreationCubit,
    eventRepository: eventRepository,
    referentialRepository: referentialRepository,
    petRepository: petRepository,
    healthRepository: healthRepository,
    settingsRepository: settingsRepository,
    purchaseRepository: purchaseRepository,
  ));
}

/// Boots RevenueCat when a key is available for the current platform.
///
/// Unlike Supabase, a missing key is not fatal: every free feature keeps
/// working and only the paywall is unavailable. Throwing here would brick the
/// whole app over a subscription config, which is the wrong trade.
Future<void> _configurePurchases(PurchaseRepository repository) async {
  final key = Platform.isIOS
      ? dotenv.env['REVENUECAT_IOS_API_KEY']
      : dotenv.env['REVENUECAT_ANDROID_API_KEY'];

  if (key == null || key.isEmpty) {
    developer.log(
      'RevenueCat key missing for this platform, purchases are disabled',
      name: 'purchase',
    );
    return;
  }

  try {
    await repository.configure(key);
  } catch (e, st) {
    developer.log('RevenueCat setup failed, purchases are disabled',
        name: 'purchase', error: e, stackTrace: st);
  }
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final AuthRepository authRepository;
  final SubscriptionCubit subscriptionCubit;
  final OnboardingCubit onboardingCubit;
  final PetCreationCubit petCreationCubit;
  final EventRepository eventRepository;
  final ReferentialRepository referentialRepository;
  final PetRepository petRepository;
  final HealthRepository healthRepository;
  final SettingsRepository settingsRepository;
  final PurchaseRepository purchaseRepository;
  const MyApp({
    super.key,
    required this.authCubit,
    required this.authRepository,
    required this.subscriptionCubit,
    required this.onboardingCubit,
    required this.petCreationCubit,
    required this.eventRepository,
    required this.referentialRepository,
    required this.petRepository,
    required this.healthRepository,
    required this.settingsRepository,
    required this.purchaseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: onboardingCubit),
        BlocProvider.value(value: subscriptionCubit),
        BlocProvider.value(value: petCreationCubit),
      ],
      child: MaterialApp.router(
        title: 'Nanimo',
        theme: AppTheme.light,
        locale: const Locale('fr'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr')],
        builder: (context, child) => KeyboardDismissWrapper(
          child: child ?? const SizedBox.shrink(),
        ),
        routerConfig: createRouter(
          authCubit,
          authRepository: authRepository,
          eventRepository: eventRepository,
          referentialRepository: referentialRepository,
          petRepository: petRepository,
          healthRepository: healthRepository,
          settingsRepository: settingsRepository,
          purchaseRepository: purchaseRepository,
        ),
      ),
    );
  }
}
