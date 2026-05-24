import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class SignupBackgroundDecor extends StatelessWidget {
  const SignupBackgroundDecor({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned(
          top: -AppDimensions.decorativeBlurMD * AppDimensions.decorativePositionFraction,
          right: -AppDimensions.decorativeBlurSM * AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurLG,
            height: AppDimensions.decorativeBlurLG,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkPrimary : AppColors.primaryFixed).withValues(alpha: 0.1),
                  (isDark ? AppColors.darkPrimary : AppColors.primaryFixed).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -AppDimensions.decorativeBlurSM * AppDimensions.decorativePositionFraction,
          left: -AppDimensions.decorativeBlurSM * AppDimensions.decorativePositionFraction,
          child: Container(
            width: AppDimensions.decorativeBlurMD,
            height: AppDimensions.decorativeBlurMD,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.darkTertiary : AppColors.tertiaryContainer).withValues(alpha: 0.08),
                  (isDark ? AppColors.darkTertiary : AppColors.tertiaryContainer).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
