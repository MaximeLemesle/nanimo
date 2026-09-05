import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/gender_formatter.dart';
import 'package:nanimo/core/widgets/app_scaffold.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/nanimo_text_field_widget.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/edit_pet_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/grid_tile_widget.dart';

class EditPetPage extends StatefulWidget {
  const EditPetPage({super.key});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  static const _genderOptions = [Gender.female, Gender.male];

  final TextEditingController _nameController = TextEditingController();
  String? _raceId;
  Gender? _gender;
  DateTime? _birthdate;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  /// Prefills the form from the loaded pet
  void _seedFromPet(PetModel pet) {
    _seeded = true;
    _raceId = pet.petRaceId.isEmpty ? null : pet.petRaceId;
    _gender = pet.gender == Gender.unknown ? null : pet.gender;
    _birthdate = pet.birthdate;
    _nameController.removeListener(_onNameChanged);
    _nameController.text = pet.petName;
    _nameController.addListener(_onNameChanged);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    var picked = _birthdate ?? now;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: SizedBox(
          height: 350,
          width: double.infinity,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            initialDateTime: picked,
            minimumDate: DateTime(now.year - 40),
            maximumDate: now,
            onDateTimeChanged: (date) => picked = date,
          ),
        ),
      ),
    );

    if (!mounted) return;
    setState(() => _birthdate = picked);
  }

  String _deletionWarning(String petName, int eventCount) {
    if (eventCount == 0) {
      return 'Es-tu vraiment sûr de vouloir supprimer $petName ?';
    }
    if (eventCount == 1) {
      return 'Tu as 1 souvenir avec $petName, es-tu sûr de vouloir le supprimer ?';
    }
    return 'Tu as $eventCount souvenirs avec $petName, es-tu sûr de vouloir le supprimer ?';
  }

  Future<void> _confirmAndDelete(BuildContext context, PetModel pet) async {
    final cubit = context.read<EditPetCubit>();
    final eventCount = cubit.state.eventCount;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundSurface,
        title: Text('Supprimer ${pet.petName} ?', style: AppTextStyles.title03),
        content: Text(
          _deletionWarning(pet.petName, eventCount),
          style: AppTextStyles.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Annuler',
              style: AppTextStyles.textBold.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Supprimer',
              style: AppTextStyles.textBold.copyWith(color: AppColors.secondary600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditPetCubit, EditPetState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditPetStatus.success || state.status == EditPetStatus.deleted) {
          context.pop();
        } else if (state.status == EditPetStatus.error && state.error != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        if (!state.isLoaded) {
          return const AppScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final pet = state.pet!;
        if (!_seeded) _seedFromPet(pet);

        final isSaving = state.status == EditPetStatus.loading;
        final isDeleting = state.status == EditPetStatus.deleting;
        final busy = isSaving || isDeleting;
        final canSubmit = !busy && _nameController.text.trim().length >= 2 && _raceId != null && _gender != null && _birthdate != null;

        return AppScaffold(
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.bottomBarInset,
            ),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.textPrimary,
                    tooltip: 'Retour',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text('Modifier', style: AppTextStyles.title02),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _SpeciesRow(state: state),
              const SizedBox(height: AppSpacing.lg),
              NanimoTextFieldWidget(
                controller: _nameController,
                label: 'Son nom',
                hint: 'Saïko...',
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel('Sa race'),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                isExpanded: true,
                menuMaxHeight: 300,
                initialValue: _raceId,
                hint: Text(
                  'Choisis une race',
                  style: AppTextStyles.title03.copyWith(color: AppColors.textSecondary),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                dropdownColor: AppColors.backgroundSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundSurface,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(
                      color: AppColors.backgroundStroke,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                items: [
                  for (final race in state.races)
                    DropdownMenuItem<String>(
                      value: race.petRaceId,
                      child: Text(race.raceName),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _raceId = value);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel('Son sexe'),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (final gender in _genderOptions) ...[
                    Expanded(
                      child: SizedBox(
                        height: 72,
                        child: GridTileWidget(
                          label: GenderFormatter.label(gender),
                          isSelected: _gender == gender,
                          onTap: () => setState(() => _gender = gender),
                        ),
                      ),
                    ),
                    if (gender != _genderOptions.last) const SizedBox(width: AppSpacing.md),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel('Sa date de naissance'),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: _pickBirthdate,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: _birthdate != null ? AppColors.primary : AppColors.backgroundStroke,
                      width: _birthdate != null ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: _birthdate != null ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _birthdate != null ? _formatDate(_birthdate!) : 'Sélectionner une date',
                        style: AppTextStyles.text.copyWith(
                          color: _birthdate != null ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ButtonWidget(
                label: 'Enregistrer',
                fullWidth: true,
                isLoading: isSaving,
                state: canSubmit ? ButtonState.normal : ButtonState.disabled,
                onPressed: () {
                  context.read<EditPetCubit>().submit(
                        petName: _nameController.text,
                        petRaceId: _raceId!,
                        gender: _gender!,
                        birthdate: _birthdate!,
                      );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              ButtonWidget(
                label: 'Supprimer',
                type: ButtonType.delete,
                fullWidth: true,
                isLoading: isDeleting,
                state: busy ? ButtonState.disabled : ButtonState.normal,
                onPressed: () => _confirmAndDelete(context, pet),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
    );
  }
}

class _SpeciesRow extends StatelessWidget {
  final EditPetState state;

  const _SpeciesRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final portrait = state.portrait;

    return Row(
      children: [
        if (portrait != null)
          SizedBox(
            height: 56,
            child: SpeciesIconWidget(portrait: portrait, height: 56),
          ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Son espèce',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
              ),
              Text(state.speciesName ?? '—', style: AppTextStyles.title03),
            ],
          ),
        ),
      ],
    );
  }
}
