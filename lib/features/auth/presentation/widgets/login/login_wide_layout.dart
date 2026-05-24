import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import 'login_brand_column.dart';
import 'login_form_content.dart';

class LoginWideLayout extends StatelessWidget {
  const LoginWideLayout({
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
          const Expanded(flex: 5, child: LoginBrandColumn()),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingHero,
                vertical: AppDimensions.paddingXXL,
              ),
              child: LoginFormContent(
                formKey: formKey,
                identityController: identityController,
                passwordController: passwordController,
                obscurePassword: obscurePassword,
                onToggleObscure: onToggleObscure,
                onSignIn: onSignIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
