import 'package:flutter/material.dart';

import '../../core/core.dart';

class LegalEffectiveDateBadge extends StatelessWidget {
  const LegalEffectiveDateBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLG,
        vertical: AppDimensions.paddingSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
      ),
      child: Text(
        context.l10n.legalEffectiveDate,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
