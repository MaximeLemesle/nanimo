import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class PetParkHeaderWidget extends StatelessWidget {
  final List<PetModel> pets;
  final String? selectedPetId;
  final Map<String, String> iconsKey;
  final ValueChanged<String> onSelect;

  const PetParkHeaderWidget({
    super.key,
    required this.pets,
    required this.selectedPetId,
    required this.iconsKey,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(bottom: AppSpacing.xl),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/parc.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: ConstrainedBox(
                    /// Forcing the row to at least the viewport width keeps a
                    /// short list centred in the park, exactly as before; past
                    /// that the row grows and the scroll view takes over.
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth - AppSpacing.sm * 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final pet in pets) _buildAvatar(pet),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(PetModel pet) {
    final iconKey = iconsKey[pet.petSpeciesId];
    final isSelected = pet.petId == selectedPetId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: GestureDetector(
        onTap: () => onSelect(pet.petId),
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.60,
          duration: const Duration(milliseconds: 200),
          child: iconKey == null
              ? const SizedBox(width: 80, height: 80)
              : ColorFiltered(
                  colorFilter: isSelected
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.3),
                          BlendMode.srcATop,
                        ),
                  child: PetAvatarWidget(
                    iconKey: iconKey,
                    size: PetAvatarSize.medium,
                  ),
                ),
        ),
      ),
    );
  }
}
