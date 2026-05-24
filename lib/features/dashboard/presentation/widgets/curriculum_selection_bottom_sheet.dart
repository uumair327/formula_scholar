import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../onboarding/onboarding.dart';
import '../cubit/curriculum_options_cubit.dart';
import '../cubit/curriculum_options_state.dart';
import 'curriculum_chip_row.dart';
import 'curriculum_error_row.dart';
import 'filter_shimmer.dart';

Future<void> showCurriculumSelectionBottomSheet(
  BuildContext context, {
  required CurriculumOptionsCubit optionsCubit,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: optionsCubit,
      child: const CurriculumSelectionBottomSheet(),
    ),
  );
}

class CurriculumSelectionBottomSheet extends StatelessWidget {
  const CurriculumSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingMD,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pull handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  ),
                ),
              ),
              Text(
                'Select Curriculum',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              BlocBuilder<CurriculumCubit, CurriculumState>(
                builder: (context, curriculumState) {
                  final selection = curriculumState.curriculum;
                  return BlocConsumer<CurriculumOptionsCubit, CurriculumOptionsState>(
                    listenWhen: (prev, curr) {
                      // If the grade changed and is not null, auto-close the sheet.
                      // But wait, what if they just opened the sheet? We only want to close if they manually select a NEW grade.
                      // We can check if status is loaded and a grade was just selected.
                      // Actually, it's safer to close when `CurriculumCubit` changes, but grade changes might trigger it.
                      return false;
                    },
                    listener: (context, state) {},
                    builder: (context, options) {
                      final isBusy = options.status == CurriculumOptionsStatus.loading;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isBusy && options.boards.isEmpty)
                            const FilterShimmer()
                          else ...[
                            CurriculumChipRow<Board>(
                              label: AppStrings.dashboardAvailableBoards,
                              items: options.boards,
                              selectedId: selection?.boardId,
                              itemId: (board) => board.id,
                              itemLabel: (board) => board.name,
                              itemSubtitle: (Board board) => board.type.name,
                              emptyMessage: AppStrings.dashboardNoBoardsAvailable,
                              isBusy: isBusy,
                              onSelected: (board) => context
                                  .read<CurriculumOptionsCubit>()
                                  .selectBoard(board),
                            ),
                            const SizedBox(height: AppDimensions.paddingLG),
                            CurriculumChipRow<Grade>(
                              label: AppStrings.dashboardAvailableClasses,
                              items: options.grades,
                              selectedId: selection?.gradeId,
                              itemId: (grade) => grade.id,
                              itemLabel: (grade) => grade.displayLabel,
                              emptyMessage: AppStrings.dashboardNoClassesAvailable,
                              isBusy: isBusy,
                              onSelected: (grade) async {
                                await context.read<CurriculumOptionsCubit>().selectGrade(grade);
                                // Auto-close when grade is selected
                                if (context.mounted) Navigator.of(context).pop();
                              },
                            ),
                          ],
                          if (options.status == CurriculumOptionsStatus.error)
                            CurriculumErrorRow(errorMessage: options.errorMessage),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),
      ),
    );
  }
}
