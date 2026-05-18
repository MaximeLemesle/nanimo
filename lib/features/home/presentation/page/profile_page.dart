import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.read<AuthCubit>().logout(),
        child: const Text('Se déconnecter'),
      ),
    );
  }
}
