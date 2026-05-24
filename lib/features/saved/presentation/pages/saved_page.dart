import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../widgets/widgets.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
    final curriculum = context.read<CurriculumCubit>().state.curriculum;
    final cubit = context.read<SavedCubit>();
    if (curriculum != null) {
      Future.microtask(
        () => cubit.loadBookmarks(curriculumKey: curriculum.curriculumKey),
      );
    }
  }

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
          return const Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: SavedAppBar(),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(
                  start: AppDimensions.paddingXXL,
                  end: AppDimensions.paddingXXL,
                  top: AppDimensions.paddingXXL,
                  bottom: AppDimensions.bottomNavPadding,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.paddingSection),
                    EmptyBookmarksState(),
                    SizedBox(height: AppDimensions.paddingSection),
                    ProTipBanner(),
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
                        child: SavedChapterCard(chapter: chapter),
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
                        child: BookmarkCard(bookmark: bookmark),
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
                        child: SavedNoteCard(note: note),
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
