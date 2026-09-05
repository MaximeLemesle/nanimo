import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class PetParkHeaderWidget extends StatefulWidget {
  final List<PetModel> pets;
  final String? selectedPetId;
  final Map<String, PetPortrait> portraits;
  final ValueChanged<String> onSelect;

  const PetParkHeaderWidget({
    super.key,
    required this.pets,
    required this.selectedPetId,
    required this.portraits,
    required this.onSelect,
  });

  @override
  State<PetParkHeaderWidget> createState() => _PetParkHeaderWidgetState();
}

class _PetParkHeaderWidgetState extends State<PetParkHeaderWidget> {
  /// Fixed rather than measured: the catalogue icons are 512x460, so a 140pt
  /// avatar is 156pt wide, and an Image reports no width at all until it is
  /// decoded. A slot left to the image lands the strip off centre on the
  /// first frame, then shifts once the pictures arrive.
  static const double _avatarWidth = 156;

  final Map<String, GlobalKey> _avatarKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _centerSelected(duration: Duration.zero),
    );
  }

  @override
  void didUpdateWidget(covariant PetParkHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPetId != widget.selectedPetId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelected());
    }
  }

  /// Slides the selected avatar to the middle of the park: the pet the page is
  /// about should be the one under the eye, wherever it sits in the list.
  void _centerSelected({
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final petId = widget.selectedPetId;
    if (!mounted || petId == null) return;
    final target = _avatarKeys[petId]?.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      alignment: 0.5,
      duration: duration,
      curve: Curves.easeOutCubic,
    );
  }

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

                  /// Slack of half a viewport minus half an avatar, so the
                  /// first and the last one come to rest dead centre.
                  padding: EdgeInsets.symmetric(
                    horizontal: (constraints.maxWidth - _avatarWidth) / 2,
                  ),
                  child: Row(
                    children: [
                      for (final pet in widget.pets) _buildAvatar(pet),
                    ],
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
    final portrait = widget.portraits[pet.petId];
    final isSelected = pet.petId == widget.selectedPetId;

    return GestureDetector(
      key: _avatarKeys.putIfAbsent(pet.petId, GlobalKey.new),
      onTap: () => widget.onSelect(pet.petId),
      child: AnimatedScale(
        scale: isSelected ? 1.0 : 0.60,
        duration: const Duration(milliseconds: 200),
        child: portrait == null
            ? SizedBox(
                width: _avatarWidth,
                height: PetAvatarSize.large.dimension,
              )
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
                child: SizedBox(
                  width: _avatarWidth,
                  child: PetAvatarWidget(
                    portrait: portrait,
                    size: PetAvatarSize.large,
                  ),
                ),
              ),
      ),
    );
  }
}
