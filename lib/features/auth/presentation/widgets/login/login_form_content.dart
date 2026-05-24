import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../cubit/auth_cubit.dart';
import '../forgot_password_dialog.dart';
import 'login_social_button.dart';

class LoginFormContent extends StatelessWidget {
  const LoginFormContent({
    super.key,
    required this.formKey,
    required this.identityController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController identityController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.loginTitle,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            AppStrings.loginSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          AppTextField(
            controller: identityController,
            label: AppStrings.loginEmailLabel,
            hintText: AppStrings.loginEmailHint,
            prefixIcon: LucideIcons.user,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => showForgotPasswordDialog(context, identityController.text),
              child: Text(
                AppStrings.loginForgotPassword,
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          AppTextField(
            controller: passwordController,
            label: AppStrings.loginPasswordLabel,
            hintText: AppStrings.loginPasswordHint,
            prefixIcon: LucideIcons.lock,
            obscureText: obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) return AppStrings.validationRequired;
              return null;
            },
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                size: AppDimensions.iconDefault,
                color: colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (p, n) => p.status != n.status,
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return AppGradientButton(
                label: AppStrings.loginSignIn,
                onPressed: isLoading ? null : onSignIn,
                isLoading: isLoading,
                icon: LucideIcons.logIn,
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
                child: Text(
                  AppStrings.loginOr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    letterSpacing: AppDimensions.letterSpacingWide,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Row(
            children: [
              Expanded(
                child: LoginSocialButton(
                  label: AppStrings.loginGoogle,
                  icon: LucideIcons.globe,
                  onTap: () => context.read<AuthCubit>().signInWithGoogle(),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: LoginSocialButton(
                  label: AppStrings.loginSchoolId,
                  icon: LucideIcons.graduationCap,
                  onTap: () => ComingSoonSheet.show(context, featureName: AppStrings.loginSchoolId),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.loginNoAccount,
                  style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: AppDimensions.paddingXXS),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.signupPath),
                  child: Text(
                    AppStrings.loginSignUp,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
