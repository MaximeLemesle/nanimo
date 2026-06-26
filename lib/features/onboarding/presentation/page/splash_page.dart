import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nanimo/config/theme/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('splash_page'),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animation/logo_animation.json',
              height: 120,
              repeat: true,
              frameRate: FrameRate(60),
              renderCache: RenderCache.raster,
            ),
          ],
        ),
      ),
    );
  }
}
