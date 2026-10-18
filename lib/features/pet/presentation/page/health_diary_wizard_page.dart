import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/notifications/diary_follow_up_store.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/date_time_field_widget.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/core/widgets/step_indicator_widget.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/chip_number_field_widget.dart';

typedef _Vaccine = ({String name, DateTime? lastDate, DateTime? nextDate, int recurrence});
typedef _Visit = ({String title, DateTime visitedAt, String? vetName, String? clinicName});

/// The health diary filled the way a pet is created (NAN-116): one question
/// per screen, nothing saved until « Valider le carnet », then a celebration.
class HealthDiaryWizardPage extends StatefulWidget {
  final String petId;

  const HealthDiaryWizardPage({super.key, required this.petId});

  static const questionSteps = 4;

  @override
  State<HealthDiaryWizardPage> createState() => _HealthDiaryWizardPageState();
}

class _HealthDiaryWizardPageState extends State<HealthDiaryWizardPage> {
  final PageController _pages = PageController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _chip = TextEditingController();

  int _step = 1;
  bool? _isSterilized;
  DateTime? _sterilizedAt;
  bool? _isChipped;
  final List<_Vaccine> _vaccines = [];
  final List<DateTime> _dewormings = [];
  final List<_Visit> _visits = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    context.read<PetDetailsCubit>().selectPet(widget.petId);
  }

  @override
  void dispose() {
    _pages.dispose();
    _weight.dispose();
    _chip.dispose();
    super.dispose();
  }


  PetModel? _petOf(List<PetModel> pets) {
    for (final pet in pets) {
      if (pet.petId == widget.petId) return pet;
    }
    return null;
  }

  void _goTo(int step) {
    setState(() => _step = step);
    _pages.animateToPage(step - 1, duration: const Duration(milliseconds: 280), curve: Curves.easeInOut);
  }

  void _back() {
    if (_step == 1) {
      context.pop();
      return;
    }
    _goTo(_step - 1);
  }

  Future<void> _validate() async {
    setState(() => _saving = true);
    final dewormings = [..._dewormings]..sort();
    final birthdate = _petOf(context.read<PetDetailsCubit>().state.pets)?.birthdate;
    await context.read<PetDetailsCubit>().createHealthDiary(
          birthWeight: WeightFormatter.parseWeight(_weight.text),
          birthWeightDate: birthdate,
          isSterilized: _isSterilized,
          sterilizedAt: _sterilizedAt,
          isChipped: _isChipped,
          chipNumber: _isChipped == true && _chip.text.trim().isNotEmpty ? _chip.text.trim() : null,
          lastDeworming: dewormings.isEmpty ? null : dewormings.last,
          vaccines: _vaccines,
          vetVisits: _visits,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    _goTo(5);
  }

  /// Schedules the follow-up, then moves on: the step is put off, not lost.
  Future<void> _remindLater(DiaryFollowUpTopic topic) async {
    final now = DateTime.now();
    final at = await BottomSheetWidget.show<DateTime>(
      context,
      _RemindLaterSheet(initial: DateTime(now.year, now.month, now.day + 1, 18)),
    );
    if (at == null || !mounted) return;
    if (await notificationPriming.permissionState() == NotificationPermissionState.undetermined) {
      await notificationPriming.accept();
    }
    await diaryFollowUpStore.add(DiaryFollowUp(petId: widget.petId, topic: topic, at: at));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text('On te le rappellera le ${DateFormatter.date(at)} à ${DateFormatter.time(at)}.'),
      ));
    if (topic == DiaryFollowUpTopic.vaccines) {
      _goTo(4);
    } else {
      await _validate();
    }
  }

  Future<void> _addVaccine(DateTime birthdate) async {
    _Vaccine? created;
    await BottomSheetWidget.show<void>(
      context,
      AddVaccineBottomSheetWidget(
        birthdate: birthdate,
        onSubmit: ({required String vaccineName, DateTime? lastDate, DateTime? nextDate, required int recurrence, String? petId}) {
          created = (name: vaccineName, lastDate: lastDate, nextDate: nextDate, recurrence: recurrence);
        },
      ),
    );
    final vaccine = created;
    if (vaccine != null && mounted) setState(() => _vaccines.add(vaccine));
  }

  Future<void> _addDeworming(DateTime birthdate) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: birthdate,
      lastDate: now,
      helpText: 'Date du vermifuge',
    );
    if (date != null && mounted) setState(() => _dewormings.add(date));
  }

  Future<void> _addVisit(DateTime birthdate) async {
    _Visit? created;
    await BottomSheetWidget.show<void>(
      context,
      AddVetVisitBottomSheetWidget(
        birthdate: birthdate,
        onSubmit: ({required String title, required DateTime visitedAt, String? vetName, String? clinicName, String? petId}) {
          created = (title: title, visitedAt: visitedAt, vetName: vetName, clinicName: clinicName);
        },
      ),
    );
    final visit = created;
    if (visit != null && mounted) setState(() => _visits.add(visit));
  }

  @override
  Widget build(BuildContext context) {
    final pet = _petOf(context.watch<PetDetailsCubit>().state.pets);
    if (pet == null) return const Scaffold(backgroundColor: AppColors.background);
    final celebrating = _step > HealthDiaryWizardPage.questionSteps;

    return PopScope(
      canPop: _step == 1 || celebrating,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              if (!celebrating)
                Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      tooltip: 'Retour',
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppColors.textPrimary,
                    ),
                    Expanded(
                      child: StepIndicatorWidget(currentStep: _step, totalSteps: HealthDiaryWizardPage.questionSteps),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _weightStep(pet),
                    _neuteringStep(pet),
                    _vaccinesStep(pet),
                    _visitsStep(pet),
                    _DiaryCreated(
                      pet: pet,
                      portrait: context.read<PetDetailsCubit>().state.portraits[pet.petId],
                      isShown: celebrating,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    if (_step == 3 || _step == 4)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ButtonWidget(
                          label: 'Me le rappeler plus tard',
                          type: ButtonType.secondary,
                          icon: Icons.notifications_none_rounded,
                          iconPosition: ButtonIcon.left,
                          fullWidth: true,
                          onPressed: () => _remindLater(
                            _step == 3 ? DiaryFollowUpTopic.vaccines : DiaryFollowUpTopic.vetVisits,
                          ),
                        ),
                      ),
                    ButtonWidget(
                      label: switch (_step) {
                        4 => 'Valider le carnet',
                        5 => 'Voir le carnet',
                        _ => 'Continuer',
                      },
                      fullWidth: true,
                      isLoading: _saving,
                      onPressed: _saving ? null : () => _onPrimary(pet),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPrimary(PetModel pet) {
    switch (_step) {
      case 4:
        _validate();
      case 5:
        /// The caller, inside the shell, opens the diary it owns.
        context.pop(true);
      default:
        _goTo(_step + 1);
    }
  }

  Widget _weightStep(PetModel pet) {
    final weighed = pet.gender == Gender.female ? 'pesée' : 'pesé';
    return _Question(
      title: 'Poids de ${pet.petName} à sa naissance',
      children: [
        Text('Le ${DateFormatter.date(pet.birthdate)}, $weighed :', style: AppTextStyles.textBold),
        const SizedBox(height: AppSpacing.sm),
        TextFieldWidget(
          controller: _weight,
          label: null,
          hint: '0,0',
          suffixText: 'kg',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        ),
      ],
    );
  }

  Widget _neuteringStep(PetModel pet) {
    final neutered = switch (pet.gender) {
      Gender.male => 'castré',
      Gender.female => 'stérilisée',
      Gender.unknown => 'stérilisé',
    };
    final chipped = pet.gender == Gender.female ? 'est-elle pucée' : 'est-il pucé';
    return _Question(
      title: 'Est-ce que ${pet.petName} est $neutered ?',
      children: [
        _YesNo(value: _isSterilized, onChanged: (v) => setState(() => _isSterilized = v)),
        if (_isSterilized == true) ...[
          const SizedBox(height: AppSpacing.md),
          DateFieldWidget(
            label: pet.gender == Gender.male ? 'Date de la castration' : 'Date de la stérilisation',
            value: _sterilizedAt,
            firstDate: pet.birthdate,
            lastDate: DateTime.now(),
            onChanged: (date) => setState(() => _sterilizedAt = date),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text('Et ${pet.petName}, $chipped ?', style: AppTextStyles.title03),
        const SizedBox(height: AppSpacing.md),
        _YesNo(value: _isChipped, onChanged: (v) => setState(() => _isChipped = v)),
        if (_isChipped == true) ...[
          const SizedBox(height: AppSpacing.md),
          ChipNumberFieldWidget(controller: _chip, onChanged: () => setState(() {})),
        ],
      ],
    );
  }

  Widget _vaccinesStep(PetModel pet) {
    return _Question(
      title: 'Ses vaccins et ses vermifuges',
      subtitle: 'Ajoute ceux que tu connais, on te rappellera les prochains.',
      children: [
        Text('Vaccins', style: AppTextStyles.textBold),
        for (final vaccine in _vaccines)
          _Entry(
            label: vaccine.name,
            detail: vaccine.lastDate != null
                ? 'Fait le ${DateFormatter.date(vaccine.lastDate!)}'
                : vaccine.nextDate != null
                    ? 'Prévu le ${DateFormatter.date(vaccine.nextDate!)}'
                    : null,
            onRemove: () => setState(() => _vaccines.remove(vaccine)),
          ),
        _AddButton(label: 'Ajouter un vaccin', onPressed: () => _addVaccine(pet.birthdate)),
        const SizedBox(height: AppSpacing.lg),
        Text('Vermifuges', style: AppTextStyles.textBold),
        for (final date in _dewormings)
          _Entry(
            label: 'Vermifuge',
            detail: 'Le ${DateFormatter.date(date)}',
            onRemove: () => setState(() => _dewormings.remove(date)),
          ),
        _AddButton(label: 'Ajouter un vermifuge', onPressed: () => _addDeworming(pet.birthdate)),
      ],
    );
  }

  Widget _visitsStep(PetModel pet) {
    return _Question(
      title: 'Ses visites chez le vétérinaire',
      subtitle: 'Les passées comme celles à venir.',
      children: [
        for (final visit in _visits)
          _Entry(
            label: visit.title,
            detail: DateFormatter.date(visit.visitedAt),
            onRemove: () => setState(() => _visits.remove(visit)),
          ),
        _AddButton(label: 'Ajouter une visite', onPressed: () => _addVisit(pet.birthdate)),
      ],
    );
  }
}

class _Question extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _Question({required this.title, required this.children, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.title02),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: AppTextStyles.text.copyWith(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}

class _YesNo extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool> onChanged;

  const _YesNo({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        ChipWidget(label: 'Oui', isSelected: value == true, onTap: () => onChanged(true)),
        ChipWidget(label: 'Non', isSelected: value == false, onTap: () => onChanged(false)),
      ],
    );
  }
}

class _Entry extends StatelessWidget {
  final String label;
  final String? detail;
  final VoidCallback onRemove;

  const _Entry({required this.label, required this.onRemove, this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary600, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.text),
                if (detail != null)
                  Text(detail!, style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            tooltip: 'Retirer',
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AddButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: AppColors.primary),
        label: Text(label, style: AppTextStyles.textBold.copyWith(color: AppColors.primary)),
      ),
    );
  }
}

/// Date and time of the follow-up, pops with the chosen moment.
class _RemindLaterSheet extends StatefulWidget {
  final DateTime initial;

  const _RemindLaterSheet({required this.initial});

  @override
  State<_RemindLaterSheet> createState() => _RemindLaterSheetState();
}

class _RemindLaterSheetState extends State<_RemindLaterSheet> {
  late DateTime _at = widget.initial;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BottomSheetWidget(
      title: 'Quand veux-tu qu\'on te le rappelle ?',
      action: ButtonWidget(
        label: 'Programmer le rappel',
        fullWidth: true,
        onPressed: _at.isAfter(now) ? () => Navigator.of(context).pop(_at) : null,
      ),
      children: [
        DateTimeFieldWidget(
          value: _at,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
          onDateChanged: (date) => setState(() => _at = DateTime(date.year, date.month, date.day, _at.hour, _at.minute)),
          onTimeChanged: (time) => setState(() => _at = DateTime(_at.year, _at.month, _at.day, time.hour, time.minute)),
        ),
      ],
    );
  }
}

