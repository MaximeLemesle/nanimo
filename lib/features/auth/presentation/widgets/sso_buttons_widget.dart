import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';

/// Stack of SSO buttons (Apple on iOS, Google everywhere)
class SsoButtonsWidget extends StatelessWidget {
  const SsoButtonsWidget({super.key});

  bool get _showApple => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        final disabled = state.isSubmitting;
        return Column(
          children: [
            if (_showApple) ...[
              SignInWithAppleButton(
                text: 'Continuer avec Apple',
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                onPressed:
                    disabled ? null : context.read<AuthCubit>().loginWithApple,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            _SignInWithGoogleButton(
              text: 'Continuer avec Google',
              onPressed: () => context.read<AuthCubit>().loginWithGoogle(),
            ),
          ],
        );
      },
    );
  }
}

class _SignInWithGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height = 44;

  const _SignInWithGoogleButton({
    required this.onPressed,
    this.text = 'Sign in with Google',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F1F1F),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Color(0xFF747775), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/google_logo.svg',
              height: 20,
              width: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: height * 0.4,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
