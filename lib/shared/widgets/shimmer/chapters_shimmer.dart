import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../app_shimmer.dart';

class ChaptersShimmer extends StatelessWidget {
  const ChaptersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingLG,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: double.infinity, height: 140, borderRadius: AppDimensions.radiusXL),
            const SizedBox(height: AppDimensions.paddingXXL),
            const ShimmerBox(width: 120, height: 16),
            const SizedBox(height: AppDimensions.paddingLG),
            for (int i = 0; i < 5; i++) ...[
              const ShimmerBox(width: double.infinity, height: 80, borderRadius: AppDimensions.radiusLG),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
          ],
        ),
      ),
    );
  }
}
