import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class LoginFormulaCard extends StatelessWidget {
  const LoginFormulaCard({super.key, required this.formula, required this.rotation});

  final String formula;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: AppColors.onPrimary.withValues(alpha: AppDimensions.opacitySubtle),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Text(
          formula,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}
