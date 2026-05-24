import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../cubit/auth_cubit.dart';

class SignupSocialSection extends StatelessWidget {
  const SignupSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.surfaceContainerHighest)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
              child: Text(
                AppStrings.signupOrJoin,
                style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.surfaceContainerHighest)),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
                icon: const Icon(LucideIcons.globe, size: AppDimensions.iconDefault),
                label: const Text(AppStrings.loginGoogle),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMD),
                  shape: const StadiumBorder(),
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  foregroundColor: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ComingSoonSheet.show(context, featureName: AppStrings.signupFacebook),
                icon: const Icon(LucideIcons.facebook, size: AppDimensions.iconDefault),
                label: const Text(AppStrings.signupFacebook),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMD),
                  shape: const StadiumBorder(),
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  foregroundColor: colorScheme.onSurface,
                ),
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
                AppStrings.signupHasAccount,
                style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: AppDimensions.paddingXXS),
              GestureDetector(
                onTap: () => context.go(AppRoutes.loginPath),
                child: Text(
                  AppStrings.signupSignIn,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
