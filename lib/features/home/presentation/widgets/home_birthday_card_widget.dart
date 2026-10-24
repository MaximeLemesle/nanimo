import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';

/// Remembers which birthdays already had their confetti.
abstract class BirthdayCelebrationStore {
  /// True the first time [key] is claimed, false afterwards.
  Future<bool> claim(String key);
}

class SharedPreferencesBirthdayCelebrationStore implements BirthdayCelebrationStore {
  @override
  Future<bool> claim(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = 'birthday_celebrated:$key';
    if (prefs.getBool(storageKey) ?? false) return false;
    await prefs.setBool(storageKey, true);
    return true;
  }
}

class MemoryBirthdayCelebrationStore implements BirthdayCelebrationStore {
  final bool celebrates;
  final Set<String> claimed = {};

  MemoryBirthdayCelebrationStore({this.celebrates = true});

  @override
  Future<bool> claim(String key) async => celebrates && claimed.add(key);
}

/// Assigned in main. Silent by default so other screens' tests stay as they were.
BirthdayCelebrationStore birthdayCelebrationStore = MemoryBirthdayCelebrationStore(celebrates: false);

/// Shown on the home all day long on a pet's birthday, with confetti the
/// first time it appears that year.
class HomeBirthdayCardWidget extends StatefulWidget {
  final String petId;
  final String petName;
  final int age;
  final PetPortrait? portrait;
  final VoidCallback onAddMemory;
  final DateTime? now;

  const HomeBirthdayCardWidget({
    super.key,
    required this.petId,
    required this.petName,
    required this.age,
    required this.portrait,
    required this.onAddMemory,
    this.now,
  });

  static String ageLabel(int age) => '${age == 1 ? '1 an' : '$age ans'} aujourd’hui !';

  @override
  State<HomeBirthdayCardWidget> createState() => _HomeBirthdayCardWidgetState();
}

class _HomeBirthdayCardWidgetState extends State<HomeBirthdayCardWidget> {
  @override
  void initState() {
    super.initState();
    _celebrate();
  }

  Future<void> _celebrate() async {
    final year = (widget.now ?? DateTime.now()).year;
    if (!await birthdayCelebrationStore.claim('${widget.petId}:$year')) return;
    if (!mounted) return;
    Confetti.launch(context,
        options: const ConfettiOptions(
          particleCount: 120,
          spread: 90,
          y: 0.3,
          colors: [AppColors.primary, AppColors.secondary, AppColors.tertiary],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md + AppSpacing.xl),
      child: Transform.rotate(
        angle: 0.025,
        child: Stack(
          clipBehavior: Clip.none,
          children: [_buildCard(), _buildTape(), _buildTag()],
        ),
      ),
    );
  }

  /// A paper greeting card, like the memory polaroid it sits next to.
  Widget _buildCard() {
    final portrait = widget.portrait;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.backgroundStroke, width: 2),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40, width: double.infinity, child: CustomPaint(painter: _BuntingPainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
            child: Column(
              children: [
                portrait == null
                    ? const Text('🎂', style: TextStyle(fontSize: 56))
                    : PetAvatarWidget(portrait: portrait, size: PetAvatarSize.medium),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Joyeux anniversaire',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title02.copyWith(fontSize: AppFontSize.lg, color: AppColors.secondary500),
                ),
                Text(
                  '${widget.petName} !',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title03,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  HomeBirthdayCardWidget.ageLabel(widget.age),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ButtonWidget(
                  label: 'Ajouter un souvenir',
                  fullWidth: true,
                  onPressed: widget.onAddMemory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTape() {
    return Positioned(
      top: -AppSpacing.sm,
      right: -AppSpacing.md,
      child: Transform.rotate(
        angle: 0.6,
        child: Container(width: 72, height: 24, color: AppColors.secondary200.withValues(alpha: 0.85)),
      ),
    );
  }

  Widget _buildTag() {
    return Positioned(
      top: -AppSpacing.sm,
      left: -AppSpacing.sm,
      child: Transform.rotate(
        angle: -0.06,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.secondary300,
            borderRadius: BorderRadius.circular(AppRadius.sm / 2),
            boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: Text('Aujourd’hui', style: AppTextStyles.textSmallBold),
        ),
      ),
    );
  }
}

/// A garland of little flags hanging across the top of the card.
class _BuntingPainter extends CustomPainter {
  const _BuntingPainter();

  static const _colors = [AppColors.tertiary300, AppColors.secondary300, AppColors.primary300];
  static const _flagWidth = 22.0;
  static const _flagHeight = 20.0;
  static const _sag = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    double stringY(double x) {
      final t = x / size.width;
      return 6 + _sag * 4 * t * (1 - t);
    }

    final string = Path()..moveTo(0, stringY(0));
    for (var x = 0.0; x <= size.width; x += 4) {
      string.lineTo(x, stringY(x));
    }
    canvas.drawPath(
      string,
      Paint()
        ..color = AppColors.neutral300
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final count = (size.width / (_flagWidth + 6)).floor();
    final gap = (size.width - count * _flagWidth) / (count + 1);
    for (var i = 0; i < count; i++) {
      final left = gap + i * (_flagWidth + gap);
      final right = left + _flagWidth;
      final tip = left + _flagWidth / 2;
      canvas.drawPath(
        Path()
          ..moveTo(left, stringY(left))
          ..lineTo(right, stringY(right))
          ..lineTo(tip, stringY(tip) + _flagHeight)
          ..close(),
        Paint()..color = _colors[i % _colors.length],
      );
    }
  }

  @override
  bool shouldRepaint(_BuntingPainter oldDelegate) => false;
}
