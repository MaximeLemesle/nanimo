import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanimo/config/router/app_router.dart';
import 'package:nanimo/config/theme/app_theme.dart';
import 'package:nanimo/core/isar/database/isar_service.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
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
  final referentialRepository = ReferentialRepository(supabase);
  final petRepository = PetRepository(supabase, isar);

  final authCubit = AuthCubit(
    repository: authRepository,
    syncService: SyncService(supabase, isar),
  );

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

  final homeCubit = HomeCubit(
    petRepository: petRepository,
    referentialRepository: referentialRepository,
  );

  runApp(MyApp(
    authCubit: authCubit,
    subscriptionCubit: subscriptionCubit,
    onboardingCubit: onboardingCubit,
    petCreationCubit: petCreationCubit,
    homeCubit: homeCubit,
  ));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final SubscriptionCubit subscriptionCubit;
  final OnboardingCubit onboardingCubit;
  final PetCreationCubit petCreationCubit;
  final HomeCubit homeCubit;
  const MyApp({
    super.key,
    required this.authCubit,
    required this.subscriptionCubit,
    required this.onboardingCubit,
    required this.petCreationCubit,
    required this.homeCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: onboardingCubit),
        BlocProvider.value(value: subscriptionCubit),
        BlocProvider.value(value: petCreationCubit),
        BlocProvider.value(value: homeCubit),
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
        routerConfig: createRouter(authCubit),
      ),
    );
  }
}
