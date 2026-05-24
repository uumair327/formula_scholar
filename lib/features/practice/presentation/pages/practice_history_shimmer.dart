import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class HistoryShimmer extends StatelessWidget {
  const HistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      itemExtent: AppDimensions.cardMinHeightLG + AppDimensions.paddingMD,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.paddingMD),
          child: AppShimmer(
            child: ShimmerBox(
              width: double.infinity,
              height: AppDimensions.cardMinHeightLG,
              borderRadius: AppDimensions.radiusLG,
            ),
          ),
        );
      },
    );
  }
}
