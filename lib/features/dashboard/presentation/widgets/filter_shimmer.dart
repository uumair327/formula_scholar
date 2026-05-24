library;

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class FilterShimmer extends StatelessWidget {
  const FilterShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: 120, height: 12),
        SizedBox(height: AppDimensions.paddingSM),
        Row(
          children: [
            ShimmerBox(width: 80, height: 36, borderRadius: 18),
            SizedBox(width: 8),
            ShimmerBox(width: 100, height: 36, borderRadius: 18),
            SizedBox(width: 8),
            ShimmerBox(width: 90, height: 36, borderRadius: 18),
          ],
        ),
        SizedBox(height: AppDimensions.paddingSM),
        ShimmerBox(width: 100, height: 12),
        SizedBox(height: AppDimensions.paddingSM),
        Row(
          children: [
            ShimmerBox(width: 70, height: 36, borderRadius: 18),
            SizedBox(width: 8),
            ShimmerBox(width: 80, height: 36, borderRadius: 18),
          ],
        ),
      ],
    );
  }
}
