import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/notifications/notification_benefits_page.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

/// Remembers a dismissal or completion for the current account.
abstract class FirstStepsStore {
  Future<bool> isDismissed();
  Future<void> dismiss();
}

class SharedPreferencesFirstStepsStore implements FirstStepsStore {
  final String? Function() _userId;

  SharedPreferencesFirstStepsStore({String? Function()? userId})
      : _userId = userId ?? (() => null);

  // Keep the current account's completion or dismissal separate from the
  // old device-wide flag, which could hide a different account's card.
  String get _key => 'first_steps_dismissed_v2:${_userId() ?? 'guest'}';

  @override
  Future<bool> isDismissed() async =>
      (await SharedPreferences.getInstance()).getBool(_key) ?? false;

  @override
  Future<void> dismiss() async =>
      (await SharedPreferences.getInstance()).setBool(_key, true);
}

class MemoryFirstStepsStore implements FirstStepsStore {
  bool dismissed;

  MemoryFirstStepsStore({this.dismissed = false});

  @override
  Future<bool> isDismissed() async => dismissed;

  @override
  Future<void> dismiss() async => dismissed = true;
}

/// Assigned in main. Hidden by default so screens that are not about it, and
/// their tests, are left as they were.
FirstStepsStore firstStepsStore = MemoryFirstStepsStore(dismissed: true);

enum FirstStep { profile, diary, reminders, memory }

/// "Premiers pas" (NAN-108): four steps, the first already ticked so the bar
/// never starts empty. Kept short on purpose, checklists average 19 % completion.
class HomeFirstStepsCardWidget extends StatefulWidget {
  /// The first animal, whose diary the second step fills (NAN-116).
  final String petName;
  final bool hasDiary;
  final bool hasMemory;
  final VoidCallback onCompleteDiary;
  final VoidCallback onAddMemory;
  final VoidCallback? onCompleted;

  const HomeFirstStepsCardWidget({
    super.key,
    required this.petName,
    required this.hasDiary,
    required this.hasMemory,
    required this.onCompleteDiary,
    required this.onAddMemory,
    this.onCompleted,
  });

  static String labelFor(FirstStep step, String petName) => switch (step) {
        FirstStep.profile => 'Premier Nanimo ajouté',
        FirstStep.diary => 'Compléter le carnet de $petName',
        FirstStep.reminders => 'Activer les rappels',
        FirstStep.memory => 'Ajouter un premier souvenir',
      };

  static void celebrate(BuildContext context) => Confetti.launch(context,
      options: const ConfettiOptions(
        particleCount: 90,
        spread: 80,
        y: 0.35,
        colors: [AppColors.primary, AppColors.secondary, AppColors.tertiary],
      ));

  @override
  State<HomeFirstStepsCardWidget> createState() =>
      _HomeFirstStepsCardWidgetState();
}

