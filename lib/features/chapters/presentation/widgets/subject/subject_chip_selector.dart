import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';

class SubjectChipSelector extends StatelessWidget {
  const SubjectChipSelector({super.key, required this.state});

  final SubjectSelectionState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state.availableSubjects.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        height: AppDimensions.chipContainerHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL, vertical: AppDimensions.paddingSM),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: state.availableSubjects.length,
          separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.paddingMD),
          itemBuilder: (context, index) {
            final subject = state.availableSubjects[index];
            final isSelected = state.subject?.id == subject.id;

            return GestureDetector(
              onTap: () {
                context.read<SubjectSelectionCubit>().selectSubject(
                  id: subject.id,
                  name: subject.name,
                  category: subject.category,
                  description: subject.description,
                  iconName: subject.iconName,
                );
              },
              child: AnimatedContainer(
                duration: AppDurations.animationFast,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLG),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : colorScheme.surfaceContainerHigh,
                  ),
                  boxShadow: isSelected ? const [AppShadows.subtle] : null,
                ),
                child: Text(
                  subject.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
