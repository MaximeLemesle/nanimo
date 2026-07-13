import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/error_banner_widget.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/auth/presentation/widgets/sso_buttons_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _userNameController.addListener(_updateFormValidity);
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
    _confirmController.addListener(_updateFormValidity);
  }

  String? _userNameValidator(String? validation) {
    if (validation == null || validation.trim().isEmpty) {
      return 'Prénom requis';
    }
    if (validation.trim().length < 2) {
      return '2 caractères minimum';
    }
    return null;
  }

  String? _emailValidator(String? validation) =>
      validation == null || !validation.contains('@') ? 'Email invalide' : null;

  String? _passwordValidator(String? validation) {
    if (validation == null || validation.length < 6) {
      return '6 caractères minimum';
    }
    if (!RegExp(r'[0-9]').hasMatch(validation)) {
      return 'Ajouter au moins 1 chiffre';
    }
    return null;
  }

  String? _confirmValidator(String? validation) {
    if (validation == null || validation.isEmpty) {
      return 'Confirme ton mot de passe';
    }
    if (validation != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void _updateFormValidity() {
    final valid = _userNameValidator(_userNameController.text.trim()) == null &&
        _emailValidator(_emailController.text.trim()) == null &&
        _passwordValidator(_passwordController.text.trim()) == null &&
        _confirmValidator(_confirmController.text.trim()) == null;
    if (valid != _isFormValid) setState(() => _isFormValid = valid);
  }

  @override
  void dispose() {
    _userNameController.removeListener(_updateFormValidity);
    _emailController.removeListener(_updateFormValidity);
    _passwordController.removeListener(_updateFormValidity);
    _confirmController.removeListener(_updateFormValidity);
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _userNameController.text.trim(),
        );
  }

  void _onFieldChanged(String _) {
    context.read<AuthCubit>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Text('Inscription', style: textTheme.displayLarge),
                Text(
                  'Crée ton compte pour démarrer.',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFieldWidget(
                  controller: _userNameController,
                  label: 'Prénom',
                  hint: 'Entrez votre prénom',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: _onFieldChanged,
                  validator: _userNameValidator,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFieldWidget(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Entrez votre email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: _onFieldChanged,
                  validator: _emailValidator,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFieldWidget(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  hint: 'Entrez votre mot de passe',
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onChanged: _onFieldChanged,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFieldWidget(
                  controller: _confirmController,
                  label: 'Confirmation du mot de passe',
                  hint: 'Confirmer votre mot de passe',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onChanged: _onFieldChanged,
                  validator: _confirmValidator,
                ),
                const SizedBox(height: AppSpacing.xl),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.errorMessage != current.errorMessage,
                  builder: (context, state) {
                    if (state.errorMessage == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ErrorBannerWidget(message: state.errorMessage!),
                    );
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.isSubmitting != current.isSubmitting,
                  builder: (context, state) {
                    return ButtonWidget(
                      label: 'Créer mon compte',
                      onPressed: _onRegister,
                      isLoading: state.isSubmitting,
                      state: _isFormValid
                          ? ButtonState.normal
                          : ButtonState.disabled,
                      fullWidth: true,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Separator
                Row(
                  children: [
                    const Expanded(
                        child: Divider(color: AppColors.backgroundStroke)),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'ou',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const Expanded(
                        child: Divider(color: AppColors.backgroundStroke)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const SsoButtonsWidget(),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(RouteNames.login),
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: 'Déjà un compte ? '),
                          TextSpan(
                            text: 'Se connecter',
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