class _HomeFirstStepsCardWidgetState extends State<HomeFirstStepsCardWidget>
    with WidgetsBindingObserver {
  bool? _dismissed;
  NotificationPermissionState? _permission;
  Set<FirstStep>? _reported;

  /// The caches land a beat after the home: what is done by then is history.
  static const _settleDelay = Duration(seconds: 1);
  bool _settled = false;
  bool _completionPending = false;
  Timer? _settleTimer;

  /// Completed elsewhere (a diary, a memory): the card waits to be on screen,
  /// shows its last tick, folds away, then celebrates.
  bool _celebrationQueued = false;
  bool _collapsing = false;
  static const _showDoneDelay = Duration(milliseconds: 800);
  static const _collapseDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationPriming.permission.addListener(_permissionChanged);
    _load();
  }

  @override
  void dispose() {
    notificationPriming.permission.removeListener(_permissionChanged);
    _settleTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Coming back from the system prompt or the phone settings.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshPermission();
  }

  Future<void> _load() async {
    final dismissed = await firstStepsStore.isDismissed();
    final permission = await notificationPriming.permissionState();
    if (!mounted) return;
    setState(() {
      _dismissed = dismissed;
      _permission = permission;
    });
    _sync();
    _settleTimer = Timer(_settleDelay, () => _settled = true);
  }

  void _permissionChanged() {
    if (!mounted) return;
    setState(() => _permission = notificationPriming.permission.value);
    _sync();
  }

  Future<void> _refreshPermission() async {
    final permission = await notificationPriming.permissionState();
    if (!mounted) return;
    setState(() => _permission = permission);
    _sync();
  }

  @override
  void didUpdateWidget(HomeFirstStepsCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  Set<FirstStep> get _done => {
        FirstStep.profile,
        if (widget.hasDiary) FirstStep.diary,
        if (_permission == NotificationPermissionState.granted)
          FirstStep.reminders,
        if (widget.hasMemory) FirstStep.memory,
      };

  /// Reports each step the first time it flips to done,
  /// then celebrates and retires the completed card. The first look is a baseline.
  void _sync() {
    if (_dismissed != false || _permission == null) return;
    final done = _done;
    final reported = _reported;
    if (reported != null && _settled) {
      for (final step in done.difference(reported)) {
        analytics.capture(AnalyticsEvents.checklistItemCompleted,
            properties: {AnalyticsProperties.item: step.name});
      }
    }
    _reported = done;
    if (done.length == FirstStep.values.length && !_completionPending) {
      _completionPending = true;
      final celebrate =
          _settled && reported != null && reported.length < done.length;
      if (celebrate) {
        _celebrationQueued = true;
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _dismiss();
      });
    }
  }

  Future<void> _celebrate() async {
    await Future<void>.delayed(_showDoneDelay);
    if (!mounted) return;
    setState(() => _collapsing = true);
    await Future<void>.delayed(_collapseDuration);
    if (!mounted) return;
    if (widget.onCompleted case final completed?) {
      completed();
    } else {
      HomeFirstStepsCardWidget.celebrate(context);
    }
    _dismiss();
  }

  void _dismiss() {
    firstStepsStore.dismiss();
    if (mounted) setState(() => _dismissed = true);
  }

  Future<void> _onReminders() async {
    final denied = _permission == NotificationPermissionState.denied;
    if (!await NotificationBenefitsPage.show(context, openSettings: denied)) {
      return;
    }
    if (denied) {
      await notificationPriming.openSystemSettings();
      return;
    }
    await notificationPriming.accept();
    await _refreshPermission();
  }

  VoidCallback? _actionFor(FirstStep step) => switch (step) {
        FirstStep.profile => null,
        FirstStep.diary => widget.onCompleteDiary,
        FirstStep.reminders => _onReminders,
        FirstStep.memory => widget.onAddMemory,
      };

  @override
  Widget build(BuildContext context) {
    /// False while another page covers the home: rebuilds when it comes back.
    final isOnScreen = TickerMode.valuesOf(context).enabled;
    if (_dismissed != false || _permission == null) {
      return const SizedBox.shrink();
    }
    if (_celebrationQueued && isOnScreen) {
      _celebrationQueued = false;
      _celebrate();
    }
    final done = _done;

    return AnimatedSize(
      duration: _collapseDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        duration: _collapseDuration,
        opacity: _collapsing ? 0 : 1,
        child: _collapsing ? const SizedBox(width: double.infinity) : _card(done),
      ),
    );
  }

  Widget _card(Set<FirstStep> done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: RoundedBorderWidget(
        borderColor: AppColors.backgroundStroke,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('Premiers pas', style: AppTextStyles.title03)),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                  tooltip: 'Masquer',
                  onPressed: _dismiss,
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: done.length / FirstStep.values.length,
                minHeight: 6,
                color: AppColors.primary,
                backgroundColor: AppColors.backgroundStroke,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final step in FirstStep.values)
              _StepRow(
                label: HomeFirstStepsCardWidget.labelFor(step, widget.petName),
                isDone: done.contains(step),
                onTap: done.contains(step) ? null : _actionFor(step),
              ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String label;
  final bool isDone;
  final VoidCallback? onTap;

  const _StepRow({required this.label, required this.isDone, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(
              isDone
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              color: isDone ? AppColors.primary600 : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: isDone
                    ? AppTextStyles.text.copyWith(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      )
                    : AppTextStyles.textBold,
              ),
            ),
            if (!isDone && onTap != null)
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
