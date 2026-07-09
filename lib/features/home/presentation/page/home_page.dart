import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_family_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_memory_polaroid_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_week_card_widget.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.pets.isEmpty) {
              return const Center(child: Text('Aucun animal pour le moment'));
            }

            final now = DateTime.now();
            final cubit = context.read<HomeCubit>();
            final anniversary = state.anniversaryEvent(now: now);
            final memory = anniversary ?? state.latestEvent;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _Masthead(userName: state.userName, now: now),
                const SizedBox(height: AppSpacing.lg),
                if (memory != null) ...[
                  HomeMemoryPolaroidWidget(
                    event: memory,
                    yearsAgo: anniversary == null
                        ? null
                        : state.yearsAgo(anniversary, now: now),
                    imagePaths:
                        state.imagePathsByEvent[memory.eventId] ?? const [],
                    urlResolver: cubit.imageUrl,
                    onTap: () => context.push(RouteNames.journal),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                HomeHealthCardWidget(
                  alerts: state.vaccineAlerts(now: now),
                  iconsKey: state.iconsKey,
                  onAlertTap: (petId) => _openPet(
                    context,
                    petId,
                    route: RouteNames.healthDiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: HomeWeekCardWidget(
                          count: state.weekEvents(now: now).length,
                          activeDays: state.weekActiveDays(now: now),
                          onTap: () => context.push(RouteNames.journal),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: HomeFamilyCardWidget(
                          pets: state.pets,
                          iconsKey: state.iconsKey,
                          statusByPet: state.vaccineStatusByPet(now: now),
                          onPetTap: (petId) =>
                              _openPet(context, petId, route: RouteNames.pet),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Selects [petId] on the shared PetDetailsCubit then navigates to [route].
  void _openPet(BuildContext context, String petId, {required String route}) {
    context.read<PetDetailsCubit>().selectPet(petId);
    context.push(route);
  }
}

class _Masthead extends StatelessWidget {
  final String? userName;
  final DateTime now;

  const _Masthead({required this.now, this.userName});

  @override
  Widget build(BuildContext context) {
    final name = userName;

    return Column(
      children: [
        Text(
          DateFormatter.weekdayDayMonth(now).toUpperCase(),
          style: AppTextStyles.numberSmall.copyWith(
            fontSize: AppFontSize.xs,
            color: AppColors.textSecondary,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name == null ? 'Votre gazette' : 'La gazette de $name',
          style: AppTextStyles.title02,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(
                  Icons.pets,
                  size: AppSpacing.md - AppSpacing.xs,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
