import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import 'login_formula_card.dart';

class LoginBrandColumn extends StatelessWidget {
  const LoginBrandColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: AppDimensions.paddingXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: AppDimensions.opacitySubtle),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            ),
            child: Text(
              AppStrings.loginStudentPortal,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: AppDimensions.letterSpacingWide,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            AppStrings.loginBrandTagline,
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w900,
              height: AppDimensions.lineHeightTight,
              letterSpacing: AppDimensions.letterSpacingTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            AppStrings.loginBrandDesc,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary.withValues(alpha: AppDimensions.opacityHigh),
              height: AppDimensions.lineHeightRelaxed,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingHero),
          const LoginFormulaCard(formula: 'e = mc²', rotation: -0.035),
          const SizedBox(height: AppDimensions.paddingMD),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: AppDimensions.paddingHero),
            child: LoginFormulaCard(formula: 'a² + b² = c²', rotation: 0.052),
          ),
        ],
      ),
    );
  }
}
