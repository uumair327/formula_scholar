import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';

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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingSM,
        ),
        child: ListView.separated(
          addAutomaticKeepAlives: false,
          scrollDirection: Axis.horizontal,
          itemCount: state.availableSubjects.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppDimensions.paddingMD),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  subject.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
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
