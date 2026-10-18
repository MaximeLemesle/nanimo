import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/step_indicator_widget.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/health_showcase_widget.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/memories_showcase_widget.dart';
import 'package:nanimo/features/onboarding/presentation/widgets/showcase/reminders_showcase_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';

/// The welcome screen, then what Nanimo does before anything is typed
/// (NAN-114): health diary, memories, reminders, and the first pet.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const slideCount = 4;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pages = PageController();

  /// 0 is the welcome screen, 1 to [OnboardingPage.slideCount] the slides.
  int _stage = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int stage) {
    setState(() => _stage = stage);
    if (stage == 0) return;
    analytics.capture(AnalyticsEvents.onboardingSlideViewed, properties: {AnalyticsProperties.step: stage});
    if (_pages.hasClients) {
      _pages.animateToPage(stage - 1, duration: const Duration(milliseconds: 280), curve: Curves.easeInOut);
    }
  }

  void _next() {
    if (_stage < OnboardingPage.slideCount) {
      _goTo(_stage + 1);
      return;
    }
    context.go(RouteNames.createPet);
  }

  void _back() => _goTo(_stage - 1);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _stage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: _stage == 0 ? _welcome(context) : _slides()),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            'Nanimo',
            textAlign: TextAlign.center,
            style: textTheme.displayLarge?.copyWith(fontSize: 64),
          ),
          Text(
            'Chaque moment compte.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          ButtonWidget(label: 'Découvrir', onPressed: () => _goTo(1), fullWidth: true),
          TextButton(
            onPressed: () => context.go(RouteNames.login),
            child: Text(
              'J\'ai déjà un compte',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _slides() {
    final last = _stage == OnboardingPage.slideCount;
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _back,
              tooltip: 'Retour',
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.textPrimary,
            ),
            Expanded(child: StepIndicatorWidget(currentStep: _stage, totalSteps: OnboardingPage.slideCount)),
            const SizedBox(width: 48),
          ],
        ),
        Expanded(
          child: PageView(
            controller: _pages,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _Slide(
                title: Text('Le carnet de santé de ton animal, enfin complet et tout le temps avec toi !'),
                isLongTitle: true,
                visual: HealthShowcaseWidget(),
              ),
              _Slide(
                title: Text('Leur histoire mérite d\'être gardée.'),
                subtitle: 'Photos, moments, petites manies : tout reste rangé dans le temps.',
                visual: MemoriesShowcaseWidget(),
              ),
              _Slide(
                title: Text('Ne manque plus rien.'),
                subtitle: 'Nanimo te rappelle ses vaccins, ses rendez-vous et ce qui compte.',
                visual: RemindersShowcaseWidget(),
              ),
              _Slide(
                title: Text.rich(TextSpan(
                  text: 'Maintenant, ajoute ton premier ',
                  children: [TextSpan(text: 'Nanimo', style: TextStyle(color: AppColors.primary))],
                )),
                visual: PaywallMemoriesWidget(isAnimated: true),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ButtonWidget(label: last ? 'Commencer' : 'Continuer', onPressed: _next, fullWidth: true),
        ),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  final Widget title;
  final String? subtitle;
  final Widget visual;

  /// Steps down one title size so the visual keeps its room on an iPhone SE.
  final bool isLongTitle;

  const _Slide({required this.title, required this.visual, this.subtitle, this.isLongTitle = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            style: isLongTitle ? AppTextStyles.title03 : AppTextStyles.title02,
            child: title,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle!, textAlign: TextAlign.center, style: AppTextStyles.text.copyWith(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: AppSpacing.lg),
          Expanded(child: Center(child: visual)),
        ],
      ),
    );
  }
}
