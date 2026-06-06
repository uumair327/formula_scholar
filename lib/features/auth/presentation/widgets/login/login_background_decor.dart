import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class LoginBackgroundDecor extends StatelessWidget {
  const LoginBackgroundDecor({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned(
          top:
              -AppDimensions.decorativeBlurLG *
              AppDimensions.decorativePositionFraction,
          right:
              -AppDimensions.decorativeBlurLG *
              AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurLG,
            height: AppDimensions.decorativeBlurLG,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkPrimary : AppColors.primaryFixed)
                      .withValues(alpha: 0.12),
                  (isDark ? AppColors.darkPrimary : AppColors.primaryFixed)
                      .withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom:
              -AppDimensions.decorativeBlurSM *
              AppDimensions.decorativePositionFraction,
          left:
              -AppDimensions.decorativeBlurSM *
              AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurMD,
            height: AppDimensions.decorativeBlurMD,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkSecondary : AppColors.secondaryFixed)
                      .withValues(alpha: 0.1),
                  (isDark ? AppColors.darkSecondary : AppColors.secondaryFixed)
                      .withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkTertiary : AppColors.tertiaryFixed)
                      .withValues(alpha: 0.08),
                  AppColors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
