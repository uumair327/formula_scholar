import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/widgets/widgets.dart';

import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../widgets/widgets.dart';

/// The Formula Vault screen organizing saved formulas, chapters, and notes
/// into clear, interactive tabs with search, sorting, and subject filters.
class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  VaultTab _selectedTab = VaultTab.formulas;

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
          prev.sortDirection != curr.sortDirection ||
          prev.selectedSubjectFilter != curr.selectedSubjectFilter,
      builder: (context, state) {
        if (state.status == SavedStatus.loading ||
            state.status == SavedStatus.initial) {
          return const Scaffold(body: SavedShimmer());
        }

        if (state.status == SavedStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: context.localizedError(fallback: state.errorMessage),
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
                    EntranceWrapper.stagger(
                      index: 0,
                      child: const SizedBox(
                        height: AppDimensions.paddingSection,
                      ),
                    ),
                    EntranceWrapper.stagger(
                      index: 1,
                      child: const EmptyBookmarksState(),
                    ),
                    EntranceWrapper.stagger(
                      index: 2,
                      child: const SizedBox(
                        height: AppDimensions.paddingSection,
                      ),
                    ),
                    EntranceWrapper.stagger(
                      index: 3,
                      child: const ProTipBanner(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final filteredBookmarks = state.filteredBookmarks;
        final filteredChapters = state.filteredChapters;
        final filteredNotes = state.filteredNotes;

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
                VaultTabBar(
                  selectedTab: _selectedTab,
                  onTabChanged: (tab) => setState(() => _selectedTab = tab),
                  formulaCount: filteredBookmarks.length,
                  chapterCount: filteredChapters.length,
                  noteCount: filteredNotes.length,
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                const SavedSearchBar(),
                if (_selectedTab != VaultTab.notes) ...[
                  const SizedBox(height: AppDimensions.paddingLG),
                  const VaultSubjectFilter(),
                ],
                const SizedBox(height: AppDimensions.paddingMD),
                SavedSortControls(state: state),
                const SizedBox(height: AppDimensions.paddingXXL),
                _buildActiveTabContent(
                  context,
                  state,
                  filteredBookmarks,
                  filteredChapters,
                  filteredNotes,
                ),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveTabContent(
    BuildContext context,
    SavedState state,
    List<BookmarkedFormula> filteredBookmarks,
    List<BookmarkedChapter> filteredChapters,
    List<SavedNote> filteredNotes,
  ) {
    final hasSearchQuery = state.searchQuery.trim().isNotEmpty;

    switch (_selectedTab) {
      case VaultTab.formulas:
        if (filteredBookmarks.isEmpty) {
          if (hasSearchQuery) {
            return NoSearchResultsState(
              onClearSearch: () =>
                  context.read<SavedCubit>().updateSearchQuery(''),
            );
          }
          return AppEmptyState(
            title: context.l10n.savedFormulas,
            description: state.selectedSubjectFilter != null
                ? 'No vaulted formulas found for ${state.selectedSubjectFilter}.'
                : 'Formulas you bookmark during study sessions will appear here.',
            mascotMessage: 'No formulas yet! 📐',
          );
        }
        return Column(
          children: filteredBookmarks.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingLG,
              ),
              child: EntranceWrapper.stagger(
                index: entry.key,
                child: BookmarkCard(bookmark: entry.value),
              ),
            ),
          ).toList(),
        );

      case VaultTab.chapters:
        if (filteredChapters.isEmpty) {
          if (hasSearchQuery) {
            return NoSearchResultsState(
              onClearSearch: () =>
                  context.read<SavedCubit>().updateSearchQuery(''),
            );
          }
          return AppEmptyState(
            title: context.l10n.savedChapters,
            description: state.selectedSubjectFilter != null
                ? 'No vaulted chapters found for ${state.selectedSubjectFilter}.'
                : 'Chapters you bookmark will appear here so you can revise entire topics easily.',
            mascotMessage: 'No chapters saved! 📖',
          );
        }
        return Column(
          children: filteredChapters.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingLG,
              ),
              child: EntranceWrapper.stagger(
                index: entry.key,
                child: SavedChapterCard(chapter: entry.value),
              ),
            ),
          ).toList(),
        );

      case VaultTab.notes:
        if (filteredNotes.isEmpty) {
          if (hasSearchQuery) {
            return NoSearchResultsState(
              onClearSearch: () =>
                  context.read<SavedCubit>().updateSearchQuery(''),
            );
          }
          return AppEmptyState(
            title: context.l10n.savedNotes,
            description: 'Personal study notes and formula reminders will appear here.',
            mascotMessage: 'No notes here! ✍️',
          );
        }
        return Column(
          children: filteredNotes.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingLG,
              ),
              child: EntranceWrapper.stagger(
                index: entry.key,
                child: SavedNoteCard(note: entry.value),
              ),
            ),
          ).toList(),
        );
    }
  }
}
