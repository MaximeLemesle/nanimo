import 'package:flutter/material.dart';
import 'package:nanimo/config/app_environment.dart';

/// Marks every screen of a dev build, so the dev base is never mistaken for prod.
class EnvironmentBanner extends StatelessWidget {
  final AppEnvironment environment;
  final Widget child;

  const EnvironmentBanner({super.key, required this.environment, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!environment.isDev) return child;
    return Banner(
      message: 'DEV',
      location: BannerLocation.topStart,
      color: Colors.deepOrange,
      child: child,
    );
  }
}
