import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../../../dashboard/domain/domain.dart';
import '../../../dashboard/presentation/widgets/widgets.dart';
import '../cubit/subjects_cubit.dart';
import '../cubit/subjects_state.dart';
import '../widgets/subjects_curriculum_bar.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final curriculum = context.read<CurriculumCubit>().state.curriculum;
          if (curriculum != null) {
            await context.read<SubjectsCubit>().loadSubjects(
              curriculum.boardId,
              curriculum.gradeId,
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop =
                constraints.maxWidth >= AppDimensions.breakpointDesktop;
            final hp = isDesktop
                ? ((constraints.maxWidth - AppDimensions.breakpointMaxContent) /
                          2)
                      .clamp(AppDimensions.paddingSectionLG, double.infinity)
                : AppDimensions.paddingXL;

            return CustomScrollView(
              slivers: [
                _buildAppBar(context, colorScheme),
                const SubjectsCurriculumBar(),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hp),
                  sliver: BlocBuilder<SubjectsCubit, SubjectsState>(
                    buildWhen: (p, n) =>
                        p.status != n.status ||
                        p.subjects != n.subjects ||
                        p.errorMessage != n.errorMessage,
                    builder: (context, state) {
                      if (state.status == SubjectsStatus.initial ||
                          state.status == SubjectsStatus.loading) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: ChaptersShimmer(),
                        );
                      }

                      if (state.status == SubjectsStatus.error) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: AppErrorState(
                            message: context.localizedError(
                              fallback: state.errorMessage,
                            ),
                            onRetry: () {
                              final curriculum = context
                                  .read<CurriculumCubit>()
                                  .state
                                  .curriculum;
                              if (curriculum != null) {
                                context.read<SubjectsCubit>().loadSubjects(
                                  curriculum.boardId,
                                  curriculum.gradeId,
                                );
                              }
                            },
                          ),
                        );
                      }

                      if (state.subjects.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(context, colorScheme),
                        );
                      }

                      return _buildSubjectGrid(context, state.subjects);
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.bottomNavPadding),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverGlassAppBar _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return SliverGlassAppBar(
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.navSubjects,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      bottom: const DummySearchPill(),
    );
  }

  Widget _buildSubjectGrid(BuildContext context, List<Subject> subjects) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: AppDimensions.paddingLG),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: AppDimensions.paddingLG,
          crossAxisSpacing: AppDimensions.paddingLG,
          mainAxisExtent: 320,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final subject = subjects[index];
          return EntranceWrapper.stagger(
            index: index,
            child: SubjectCard(
              subject: subject,
              onTap: () => _onSubjectTap(context, subject),
              onLongPress: () {},
            ),
          );
        }, childCount: subjects.length),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Center(
        child: AppEmptyState(
          title: context.l10n.noSubjectsAvailable,
          description:
              'Set your board and grade on the Home tab to discover available subjects.',
          icon: LucideIcons.layers,
          actionLabel: context.l10n.goHome,
          onAction: () {
            StatefulNavigationShell.of(context).goBranch(0);
          },
        ),
      ),
    );
  }

  void _onSubjectTap(BuildContext context, Subject subject) {
    context.read<SubjectSelectionCubit>().selectSubject(
      id: subject.id,
      name: subject.name,
      category: subject.category,
      description: subject.description,
      iconName: subject.iconName,
      subtitle: subject.subtitle ?? '',
    );

    context.goNamed(
      AppRoutes.subjectChaptersName,
      pathParameters: {'subjectId': subject.id},
    );
  }
}
