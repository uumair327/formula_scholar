import 'dart:async';

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
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        return BlocBuilder<SavedCubit, SavedState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.bookmarks != curr.bookmarks ||
              prev.chapters != curr.chapters ||
              prev.notes != curr.notes ||
              prev.searchQuery != curr.searchQuery ||
              prev.sortByField != curr.sortByField ||
              prev.sortDirection != curr.sortDirection,
          builder: (context, state) {
            if (state.status == SavedStatus.loading ||
                state.status == SavedStatus.initial) {
              return const Scaffold(body: SavedShimmer());
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
                        _buildProTipBanner(context),
                      ],
                    ),
                  ),
                ),
              );
            }

            final filteredBookmarks = state.filteredBookmarks;
            final filteredChapters = state.filteredChapters;
            final filteredNotes = state.filteredNotes;
            final hasSearchQuery = state.searchQuery.trim().isNotEmpty;

            // Show loaded bookmarks and chapters
            return Scaffold(
              appBar: _buildAppBar(context, authState.user),
              body: RefreshIndicator(
                onRefresh: () {
                  final curr = context.read<CurriculumCubit>().state.curriculum;
                  if (curr != null) {
                    return context.read<SavedCubit>().loadBookmarks(
                      curriculumKey: curr.curriculumKey,
                    );
                  }
                  return Future<void>.value();
                },
                child: ListView(
                  padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                  children: [
                    _buildSearchBar(context, state),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildSortControls(context, state),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    if (hasSearchQuery && !state.hasFilteredResults)
                      _buildNoResultsState(context),
                    if (!hasSearchQuery || state.hasFilteredResults) ...[
                      if (filteredChapters.isNotEmpty) ...[
                        Text(
                          AppStrings.savedChapters,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        ...filteredChapters.map(
                          (chapter) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.paddingLG,
                            ),
                            child: _SavedChapterCard(chapter: chapter),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                      ],
                      if (filteredBookmarks.isNotEmpty) ...[
                        Text(
                          AppStrings.savedFormulas,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        ...filteredBookmarks.map(
                          (bookmark) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.paddingLG,
                            ),
                            child: _BookmarkCard(bookmark: bookmark),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                      ],
                      if (filteredNotes.isNotEmpty) ...[
                        Text(
                          AppStrings.savedNotes,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        ...filteredNotes.map(
                          (note) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.paddingLG,
                            ),
                            child: _SavedNoteCard(note: note),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, SavedState state) {
    if (state.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_searchController.text != state.searchQuery) {
      _searchController.value = _searchController.value.copyWith(
        text: state.searchQuery,
        selection: TextSelection.collapsed(offset: state.searchQuery.length),
        composing: TextRange.empty,
      );
    }

    return TextField(
      controller: _searchController,
      onChanged: (value) {
        _searchDebounce?.cancel();
        _searchDebounce = Timer(
          AppDurations.debounceDefault,
          () => context.read<SavedCubit>().updateSearchQuery(value),
        );
      },
      decoration: InputDecoration(
        hintText: AppStrings.searchBookmarks,
        prefixIcon: const Icon(LucideIcons.search),
        suffixIcon: state.searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  context.read<SavedCubit>().updateSearchQuery('');
                },
                icon: const Icon(LucideIcons.x),
              ),
      ),
    );
  }

  Widget _buildSortControls(BuildContext context, SavedState state) {
    if (state.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final directionIcon = state.sortDirection == SortDirection.asc
        ? LucideIcons.arrowUp
        : LucideIcons.arrowDown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sort by field selection
        Wrap(
          spacing: AppDimensions.paddingSM,
          runSpacing: AppDimensions.paddingSM,
          children: [
            ChoiceChip(
              label: const Text('Newest'),
              selected:
                  state.sortByField == 'savedAt' &&
                  state.sortDirection == SortDirection.desc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'savedAt',
                sortDirection: SortDirection.desc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Oldest'),
              selected:
                  state.sortByField == 'savedAt' &&
                  state.sortDirection == SortDirection.asc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'savedAt',
                sortDirection: SortDirection.asc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Title A-Z'),
              selected:
                  state.sortByField == 'title' &&
                  state.sortDirection == SortDirection.asc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'title',
                sortDirection: SortDirection.asc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
            ChoiceChip(
              label: const Text('Title Z-A'),
              selected:
                  state.sortByField == 'title' &&
                  state.sortDirection == SortDirection.desc,
              onSelected: (_) => context.read<SavedCubit>().updateSort(
                sortByField: 'title',
                sortDirection: SortDirection.desc,
              ),
              selectedColor: colorScheme.primaryContainer,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        // Sort direction toggle
        Tooltip(
          message: 'Toggle sort direction',
          child: IconButton.filled(
            onPressed: () => context.read<SavedCubit>().toggleSortDirection(),
            icon: Icon(directionIcon, size: 20),
            tooltip: state.sortDirection == SortDirection.asc
                ? 'Ascending'
                : 'Descending',
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          children: [
            Icon(
              LucideIcons.searchX,
              size: AppDimensions.iconXL,
              color: colorScheme.outline,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              AppStrings.noBookmarksFoundTitle,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              AppStrings.noBookmarksFoundDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                context.read<SavedCubit>().updateSearchQuery('');
              },
              child: const Text(AppStrings.clearSearch),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSectionLG),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
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
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.bookmark,
                  size: AppDimensions.imageLG,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              Positioned(
                bottom: AppDimensions.positionOffsetSM,
                right: AppDimensions.positionOffsetSM,
                child: Container(
                  width: AppDimensions.imageMD,
                  height: AppDimensions.imageMD,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: const [AppShadows.ghost],
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: AppDimensions.iconLG,
                    color: colorScheme.primary,
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
              color: colorScheme.onSurfaceVariant,
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
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
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

  Widget _buildProTipBanner(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        border: Border.all(
          color: colorScheme.tertiaryContainer.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.lightbulb,
            size: AppDimensions.iconLG,
            color: colorScheme.onTertiaryContainer,
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
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  AppStrings.proTipContent,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onTertiaryContainer,
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
    final colorScheme = Theme.of(context).colorScheme;
    final photoUrl = user?.photoUrl ?? '';

    return AppBar(
      backgroundColor: colorScheme.surfaceContainerLowest.withValues(
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
                    fallbackIconColor: colorScheme.primary,
                  )
                : Container(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      LucideIcons.bookmark,
                      color: colorScheme.primary,
                    ),
                  ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.navSaved,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
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
          icon: Icon(LucideIcons.refreshCw, color: colorScheme.outline),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard({required this.bookmark});
  final BookmarkedFormula bookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'SAVED ${_formatDate(bookmark.savedAt)}',
                    style: AppTextStyles.overline.copyWith(
                      color: colorScheme.outline,
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
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: colorScheme.surfaceContainerHigh),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Math.tex(
                  bookmark.formula,
                  textStyle: AppTextStyles.headlineSmall.copyWith(
                    color: colorScheme.onSurface,
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
  const _SavedChapterCard({required this.chapter});
  final BookmarkedChapter chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'SAVED ${_formatDate(chapter.savedAt)}',
                        style: AppTextStyles.overline.copyWith(
                          color: colorScheme.outline,
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
                  color: colorScheme.onSurfaceVariant,
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

class _SavedNoteCard extends StatelessWidget {
  const _SavedNoteCard({required this.note});
  final SavedNote note;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: LucideIcons.stickyNote,
                backgroundColor: colorScheme.secondaryContainer.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
                iconColor: colorScheme.secondary,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.subject,
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'SAVED ${_formatDate(note.savedAt)}',
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            note.title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            note.content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: AppDimensions.lineHeightDefault,
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
