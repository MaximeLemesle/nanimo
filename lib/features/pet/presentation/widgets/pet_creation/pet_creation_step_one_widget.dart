import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/nanimo_text_field_widget.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_attribute_selector/pet_species_selector_widget.dart';

class PetCreationStepOneWidget extends StatefulWidget {
  const PetCreationStepOneWidget({super.key});

  @override
  State<PetCreationStepOneWidget> createState() =>
      _PetCreationStepOneWidgetState();
}

class _PetCreationStepOneWidgetState extends State<PetCreationStepOneWidget> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final initial = context.read<OnboardingCubit>().state.petName;
    _nameController = TextEditingController(text: initial);
    _fetchSpecies();
  }

  void _fetchSpecies() {
    final cubit = context.read<OnboardingCubit>();
    if (cubit.state.speciesStatus == ReferentialStatus.idle ||
        cubit.state.speciesStatus == ReferentialStatus.error) {
      cubit.fetchSpecies();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Faisons connaissance',
            style: textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          NanimoTextFieldWidget(
            controller: _nameController,
            label: 'Quel est le nom de ton animal ?',
            hint: 'Saïko...',
            textInputAction: TextInputAction.done,
            onChanged: (value) =>
                context.read<OnboardingCubit>().setPetName(value),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PetSpeciesSelectorWidget(),
        ],
      ),
    );
  }
}
