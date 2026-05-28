import 'package:flutter/material.dart';

import '../../../core/core.dart';

class FormulasShimmer extends StatelessWidget {
  const FormulasShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < 5; i++) ...[
              const ShimmerBox(
                width: double.infinity,
                height: 120,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
          ],
        ),
      ),
    );
  }
}
