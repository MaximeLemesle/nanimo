import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_filter/journal_filter_bottom_sheet_widget.dart';

class JournalFilterListWidget extends StatelessWidget {
  final JournalState state;

  const JournalFilterListWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JournalCubit>();

    final selectedPets =
        state.pets.where((pet) => state.selectedPetIds.contains(pet.petId));
    final selectedTypes = state.types
        .where((type) => state.selectedTypeIds.contains(type.eventTypeId));

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (final pet in selectedPets) ...[
            ChipWidget(
              label: pet.petName,
              trailingIcon: Icons.close,
              isSelected: true,
              onTap: () => cubit.togglePetFilter(pet.petId),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          for (final type in selectedTypes) ...[
            ChipWidget(
              label: type.name,
              trailingIcon: Icons.close,
              isSelected: true,
              onTap: () => cubit.toggleTypeFilter(type.eventTypeId),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          ChipWidget(
            label: 'Filtres',
            trailingIcon: Icons.tune,
            onTap: () => JournalFilterBottomSheetWidget.show(context),
          ),
        ],
      ),
    );
  }
}
