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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthCubit>().clearError();
    });
  }

  String? _emailValidator(String? validation) => validation == null || !validation.contains('@') ? 'Email invalide' : null;

  String? _passwordValidator(String? validation) {
    if (validation == null || validation.length < 6) {
      return '6 caractères minimum';
    }
    if (!RegExp(r'[0-9]').hasMatch(validation)) {
      return 'Ajouter au moins 1 chiffre';
    }
    return null;
  }

  void _updateFormValidity() {
    final valid = _emailValidator(_emailController.text.trim()) == null && _passwordValidator(_passwordController.text.trim()) == null;
    if (valid != _isFormValid) setState(() => _isFormValid = valid);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateFormValidity);
    _passwordController.removeListener(_updateFormValidity);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
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
                Text('Connexion', style: textTheme.displayLarge),
                Text(
                  'Heureux de te revoir.',
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
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
                  textInputAction: TextInputAction.done,
                  onChanged: _onFieldChanged,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: AppSpacing.xl),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) => previous.errorMessage != current.errorMessage,
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
                  buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
                  builder: (context, state) {
                    return ButtonWidget(
                      label: 'Se connecter',
                      onPressed: _onLogin,
                      isLoading: state.isSubmitting,
                      state: _isFormValid ? ButtonState.normal : ButtonState.disabled,
                      fullWidth: true,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Separator
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.backgroundStroke)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'ou',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.backgroundStroke)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                /// Apple and Google button
                const SsoButtonsWidget(),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(RouteNames.signup),
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: 'Pas encore de compte ? '),
                          TextSpan(
                            text: "S'inscrire",
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
