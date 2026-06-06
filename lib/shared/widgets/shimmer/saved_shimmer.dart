import 'package:flutter/material.dart';

import '../../../core/core.dart';

class SavedShimmer extends StatelessWidget {
  const SavedShimmer({super.key});

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
                        ShimmerBox(width: 120, height: 16),
                        SizedBox(height: AppDimensions.paddingSM),
                        ShimmerBox(width: 80, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              const ShimmerBox(
                width: double.infinity,
                height: 48,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              const Row(
                children: [
                  Expanded(child: ShimmerBox(width: 80, height: 36)),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(child: ShimmerBox(width: 80, height: 36)),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(child: ShimmerBox(width: 80, height: 36)),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              for (int i = 0; i < 6; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 80,
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
