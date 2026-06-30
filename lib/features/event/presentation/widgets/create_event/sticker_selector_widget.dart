import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';

class StickerSelectorWidget extends StatelessWidget {
  final List<Widget> stickers;
  final VoidCallback onTap;
  final String semanticLabel;

  const StickerSelectorWidget({
    super.key,
    required this.stickers,
    required this.onTap,
    required this.semanticLabel,
  });

  static const double height = 150;
  static const double stickerHeight = 50;
  static const double _step = stickerHeight;
  static const _angles = [-0.12, 0.10, -0.06, 0.08, -0.04];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Center(
              child: _buildStickerStack(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickerStack() {
    final visible = stickers.take(_angles.length).toList();

    if (visible.length == 1) {
      return Transform.rotate(
        angle: _angles.first,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, 2),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      AppColors.shadow,
                      BlendMode.srcATop,
                    ),
                    child: visible.first,
                  ),
                ),
              ),
            ),
            visible.first,
          ],
        ),
      );
    }

    final totalWidth = stickerHeight + _step * (visible.length - 1);

    return SizedBox(
      width: totalWidth,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * _step,
              child: Transform.rotate(
                angle: _angles[i],
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: const Offset(0, 2),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              AppColors.shadow,
                              BlendMode.srcATop,
                            ),
                            child: visible[i],
                          ),
                        ),
                      ),
                    ),
                    visible[i],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
