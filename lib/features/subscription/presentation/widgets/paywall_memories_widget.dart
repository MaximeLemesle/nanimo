import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

/// The three polaroids shown above the paywall pitch, the waiting screen and
/// the welcome page.
///
/// [isAnimated] makes them drift, and it is off by default on purpose. A
/// looping animation never lets `pumpAndSettle` return, so switching it on
/// everywhere would hang every widget test that mounts the paywall. It earns
/// its keep on the waiting screen, where the whole point is to prove the app
/// is still working.
class PaywallMemoriesWidget extends StatefulWidget {
  final bool isAnimated;

  const PaywallMemoriesWidget({super.key, this.isAnimated = false});

  static const double height = 120;
  static const double _cardWidth = 116;

  @override
  State<PaywallMemoriesWidget> createState() => _PaywallMemoriesWidgetState();
}

class _PaywallMemoriesWidgetState extends State<PaywallMemoriesWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Slow enough to read as breathing rather than as a loading spinner. The
  /// spinner is the Lottie logo underneath; this must not compete with it.
  static const _period = Duration(seconds: 3);

  /// Out of phase, so the three cards never line up on the same beat.
  static const _phases = [0.0, 0.42, 0.78];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _period);
    if (widget.isAnimated) _controller.repeat();
  }

  @override
  void didUpdateWidget(PaywallMemoriesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimated == oldWidget.isAnimated) return;
    widget.isAnimated ? _controller.repeat() : _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PaywallMemoriesWidget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _polaroid(
            asset: 'assets/icons/species/rabbit-nain.png',
            tint: AppColors.backgroundTertiary,
            angle: -0.17,
            offset: const Offset(-74, 10),
            scale: 0.86,
            phase: _phases[0],
          ),
          _polaroid(
            asset: 'assets/icons/species/cat-europeen.png',
            tint: AppColors.backgroundSecondary,
            angle: 0.16,
            offset: const Offset(74, 10),
            scale: 0.86,
            phase: _phases[1],
          ),
          _polaroid(
            asset: 'assets/icons/species/dog-jack_russell_terrier.png',
            tint: AppColors.backgroundPrimary,
            angle: -0.03,
            offset: const Offset(0, -8),
            scale: 1,
            phase: _phases[2],
          ),
        ],
      ),
    );
  }

  Widget _polaroid({
    required String asset,
    required Color tint,
    required double angle,
    required Offset offset,
    required double scale,
    required double phase,
  }) {
    final card = _card(asset: asset, tint: tint);

    if (!widget.isAnimated) {
      return _place(
        offset: offset,
        angle: angle,
        scale: scale,
        child: card,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      child: card,
      builder: (context, child) {
        /// A full sine turn over the period, so the loop closes on itself and
        /// there is no jump when the controller wraps.
        final wave = math.sin((_controller.value + phase) * 2 * math.pi);
        return _place(
          offset: offset + Offset(0, wave * 4),
          angle: angle + wave * 0.02,
          scale: scale,
          child: child!,
        );
      },
    );
  }

  Widget _place({
    required Offset offset,
    required double angle,
    required double scale,
    required Widget child,
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(scale: scale, child: child),
      ),
    );
  }

  Widget _card({required String asset, required Color tint}) {
    return Container(
      width: PaywallMemoriesWidget._cardWidth,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(22, 0, 0, 0),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm / 2),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: tint,
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
