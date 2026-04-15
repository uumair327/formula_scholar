import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../../domain/domain.dart';

/// Saved/Bookmarks page matching the React prototype.
class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        return BlocBuilder<SavedCubit, SavedState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.bookmarks != curr.bookmarks ||
              prev.chapters != curr.chapters,
          builder: (context, state) {
            if (state.status == SavedStatus.loading ||
                state.status == SavedStatus.initial) {
              return const Scaffold(body: AppLoadingState());
            }

            if (state.status == SavedStatus.error) {
              return Scaffold(
                body: AppErrorState(
                  message: state.errorMessage,
                  onRetry: () {
                    final curr = context
                        .read<CurriculumCubit>()
                        .state
                        .curriculum;
                    if (curr != null) {
                      context.read<SavedCubit>().loadBookmarks(
                        curriculumKey: curr.curriculumKey,
                      );
                    }
                  },
                ),
              );
            }

            if (state.isEmpty) {
              // Show empty bookmarks state (matching prototype).
              return Scaffold(
                appBar: _buildAppBar(context, authState.user),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: AppDimensions.paddingXXL,
                      right: AppDimensions.paddingXXL,
                      top: AppDimensions.paddingXXL,
                      bottom: AppDimensions.bottomNavPadding,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.paddingSection),
                        _buildEmptyState(context),
                        const SizedBox(height: AppDimensions.paddingSection),
                        _buildProTipBanner(),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Show loaded bookmarks and chapters
            return Scaffold(
              appBar: _buildAppBar(context, authState.user),
              body: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                children: [
                  if (state.chapters.isNotEmpty) ...[
                    Text(
                      AppStrings.savedChapters,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    ...state.chapters.map(
                      (chapter) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingLG,
                        ),
                        child: _SavedChapterCard(chapter: chapter),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                  ],
                  if (state.bookmarks.isNotEmpty) ...[
                    Text(
                      AppStrings.savedFormulas,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    ...state.bookmarks.map(
                      (bookmark) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingLG,
                        ),
                        child: _BookmarkCard(bookmark: bookmark),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSectionLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Column(
        children: [
          // Bookmark icon with plus badge.
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppDimensions.imageXL,
                height: AppDimensions.imageXL,
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.bookmark,
                  size: AppDimensions.imageLG,
                  color: AppColors.onTertiaryContainer,
                ),
              ),
              Positioned(
                bottom: AppDimensions.positionOffsetSM,
                right: AppDimensions.positionOffsetSM,
                child: Container(
                  width: AppDimensions.imageMD,
                  height: AppDimensions.imageMD,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: const [AppShadows.ghost],
                  ),
                  child: const Icon(
                    LucideIcons.plus,
                    size: AppDimensions.iconLG,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            AppStrings.nothingHereYet,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.emptyBookmarksDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          // Browse Lessons button.
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the Chapters tab (branch index 1).
              StatefulNavigationShell.of(context).goBranch(1);
            },
            icon: const Icon(LucideIcons.compass),
            label: const Text(AppStrings.browseLessons),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXXL,
                vertical: AppDimensions.paddingMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              elevation: AppDimensions.elevationNone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProTipBanner() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        border: Border.all(
          color: AppColors.tertiaryContainer.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            LucideIcons.lightbulb,
            size: AppDimensions.iconLG,
            color: AppColors.onTertiaryContainer,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.proTip,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  AppStrings.proTipContent,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onTertiaryContainer,
                    height: AppDimensions.lineHeightDefault,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AuthUser? user) {
    final photoUrl = user?.photoUrl ?? '';

    return AppBar(
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => context.go(AppRoutes.profilePath),
            behavior: HitTestBehavior.opaque,
            child: photoUrl.isNotEmpty
                ? AppAvatar(
                    imageUrl: photoUrl,
                    size: AppDimensions.avatarMD,
                    fallbackIcon: LucideIcons.bookmark,
                    fallbackIconColor: AppColors.primary,
                  )
                : Container(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryFixed,
                    ),
                    child: const Icon(
                      LucideIcons.bookmark,
                      color: AppColors.primary,
                    ),
                  ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.navSaved,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            final curr = context.read<CurriculumCubit>().state.curriculum;
            if (curr != null) {
              context.read<SavedCubit>().loadBookmarks(
                curriculumKey: curr.curriculumKey,
              );
            }
          },
          icon: const Icon(LucideIcons.refreshCw, color: AppColors.outline),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final BookmarkedFormula bookmark;

  const _BookmarkCard({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.subject,
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'SAVED ${_formatDate(bookmark.savedAt)}',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () =>
                    context.read<SavedCubit>().removeBookmark(bookmark.id),
                icon: const Icon(
                  Icons.bookmark,
                  size: AppDimensions.iconMD,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            bookmark.title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Math.tex(
                  bookmark.formula,
                  textStyle: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SavedChapterCard extends StatelessWidget {
  final BookmarkedChapter chapter;

  const _SavedChapterCard({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        onTap: () {
          context.goNamed(
            AppRoutes.formulaDetailName,
            pathParameters: {
              'subjectId': chapter.subjectId,
              'chapterId': chapter.chapterId,
            },
            queryParameters: {'name': chapter.chapterName},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.subjectName,
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'SAVED ${_formatDate(chapter.savedAt)}',
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<SavedCubit>().removeSavedChapter(
                      subjectId: chapter.subjectId,
                      chapterId: chapter.chapterId,
                    );
                  },
                  icon: const Icon(
                    Icons.bookmark,
                    size: AppDimensions.iconMD,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              chapter.chapterName,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (chapter.chapterSubtitle.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                chapter.chapterSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
