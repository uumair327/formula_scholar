import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../widgets/widgets.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                final curr = context.read<CurriculumCubit>().state.curriculum;
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
          return Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: SavedAppBar(),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.only(
                  start: AppDimensions.paddingXXL,
                  end: AppDimensions.paddingXXL,
                  top: AppDimensions.paddingXXL,
                  bottom: AppDimensions.bottomNavPadding,
                ),
                child: Column(
                  children: [
                    EntranceWrapper.stagger(index: 0, child: const SizedBox(height: AppDimensions.paddingSection)),
                    EntranceWrapper.stagger(index: 1, child: const EmptyBookmarksState()),
                    EntranceWrapper.stagger(index: 2, child: const SizedBox(height: AppDimensions.paddingSection)),
                    EntranceWrapper.stagger(index: 3, child: const ProTipBanner()),
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

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SavedAppBar(),
          ),
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
                const SavedSearchBar(),
                const SizedBox(height: AppDimensions.paddingLG),
                SavedSortControls(state: state),
                const SizedBox(height: AppDimensions.paddingXXL),
                if (hasSearchQuery && !state.hasFilteredResults)
                  NoSearchResultsState(
                    onClearSearch: () =>
                        context.read<SavedCubit>().updateSearchQuery(''),
                  ),
                if (!hasSearchQuery || state.hasFilteredResults) ...[
                  if (filteredChapters.isNotEmpty) ...[
                    EntranceWrapper.stagger(
                      index: 0,
                      child: Text(
                        AppStrings.savedChapters,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    ...filteredChapters.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingLG,
                        ),
                        child: EntranceWrapper.stagger(
                          index: 1 + entry.key,
                          child: SavedChapterCard(chapter: entry.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                  ],
                  if (filteredBookmarks.isNotEmpty) ...[
                    EntranceWrapper.stagger(
                      index: filteredChapters.length + 1,
                      child: Text(
                        AppStrings.savedFormulas,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    ...filteredBookmarks.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingLG,
                        ),
                        child: EntranceWrapper.stagger(
                          index: filteredChapters.length + 2 + entry.key,
                          child: BookmarkCard(bookmark: entry.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),
                  ],
                  if (filteredNotes.isNotEmpty) ...[
                    EntranceWrapper.stagger(
                      index: filteredChapters.length + filteredBookmarks.length + 2,
                      child: Text(
                        AppStrings.savedNotes,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    ...filteredNotes.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingLG,
                        ),
                        child: EntranceWrapper.stagger(
                          index: filteredChapters.length + filteredBookmarks.length + 3 + entry.key,
                          child: SavedNoteCard(note: entry.value),
                        ),
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
  }
}
