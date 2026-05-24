import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import 'signup_brand_column.dart';
import 'signup_form_content.dart';

class SignupWideLayout extends StatelessWidget {
  const SignupWideLayout({
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

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: const [AppShadows.ghost],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          const Expanded(flex: 5, child: SignupBrandColumn()),
          Expanded(
            flex: 5,
            child: SignupFormContent(
              formKey: formKey,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmController: confirmController,
              obscurePassword: obscurePassword,
              obscureConfirm: obscureConfirm,
              agreedToTerms: agreedToTerms,
              onTogglePassword: onTogglePassword,
              onToggleConfirm: onToggleConfirm,
              onTermsChanged: onTermsChanged,
              onCreateAccount: onCreateAccount,
            ),
          ),
        ],
      ),
    );
  }
}
