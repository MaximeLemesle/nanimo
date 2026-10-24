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

/// The welcome screen, then what Nanimo does before anything is typed
/// (NAN-114): swipe through health, multiple pets, memories and reminders.
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
    if (stage == 0) {
      setState(() => _stage = 0);
      return;
    }
    if (_stage == 0) {
      setState(() => _stage = 1);
      _trackSlide(1);
    } else {
      _pages.animateToPage(stage - 1, duration: const Duration(milliseconds: 280), curve: Curves.easeInOut);
    }
  }

  void _trackSlide(int stage) => analytics.capture(
        AnalyticsEvents.onboardingSlideViewed,
        properties: {AnalyticsProperties.step: stage},
      );

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
            onPageChanged: (index) {
              setState(() => _stage = index + 1);
              _trackSlide(index + 1);
            },
            children: const [
              _Slide(title: Text('Le carnet de santé de ton animal !'), visual: _SlideImage('health')),
              _Slide(title: Text('Tout tes animaux au même endroit !'), visual: _SlideImage('multi_pet', scale: 1.10)),
              _Slide(title: Text('Ajoute tous tes souvenirs.'), visual: _SlideImage('memories', scale: 1.20)),
              _Slide(title: Text("N'oublie plus rien !"), visual: _SlideImage('reminders')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SizedBox(
              height: 52,
              child: _stage == OnboardingPage.slideCount
                  ? ButtonWidget(label: 'Continuer', fullWidth: true, onPressed: () => context.go(RouteNames.createPet))
                  : ButtonWidget(
                      label: 'Suivant',
                      type: ButtonType.secondary,
                      fullWidth: true,
                      onPressed: () => _goTo(_stage + 1),
                    )),
        ),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  final Widget title;
  final Widget visual;

  const _Slide({required this.title, required this.visual});

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
            style: AppTextStyles.title02,
            child: title,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(child: Center(child: visual)),
        ],
      ),
    );
  }
}

/// Fits the supplied artwork in full within the space left by the title.
class _SlideImage extends StatelessWidget {
  final String name;

  /// Above 1 the artwork spills past the side margins. Anchored a little low
  /// so it grows into the gap under the title, not past the page bottom.
  final double scale;

  const _SlideImage(this.name, {this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Transform.scale(
        scale: scale,
        alignment: const Alignment(0, 0.1),
        child: Image.asset('assets/onboarding/$name.png', fit: BoxFit.contain),
      ),
    );
  }
}
