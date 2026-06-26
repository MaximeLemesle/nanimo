import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInvert,
        onPressed: () => context.push(RouteNames.createEvent),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.pets.isEmpty) {
              return const Center(child: Text('Aucun animal pour le moment'));
            }
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                for (final pet in state.pets)
                  _PetCard(
                    pet: pet,
                    iconKey: state.iconsKey[pet.petSpeciesId],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final PetModel pet;
  final String? iconKey;

  const _PetCard({required this.pet, this.iconKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.backgroundStroke),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (iconKey != null)
              PetAvatarWidget(iconKey: iconKey!, size: PetAvatarSize.small)
            else
              const Icon(Icons.pets, size: 40, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.petName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Né le ${pet.birthdate.day.toString().padLeft(2, '0')}'
                    '/${pet.birthdate.month.toString().padLeft(2, '0')}'
                    '/${pet.birthdate.year}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
