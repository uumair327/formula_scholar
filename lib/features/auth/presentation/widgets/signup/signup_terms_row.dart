import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core.dart';
import '../../../../../l10n/l10n.dart';

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
    final l10n = context.l10n;

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
              Text(
                l10n.signupTerms,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.termsOfServiceName),
                child: Text(
                  l10n.signupTermsLink,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                l10n.signupAnd,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                child: Text(
                  l10n.signupPrivacy,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
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
