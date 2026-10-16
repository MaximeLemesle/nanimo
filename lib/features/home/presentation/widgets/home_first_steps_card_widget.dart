import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

/// Remembers that the card is gone for good, done or dismissed.
abstract class FirstStepsStore {
  Future<bool> isDismissed();
  Future<void> dismiss();
}

class SharedPreferencesFirstStepsStore implements FirstStepsStore {
  static const _key = 'first_steps_dismissed';

  @override
  Future<bool> isDismissed() async => (await SharedPreferences.getInstance()).getBool(_key) ?? false;

  @override
  Future<void> dismiss() async => (await SharedPreferences.getInstance()).setBool(_key, true);
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

enum FirstStep { profile, vaccine, reminders, memory }

/// "Premiers pas" (NAN-108): four steps, the first already ticked so the bar
/// never starts empty. Kept short on purpose, checklists average 19 % completion.
class HomeFirstStepsCardWidget extends StatefulWidget {
  final bool hasVaccine;
  final bool hasMemory;
  final VoidCallback onAddVaccine;
  final VoidCallback onAddMemory;

  const HomeFirstStepsCardWidget({
    super.key,
    required this.hasVaccine,
    required this.hasMemory,
    required this.onAddVaccine,
    required this.onAddMemory,
  });

  static const labels = {
    FirstStep.profile: 'Profil créé',
    FirstStep.vaccine: 'Ajouter un vaccin',
    FirstStep.reminders: 'Activer les rappels',
    FirstStep.memory: 'Ajouter un premier souvenir',
  };

  @override
  State<HomeFirstStepsCardWidget> createState() => _HomeFirstStepsCardWidgetState();
}

class _HomeFirstStepsCardWidgetState extends State<HomeFirstStepsCardWidget> with WidgetsBindingObserver {
  bool? _dismissed;
  NotificationPermissionState? _permission;
  Set<FirstStep>? _reported;

  /// The caches land a beat after the home: what is done by then is history.
  static const _settleDelay = Duration(seconds: 1);
  bool _settled = false;
  Timer? _settleTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
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
        if (widget.hasVaccine) FirstStep.vaccine,
        if (_permission == NotificationPermissionState.granted) FirstStep.reminders,
        if (widget.hasMemory) FirstStep.memory,
      };

  /// Reports each step the first time it flips to done, and retires the card
  /// once all four are done. The first look is a baseline, not news.
  void _sync() {
    if (_dismissed != false || _permission == null) return;
    final done = _done;
    final reported = _reported;
    if (reported != null && _settled) {
      for (final step in done.difference(reported)) {
        analytics.capture(AnalyticsEvents.checklistItemCompleted, properties: {AnalyticsProperties.item: step.name});
      }
    }
    _reported = done;
    if (done.length == FirstStep.values.length) _dismiss();
  }

  void _dismiss() {
    firstStepsStore.dismiss();
    if (mounted) setState(() => _dismissed = true);
  }

  Future<void> _onReminders() async {
    if (_permission == NotificationPermissionState.denied) {
      await notificationPriming.openSystemSettings();
      return;
    }
    await notificationPriming.accept();
    await _refreshPermission();
  }

  VoidCallback? _actionFor(FirstStep step) => switch (step) {
        FirstStep.profile => null,
        FirstStep.vaccine => widget.onAddVaccine,
        FirstStep.reminders => _onReminders,
        FirstStep.memory => widget.onAddMemory,
      };

  @override
  Widget build(BuildContext context) {
    if (_dismissed != false || _permission == null) return const SizedBox.shrink();
    final done = _done;
    if (done.length == FirstStep.values.length) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: RoundedBorderWidget(
        borderColor: AppColors.backgroundStroke,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text('Premiers pas', style: AppTextStyles.title03)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
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
                label: HomeFirstStepsCardWidget.labels[step]!,
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
              isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
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
            if (!isDone && onTap != null) const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
