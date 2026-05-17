import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../cubit/auth_cubit.dart';

/// Shared password reset dialog used from login and profile flows.
void showForgotPasswordDialog(BuildContext context, String prefillEmail) async {
  final resetEmailController = TextEditingController(text: prefillEmail);

  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          title: const Text(AppStrings.forgotPasswordTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.forgotPasswordDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              AppTextField(
                controller: resetEmailController,
                label: AppStrings.loginEmailLabel,
                hintText: AppStrings.loginEmailHint,
                prefixIcon: LucideIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppStrings.forgotPasswordCancel),
            ),
            FilledButton(
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isEmpty) return;

                Navigator.of(dialogContext).pop();
                final success = await context
                    .read<AuthCubit>()
                    .sendPasswordResetEmail(email: email);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? AppStrings.forgotPasswordSuccess
                          : context.read<AuthCubit>().state.errorMessage ??
                                AppStrings.genericError,
                    ),
                    backgroundColor: success
                        ? AppColors.secondary
                        : AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                  ),
                );
              },
              child: const Text(AppStrings.forgotPasswordSend),
            ),
          ],
        );
      },
    );
  } finally {
    resetEmailController.dispose();
  }
}
