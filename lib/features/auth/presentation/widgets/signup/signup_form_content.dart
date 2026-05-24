import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../cubit/auth_cubit.dart';
import 'signup_social_section.dart';
import 'signup_terms_row.dart';

class SignupFormContent extends StatelessWidget {
  const SignupFormContent({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.agreedToTerms,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onTermsChanged,
    required this.onCreateAccount,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool agreedToTerms;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHero,
        vertical: AppDimensions.paddingXXL,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.signupTitle,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: AppDimensions.letterSpacingTight,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              AppStrings.signupSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: AppStrings.signupFullName,
                    hintText: AppStrings.signupFullNameHint,
                    prefixIcon: LucideIcons.user,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return AppStrings.validationRequired;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: AppTextField(
                    label: AppStrings.signupEmail,
                    hintText: AppStrings.signupEmailHint,
                    prefixIcon: LucideIcons.mail,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return AppStrings.validationRequired;
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
                        return AppStrings.validationInvalidEmail;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            AppTextField(
              label: AppStrings.signupPassword,
              hintText: AppStrings.signupPasswordHint,
              controller: passwordController,
              prefixIcon: LucideIcons.lock,
              obscureText: obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) return AppStrings.validationRequired;
                if (value.length < 6) return AppStrings.validationPasswordMinLength;
                return null;
              },
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimensions.iconDefault,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            AppTextField(
              label: AppStrings.signupConfirmPassword,
              hintText: AppStrings.signupPasswordHint,
              controller: confirmController,
              prefixIcon: LucideIcons.checkSquare,
              obscureText: obscureConfirm,
              validator: (value) {
                if (value == null || value.isEmpty) return AppStrings.validationRequired;
                if (value != passwordController.text) return AppStrings.validationPasswordMismatch;
                return null;
              },
              suffixIcon: IconButton(
                onPressed: onToggleConfirm,
                icon: Icon(
                  obscureConfirm ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimensions.iconDefault,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            SignupTermsRow(agreedToTerms: agreedToTerms, onTermsChanged: onTermsChanged),
            const SizedBox(height: AppDimensions.paddingXL),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (p, n) => p.status != n.status,
              builder: (context, state) {
                final isLoading = state.status == AuthStatus.loading;
                return AppGradientButton(
                  label: AppStrings.signupCreateAccount,
                  onPressed: isLoading ? null : onCreateAccount,
                  isLoading: isLoading,
                  icon: LucideIcons.userPlus,
                );
              },
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            const SignupSocialSection(),
          ],
        ),
      ),
    );
  }
}
