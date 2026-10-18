import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/health_showcase_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/trial_step_layout_widget.dart';

/// First screen after the first animal (NAN-113): the trial, before any price.
class TrialIntroPage extends StatefulWidget {
  const TrialIntroPage({super.key});

  @override
  State<TrialIntroPage> createState() => _TrialIntroPageState();
}

class _TrialIntroPageState extends State<TrialIntroPage> {
  @override
  void initState() {
    super.initState();
    analytics.capture(AnalyticsEvents.trialIntroViewed);
  }

  @override
  Widget build(BuildContext context) {
    return TrialStepLayoutWidget(
      title: const Text.rich(
        TextSpan(
          text: 'On veut que tu essaies ',
          children: [
            TextSpan(text: 'Nanimo', style: TextStyle(color: AppColors.primary)),
            TextSpan(text: ' gratuitement.'),
          ],
        ),
      ),
      visual: const HealthShowcaseWidget(),
      ctaLabel: 'Essaie Nanimo gratuitement',
      onContinue: () => context.push(RouteNames.trialReminder),
    );
  }
}
