import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';
import 'package:nanimo/features/subscription/presentation/widgets/trial_step_layout_widget.dart';

/// Removes the fear of being charged by surprise, and is the moment the
/// notification permission makes sense to the owner (NAN-113).
class TrialReminderPage extends StatefulWidget {
  const TrialReminderPage({super.key});

  @override
  State<TrialReminderPage> createState() => _TrialReminderPageState();
}

class _TrialReminderPageState extends State<TrialReminderPage> {
  @override
  void initState() {
    super.initState();
    analytics.capture(AnalyticsEvents.trialReminderViewed);
  }

  Future<void> _continue() async {
    if (await notificationPriming.permissionState() == NotificationPermissionState.undetermined) {
      await notificationPriming.accept();
    }
    if (!mounted) return;
    QuotaUpsell.openPaywall(context, PaywallTrigger.onboarding, onboarding: true);
  }

  @override
  Widget build(BuildContext context) {
    return TrialStepLayoutWidget(
      showBack: true,
      title: const Text('On te prévient 2 jours avant la fin de ton essai'),
      subtitle: 'Tant que les notifications sont activées',
      visual: const _Bell(),
      ctaLabel: 'Continuer gratuitement',
      onContinue: _continue,
    );
  }
}

class _Bell extends StatelessWidget {
  const _Bell();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: 240,
        child: Stack(
          children: [
            const Center(child: Icon(Icons.notifications_rounded, size: 220, color: AppColors.tertiary)),
            Positioned(
              right: 26,
              top: 18,
              child: Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.secondary600, shape: BoxShape.circle),
                child: Text('1', style: AppTextStyles.title02.copyWith(color: AppColors.textInvert)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
