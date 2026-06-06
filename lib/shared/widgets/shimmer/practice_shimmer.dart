import 'package:flutter/material.dart';

import '../../../core/core.dart';

class PracticeShimmer extends StatelessWidget {
  const PracticeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.paddingXXL),
              const ShimmerBox(
                width: 140,
                height: 24,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              const ShimmerBox(
                width: double.infinity,
                height: 8,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              const ShimmerBox(
                width: double.infinity,
                height: 200,
                borderRadius: AppDimensions.radiusXL,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              for (int i = 0; i < 4; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 60,
                  borderRadius: AppDimensions.radiusLG,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
