import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanimo/config/router/app_router.dart';
import 'package:nanimo/core/isar/database/isar_service.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final String? url = dotenv.env['SUPABASE_URL'];
  final String? anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (url == null || anonKey == null) {
    throw Exception('Please add SUPABASE_URL and SUPABASE_ANON_KEY to your .env file');
  }

  await Supabase.initialize(url: url, anonKey: anonKey);
  await IsarService.initialize();

  final supabase = Supabase.instance.client;
  final isar = IsarService.instance;

  final authRepository = AuthRepository(supabase, isar);
  final subscriptionRepository = SubscriptionRepository(supabase, isar);

  final authCubit = AuthCubit(
    repository: authRepository,
    syncService: SyncService(supabase, isar),
  );

  final subscriptionCubit = SubscriptionCubit(
    authCubit: authCubit,
    authRepository: authRepository,
    subscriptionRepository: subscriptionRepository,
  );

  runApp(MyApp(authCubit: authCubit, subscriptionCubit: subscriptionCubit));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final SubscriptionCubit subscriptionCubit;
  const MyApp({
    super.key,
    required this.authCubit,
    required this.subscriptionCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: subscriptionCubit),
      ],
      child: MaterialApp.router(
        title: 'Nanimo',
        routerConfig: createRouter(authCubit),
      ),
    );
  }
}
