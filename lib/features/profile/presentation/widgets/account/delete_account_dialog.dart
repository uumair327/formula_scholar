import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../../../auth/auth.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const DeleteAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (p, n) => p.status != n.status,
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pop();
          context.go(AppRoutes.loginPath);
        } else if (state.status == AuthStatus.error) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppStrings.deleteAccountFailed),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: AlertDialog(
        backgroundColor: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXL)),
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle, color: AppColors.error),
            const SizedBox(width: AppDimensions.paddingMD),
            Text(AppStrings.deleteAccountTitle, style: AppTextStyles.titleLarge.copyWith(color: AppColors.error)),
          ],
        ),
        content: Text(AppStrings.deleteAccountConfirmation,
          style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancelLabel, style: AppTextStyles.labelLarge.copyWith(color: colorScheme.outline)),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (p, n) => p.status != n.status,
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return AppGradientButton(
                onPressed: isLoading ? null : () {
                  HapticsHelper.heavyImpact();
                  context.read<AuthCubit>().deleteAccount();
                },
                label: AppStrings.deleteAccountButton,
                icon: LucideIcons.trash2,
                isLoading: isLoading,
                gradient: AppColors.errorGradient,
                isExpanded: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
