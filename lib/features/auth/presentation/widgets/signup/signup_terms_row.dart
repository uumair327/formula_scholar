import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core.dart';

class SignupTermsRow extends StatelessWidget {
  const SignupTermsRow({
    super.key,
    required this.agreedToTerms,
    required this.onTermsChanged,
  });

  final bool agreedToTerms;
  final ValueChanged<bool?> onTermsChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Checkbox(
          value: agreedToTerms,
          onChanged: onTermsChanged,
          activeColor: AppColors.primary,
        ),
        const SizedBox(width: AppDimensions.paddingXS),
        Expanded(
          child: Wrap(
            children: [
              Text(AppStrings.signupTerms, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant)),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.termsOfServiceName),
                child: Text(
                  AppStrings.signupTermsLink,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
              Text(AppStrings.signupAnd, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant)),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                child: Text(
                  AppStrings.signupPrivacy,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
