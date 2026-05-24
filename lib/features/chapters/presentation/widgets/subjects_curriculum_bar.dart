import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class SubjectsCurriculumBar extends StatelessWidget {
  const SubjectsCurriculumBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: BlocBuilder<CurriculumCubit, CurriculumState>(
        buildWhen: (prev, curr) => prev.curriculum != curr.curriculum,
        builder: (context, currState) {
          final curriculum = currState.curriculum;
          if (curriculum == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
              vertical: AppDimensions.paddingSM,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: signatureGlowDecoration(colorScheme),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.graduationCap,
                    color: colorScheme.onPrimary,
                    size: AppDimensions.iconXL,
                  ),
                  const SizedBox(width: AppDimensions.paddingLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${curriculum.boardName} — ${curriculum.gradeLabel}',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          'Browse all subjects in your curriculum',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onPrimary.withValues(
                              alpha: AppDimensions.opacityHigh,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
