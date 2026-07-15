import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_article_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_header_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_memory_polaroid_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_pet_list_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.pets.isEmpty) {
              return const Center(child: Text('Aucun animal pour le moment'));
            }

            final now = DateTime.now();
            final anniversary = state.anniversaryEvent(now: now);
            final memory = anniversary ?? state.latestEvent;

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.bottomBarInset,
              ),
              children: [
                HomeHeaderWidget(
                  userName: state.userName,
                  now: now,
                  onSettingsTap: () => context.push(RouteNames.settings),
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Display the last memory or the remember "X years ago"
                if (memory != null) ...[
                  HomeMemoryPolaroidWidget(
                    event: memory,
                    yearsAgo: anniversary == null ? null : state.yearsAgo(anniversary, now: now),
                    imagePaths: state.imagePathsByEvent[memory.eventId] ?? const [],
                    urlResolver: context.read<HomeCubit>().imageUrl,
                    onTap: () => JournalEventDetailBottomSheetWidget.show(
                      context,
                      event: memory,
                      onEdit: () => context.push('${RouteNames.editEvent}/${memory.eventId}'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                /// List of the user's pets
                HomePetListWidget(
                  pets: state.pets,
                  iconsKey: state.iconsKey,
                  onPetTap: (petId) {
                    context.read<PetDetailsCubit>().selectPet(petId);
                    context.push(RouteNames.pet);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                /// List of vaccine alerts for the user's pets
                HomeHealthCardWidget(
                  alerts: state.vaccineAlerts(now: now),
                  iconsKey: state.iconsKey,
                  onAlertTap: (petId) {
                    context.read<PetDetailsCubit>().selectPet(petId);
                    context.push(RouteNames.healthDiary);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Display the latest article
                const HomeArticleCardWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}