/// Last screen: the diary drawn as a booklet with the pet on its cover.
class _DiaryCreated extends StatefulWidget {
  final PetModel pet;
  final PetPortrait? portrait;
  final bool isShown;

  const _DiaryCreated({required this.pet, required this.portrait, required this.isShown});

  @override
  State<_DiaryCreated> createState() => _DiaryCreatedState();
}

class _DiaryCreatedState extends State<_DiaryCreated> {
  static const _colors = [AppColors.primary, AppColors.secondary, AppColors.tertiary, AppColors.primary300];
  bool _celebrated = false;

  @override
  void didUpdateWidget(_DiaryCreated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShown && !_celebrated) {
      _celebrated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        for (final (angle, x) in const [(60.0, 0.0), (120.0, 1.0)]) {
          Confetti.launch(
            context,
            options: ConfettiOptions(particleCount: 60, angle: angle, spread: 55, x: x, y: 0.7, colors: _colors),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Booklet(portrait: widget.portrait, petName: widget.pet.petName),
          const SizedBox(height: AppSpacing.xl),
          Text('Le carnet de ${widget.pet.petName} est créé !', textAlign: TextAlign.center, style: AppTextStyles.title02),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tout ce qui compte pour sa santé est maintenant au même endroit.',
            textAlign: TextAlign.center,
            style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Booklet extends StatelessWidget {
  final PetPortrait? portrait;
  final String petName;

  const _Booklet({required this.portrait, required this.petName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 232,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.sm),
          bottomLeft: Radius.circular(AppRadius.sm),
          topRight: Radius.circular(AppRadius.lg),
          bottomRight: Radius.circular(AppRadius.lg),
        ),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 12))],
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            decoration: const BoxDecoration(
              color: AppColors.primary700,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                bottomLeft: Radius.circular(AppRadius.sm),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(color: AppColors.backgroundSurface, shape: BoxShape.circle),
                  child: SizedBox.square(
                    dimension: PetAvatarSize.medium.dimension,
                    child: portrait == null
                        ? const Icon(Icons.pets_rounded, color: AppColors.primary, size: 48)
                        : PetAvatarWidget(portrait: portrait!, size: PetAvatarSize.medium),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Carnet de santé', style: AppTextStyles.textSmallBold.copyWith(color: AppColors.textInvert)),
                Text(
                  petName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title03.copyWith(color: AppColors.textInvert),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
