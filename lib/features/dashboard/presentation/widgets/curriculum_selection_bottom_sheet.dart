import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
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
                  margin: const EdgeInsets.only(
                    bottom: AppDimensions.paddingLG,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  ),
                ),
              ),
              Text(
                context.l10n.step2Title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Expanded(
                child:
                    BlocBuilder<CurriculumOptionsCubit, CurriculumOptionsState>(
                      builder: (context, options) {
                        final isBusy =
                            options.status == CurriculumOptionsStatus.loading;

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isBusy && !options.hasCountries)
                                const FilterShimmer()
                              else ...[
                                if (options.hasCountries)
                                  EntranceWrapper.stagger(
                                    index: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppDimensions.paddingLG,
                                      ),
                                      child: CurriculumChipRow<Country>(
                                        label: context.l10n.step1CountryLabel,
                                        items: options.countries,
                                        selectedId: options.draftCountryId,
                                        itemId: (country) => country.id,
                                        itemLabel: (country) => country.name,
                                        emptyMessage: 'No countries available',
                                        isBusy: isBusy,
                                        onSelected: (country) async => context
                                            .read<CurriculumOptionsCubit>()
                                            .selectCountry(country.id),
                                      ),
                                    ),
                                  ),
                                if (options.hasStates)
                                  EntranceWrapper.stagger(
                                    index: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppDimensions.paddingLG,
                                      ),
                                      child: CurriculumChipRow<StateRegion>(
                                        label: context.l10n.step1StateLabel,
                                        items: options.states,
                                        selectedId: options.draftStateId,
                                        itemId: (state) => state.id,
                                        itemLabel: (state) => state.name,
                                        emptyMessage: 'No states available',
                                        isBusy: isBusy,
                                        onSelected: (state) async => context
                                            .read<CurriculumOptionsCubit>()
                                            .selectState(state.id),
                                      ),
                                    ),
                                  ),
                                if (options.hasBoards)
                                  EntranceWrapper.stagger(
                                    index: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppDimensions.paddingLG,
                                      ),
                                      child: CurriculumChipRow<Board>(
                                        label: context
                                            .l10n
                                            .dashboardAvailableBoards,
                                        items: options.boards,
                                        selectedId: options.draftBoardId,
                                        itemId: (board) => board.id,
                                        itemLabel: (board) => board.name,
                                        itemSubtitle: (Board board) =>
                                            board.type.name,
                                        emptyMessage: context
                                            .l10n
                                            .dashboardNoBoardsAvailable,
                                        isBusy: isBusy,
                                        onSelected: (board) async => context
                                            .read<CurriculumOptionsCubit>()
                                            .selectBoard(board.id),
                                      ),
                                    ),
                                  ),
                                if (options.hasGrades)
                                  EntranceWrapper.stagger(
                                    index: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppDimensions.paddingLG,
                                      ),
                                      child: CurriculumChipRow<Grade>(
                                        label: context
                                            .l10n
                                            .dashboardAvailableClasses,
                                        items: options.grades,
                                        selectedId: options.draftGradeId,
                                        itemId: (grade) => grade.id,
                                        itemLabel: (grade) =>
                                            grade.displayLabel,
                                        emptyMessage: context
                                            .l10n
                                            .dashboardNoClassesAvailable,
                                        isBusy: isBusy,
                                        onSelected: (grade) async {
                                          context
                                              .read<CurriculumOptionsCubit>()
                                              .selectGrade(grade.id);
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                              if (options.status ==
                                  CurriculumOptionsStatus.error)
                                CurriculumErrorRow(
                                  errorKey: options.errorKey,
                                  errorMessage: options.errorMessage,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              BlocBuilder<CurriculumOptionsCubit, CurriculumOptionsState>(
                builder: (context, options) {
                  return AppGradientButton(
                    label: 'Apply Curriculum',
                    onPressed: options.isReadyToApply
                        ? () async {
                            await context
                                .read<CurriculumOptionsCubit>()
                                .applySelection();
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        : null,
                  );
                },
              ),
              const SizedBox(height: AppDimensions.paddingLG),
            ],
          ),
        ),
      ),
    );
  }
}
