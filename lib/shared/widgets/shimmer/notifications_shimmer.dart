import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../app_shimmer.dart';

class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SafeArea(
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
                  ShimmerBox(width: 150, height: 24),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              const ShimmerBox(width: double.infinity, height: 100, borderRadius: AppDimensions.radiusXL),
              const SizedBox(height: AppDimensions.paddingXXL),
              const ShimmerBox(width: 180, height: 18),
              const SizedBox(height: AppDimensions.paddingLG),
              for (int i = 0; i < 4; i++) ...[
                const ShimmerBox(width: double.infinity, height: 70, borderRadius: AppDimensions.radiusLG),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
