import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../l10n/l10n.dart';
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

        final l10n = dialogContext.l10n;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          title: Text(l10n.forgotPasswordTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.forgotPasswordDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              AppTextField(
                controller: resetEmailController,
                label: l10n.loginEmailLabel,
                hintText: l10n.loginEmailHint,
                prefixIcon: LucideIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.forgotPasswordCancel),
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
                          ? l10n.forgotPasswordSuccess
                          : context.read<AuthCubit>().state.errorMessage ??
                                AppStrings.genericError,
                    ),
                    backgroundColor: success
                        ? AppColors.secondary
                        : AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSM,
                      ),
                    ),
                  ),
                );
              },
              child: Text(l10n.forgotPasswordSend),
            ),
          ],
        );
      },
    );
  } finally {
    resetEmailController.dispose();
  }
}
