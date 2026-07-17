import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class HomePetListWidget extends StatefulWidget {
  final List<PetModel> pets;
  final Map<String, String> iconsKey;
  final void Function(String petId)? onPetTap;

  const HomePetListWidget({
    super.key,
    required this.pets,
    required this.iconsKey,
    this.onPetTap,
  });

  @override
  State<HomePetListWidget> createState() => _HomePetListWidgetState();
}

class _HomePetListWidgetState extends State<HomePetListWidget> {
  static const double _fadeWidth = AppSpacing.xl;

  final ScrollController _controller = ScrollController();
  bool _hasMoreRight = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncFade);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFade());
  }

  @override
  void didUpdateWidget(HomePetListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pets.length != widget.pets.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncFade());
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFade);
    _controller.dispose();
    super.dispose();
  }

  /// The fade is the only cue that the row scrolls, so it has to disappear at
  /// the end of the list — a permanent one would read as plain decoration.
  void _syncFade() {
    if (!mounted || !_controller.hasClients) return;
    final position = _controller.position;
    final hasMoreRight = position.pixels < position.maxScrollExtent - 1;
    if (hasMoreRight != _hasMoreRight) {
      setState(() => _hasMoreRight = hasMoreRight);
    }
  }

  Widget _buildAvatar(PetModel pet) {
    final iconKey = widget.iconsKey[pet.petSpeciesId];

    return GestureDetector(
      onTap: widget.onPetTap == null ? null : () => widget.onPetTap!(pet.petId),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          if (iconKey != null)
            PetAvatarWidget(iconKey: iconKey)
          else
            SizedBox(
              width: PetAvatarSize.medium.dimension,
              height: PetAvatarSize.medium.dimension,
              child: const Icon(
                Icons.pets,
                color: AppColors.textSecondary,
                size: AppSpacing.xl,
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            pet.petName,
            style: AppTextStyles.textSmallBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget list = SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < widget.pets.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xl),
            _buildAvatar(widget.pets[i]),
          ],
        ],
      ),
    );

    if (_hasMoreRight) {
      list = ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: const [Colors.transparent, Colors.black],
          stops: [0, _fadeWidth / bounds.width],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: list,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          widget.pets.length > 1 ? 'Mes Nanimo' : 'Mon Nanimo',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        list,
      ],
    );
  }
}
