import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../app_shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

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
                  ShimmerBox(width: AppDimensions.avatarMD, height: AppDimensions.avatarMD, borderRadius: AppDimensions.radiusXXL),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 14),
                        SizedBox(height: AppDimensions.paddingSM),
                        ShimmerBox(width: 80, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              const ShimmerBox(width: double.infinity, height: 160, borderRadius: AppDimensions.radiusXL),
              const SizedBox(height: AppDimensions.paddingSection),
              const ShimmerBox(width: 140, height: 18),
              const SizedBox(height: AppDimensions.paddingLG),
              const Row(
                children: [
                  Expanded(child: ShimmerBox(width: double.infinity, height: 100, borderRadius: AppDimensions.radiusLG)),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(child: ShimmerBox(width: double.infinity, height: 100, borderRadius: AppDimensions.radiusLG)),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              const Row(
                children: [
                  Expanded(child: ShimmerBox(width: double.infinity, height: 100, borderRadius: AppDimensions.radiusLG)),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(child: ShimmerBox(width: double.infinity, height: 100, borderRadius: AppDimensions.radiusLG)),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSection),
              const ShimmerBox(width: 160, height: 18),
              const SizedBox(height: AppDimensions.paddingLG),
              for (int i = 0; i < 3; i++) ...[
                const ShimmerBox(width: double.infinity, height: 72, borderRadius: AppDimensions.radiusLG),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
