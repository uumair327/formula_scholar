import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/chapters_cubit.dart';
import '../cubit/chapters_state.dart';
import '../widgets/chapter_search_bar.dart';
import '../widgets/chapter_sort_controls.dart';
import '../widgets/mastery_tools_section.dart';
import '../widgets/no_subject_selected_state.dart';
import '../widgets/subject/chapter_cards_list.dart';
import '../widgets/subject/subject_app_bar.dart';
import '../widgets/subject/subject_chip_selector.dart';
import '../widgets/subject/subject_hero_card.dart';

class SubjectChaptersPage extends StatelessWidget {
  const SubjectChaptersPage({super.key});

  void _retryLoadChapters(BuildContext context, String subjectId) {
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;
    if (curriculumKey == null || curriculumKey.isEmpty) return;
    final state = context.read<ChaptersCubit>().state;
    unawaited(
      context.read<ChaptersCubit>().loadChapters(
        subjectId,
        curriculumKey: curriculumKey,
        searchQuery: state.searchQuery,
        sortBy: state.sortBy,
        sortDesc: state.sortDesc,
        forceReload: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectSelectionCubit, SubjectSelectionState>(
      listenWhen: (prev, curr) {
        final prevId = prev.subject?.id;
        final currId = curr.subject?.id;
        return prevId != currId && currId != null;
      },
      listener: (context, subjectState) {
        if (subjectState.hasSelection) {
          final curriculumKey = context
              .read<CurriculumCubit>()
              .state
              .curriculum
              ?.curriculumKey;
          if (curriculumKey == null || curriculumKey.isEmpty) return;
          final cubitState = context.read<ChaptersCubit>().state;
          unawaited(
            context.read<ChaptersCubit>().loadChapters(
              subjectState.subject!.id,
              curriculumKey: curriculumKey,
              sortBy: cubitState.sortBy,
              sortDesc: cubitState.sortDesc,
            ),
          );
        }
      },
      child: BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
        builder: (context, subjectState) {
          final subject = subjectState.subject;

          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                if (subjectState.hasSelection) {
                  final selectedSubject = subjectState.subject!;
                  final cubitState = context.read<ChaptersCubit>().state;
                  await context.read<ChaptersCubit>().loadChapters(
                    selectedSubject.id,
                    curriculumKey:
                        context
                            .read<CurriculumCubit>()
                            .state
                            .curriculum
                            ?.curriculumKey ??
                        '',
                    searchQuery: context
                        .read<ChaptersCubit>()
                        .state
                        .searchQuery,
                    sortBy: cubitState.sortBy,
                    sortDesc: cubitState.sortDesc,
                  );
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop =
                      constraints.maxWidth >= AppDimensions.breakpointDesktop;
                  final hp = isDesktop
                      ? ((constraints.maxWidth -
                                    AppDimensions.breakpointMaxContent) /
                                2)
                            .clamp(
                              AppDimensions.paddingSectionLG,
                              double.infinity,
                            )
                      : AppDimensions.paddingXL;
                  return CustomScrollView(
                    slivers: [
                      SubjectChaptersAppBar(subject: subject),
                      SubjectChipSelector(state: subjectState),
                      if (!subjectState.hasSelection &&
                          subjectState.availableSubjects.isEmpty &&
                          subjectState.isLoadingAvailableSubjects)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: ChaptersShimmer(),
                        )
                      else if (!subjectState.hasSelection)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: NoSubjectSelectedState(),
                        )
                      else
                        BlocBuilder<ChaptersCubit, ChaptersState>(
                          buildWhen: (prev, curr) =>
                              prev.status != curr.status ||
                              prev.chapters != curr.chapters ||
                              prev.masteryTools != curr.masteryTools ||
                              prev.sortBy != curr.sortBy ||
                              prev.sortDesc != curr.sortDesc,
                          builder: (context, state) {
                            if (state.status == ChaptersStatus.loading ||
                                state.status == ChaptersStatus.initial) {
                              return const SliverFillRemaining(
                                child: ChaptersShimmer(),
                              );
                            }
                            if (state.status == ChaptersStatus.error) {
                              return SliverFillRemaining(
                                child: AppErrorState(
                                  message: state.errorMessage,
                                  onRetry: () =>
                                      _retryLoadChapters(context, subject!.id),
                                ),
                              );
                            }
                            if (state.chapters.isEmpty) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: AppEmptyState(
                                  title: AppStrings.chaptersNoContentTitle,
                                  description:
                                      AppStrings.chaptersNoContentDescription,
                                  icon: LucideIcons.bookOpen,
                                  actionLabel:
                                      AppStrings.chaptersBrowseSubjects,
                                  onAction: () {
                                    context
                                        .read<SubjectSelectionCubit>()
                                        .clearSelection();
                                    StatefulNavigationShell.of(
                                      context,
                                    ).goBranch(0);
                                  },
                                ),
                              );
                            }
                            return SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: hp),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  const SizedBox(
                                    height: AppDimensions.paddingLG,
                                  ),
                                  SubjectHeroCard(
                                    subject: subjectState.subject!,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingXXL,
                                  ),
                                  const ChapterSearchBar(),
                                  const SizedBox(
                                    height: AppDimensions.paddingLG,
                                  ),
                                  ChapterSortControls(
                                    state: state,
                                    subjectId: subjectState.subject!.id,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingLG,
                                  ),
                                  ChapterCardsList(
                                    chapters: state.chapters,
                                    subjectId: subjectState.subject!.id,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingSection,
                                  ),
                                  MasteryToolsSection(
                                    tools: state.masteryTools,
                                    subjectId: subjectState.subject!.id,
                                    chapters: state.chapters,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.bottomNavPadding,
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: subjectState.hasSelection
                ? FloatingActionButton(
                    onPressed: () =>
                        StatefulNavigationShell.of(context).goBranch(2),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(
                      LucideIcons.play,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
