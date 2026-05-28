import 'package:flutter/material.dart';

import '../../core/core.dart';

class LegalSectionCard extends StatelessWidget {
  const LegalSectionCard({super.key, required this.index, required this.section});

  final int index;
  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimensions.avatarSM,
                height: AppDimensions.avatarSM,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixed,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: Text(
                  section.title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppDimensions.avatarSM + AppDimensions.paddingMD,
            ),
            child: Text(
              section.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
