import 'package:flutter/material.dart';

import '../../../core/core.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppShimmer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  ShimmerBox(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    borderRadius: AppDimensions.radiusXXL,
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 150, height: 16),
                        SizedBox(height: AppDimensions.paddingSM),
                        ShimmerBox(width: 100, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              const ShimmerBox(
                width: double.infinity,
                height: 140,
                borderRadius: AppDimensions.radiusXL,
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              const ShimmerBox(width: 120, height: 16),
              const SizedBox(height: AppDimensions.paddingLG),
              const Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              const ShimmerBox(
                width: double.infinity,
                height: 100,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              const ShimmerBox(width: 80, height: 16),
              const SizedBox(height: AppDimensions.paddingLG),
              for (int i = 0; i < 5; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 52,
                  borderRadius: AppDimensions.radiusMD,
                ),
                const SizedBox(height: AppDimensions.paddingSM),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
