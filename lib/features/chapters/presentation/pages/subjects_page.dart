import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../dashboard/domain/domain.dart';
import '../../../dashboard/presentation/widgets/widgets.dart';
import '../cubit/subjects_cubit.dart';
import '../cubit/subjects_state.dart';

/// Subjects listing page — replaces the old "Chapters" tab.
///
/// Displays all subjects available for the user's currently selected
/// board + grade as a responsive grid of [SubjectCard] widgets.
/// Tapping a card navigates to [SubjectChaptersPage] via GoRouter.
class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final curriculum =
              context.read<CurriculumCubit>().state.curriculum;
          if (curriculum != null) {
            await context
                .read<SubjectsCubit>()
                .loadSubjects(curriculum.boardId, curriculum.gradeId);
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
                _buildCurriculumInfo(context, colorScheme),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hp),
                  sliver: BlocBuilder<SubjectsCubit, SubjectsState>(
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
                            message: state.errorMessage,
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

  // ─────────────────────── App Bar ──────────────────────────────

  SliverAppBar _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: colorScheme.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.navSubjects,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          BlocBuilder<CurriculumCubit, CurriculumState>(
            buildWhen: (prev, curr) => prev.curriculum != curr.curriculum,
            builder: (context, currState) {
              final curriculum = currState.curriculum;
              if (curriculum == null) return const SizedBox.shrink();
              return Text(
                '${curriculum.boardName} • ${curriculum.gradeLabel}',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.primary,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        Semantics(
          label: 'Search formulas',
          button: true,
          child: IconButton(
            onPressed: () => context.pushNamed(AppRoutes.searchName),
            icon: Icon(LucideIcons.search, color: colorScheme.outline),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  // ─────────────────────── Curriculum info bar ──────────────────

  Widget _buildCurriculumInfo(
      BuildContext context, ColorScheme colorScheme) {
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

  // ─────────────────────── Subject Grid ────────────────────────

  Widget _buildSubjectGrid(BuildContext context, List<Subject> subjects) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: AppDimensions.paddingLG),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: AppDimensions.paddingLG,
          crossAxisSpacing: AppDimensions.paddingLG,
          childAspectRatio: 1.4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final subject = subjects[index];
            return SubjectCard(
              subject: subject,
              onTap: () => _onSubjectTap(context, subject),
              onLongPress: () {},
            );
          },
          childCount: subjects.length,
        ),
      ),
    );
  }

  // ─────────────────────── Empty State ─────────────────────────

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Center(
        child: AppCard(
          padding: const EdgeInsets.all(AppDimensions.paddingXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.layers,
                size: AppDimensions.imageLG,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              Text(
                'No subjects available',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                'Set your board and grade on the Home tab to discover available subjects.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              ElevatedButton(
                onPressed: () {
                  StatefulNavigationShell.of(context).goBranch(0);
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────── Navigation ──────────────────────────

  void _onSubjectTap(BuildContext context, Subject subject) {
    // Update the global subject selection cubit
    context.read<SubjectSelectionCubit>().selectSubject(
          id: subject.id,
          name: subject.name,
          category: subject.category,
          description: subject.description,
          subtitle: subject.subtitle ?? '',
        );

    // Navigate to chapters for this subject
    context.goNamed(
      AppRoutes.subjectChaptersName,
      pathParameters: {'subjectId': subject.id},
    );
  }
}
