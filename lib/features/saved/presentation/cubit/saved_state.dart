import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum SavedStatus { initial, loading, loaded, error }

enum SavedSortOrder { recent, oldest, title }

/// State for the Saved/Bookmarks feature.
class SavedState extends Equatable {
  const SavedState({
    this.status = SavedStatus.initial,
    this.bookmarks = const [],
    this.chapters = const [],
    this.notes = const [],
    this.searchQuery = '',
    this.sortOrder = SavedSortOrder.recent,
    this.errorMessage,
  });
  final SavedStatus status;
  final List<BookmarkedFormula> bookmarks;
  final List<BookmarkedChapter> chapters;
  final List<SavedNote> notes;
  final String searchQuery;
  final SavedSortOrder sortOrder;
  final String? errorMessage;

  bool get isEmpty => bookmarks.isEmpty && chapters.isEmpty && notes.isEmpty;

  List<BookmarkedFormula> get filteredBookmarks {
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? bookmarks
        : bookmarks.where((bookmark) {
            return bookmark.title.toLowerCase().contains(query) ||
                bookmark.subject.toLowerCase().contains(query) ||
                bookmark.formula.toLowerCase().contains(query);
          }).toList();

    return _sortBookmarkedFormulas(filtered);
  }

  List<BookmarkedChapter> get filteredChapters {
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? chapters
        : chapters.where((chapter) {
            return chapter.chapterName.toLowerCase().contains(query) ||
                chapter.chapterSubtitle.toLowerCase().contains(query) ||
                chapter.subjectName.toLowerCase().contains(query);
          }).toList();

    return _sortBookmarkedChapters(filtered);
  }

  List<SavedNote> get filteredNotes {
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? notes
        : notes.where((note) {
            return note.title.toLowerCase().contains(query) ||
                note.subject.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query);
          }).toList();

    return _sortSavedNotes(filtered);
  }

  List<BookmarkedFormula> _sortBookmarkedFormulas(
    List<BookmarkedFormula> items,
  ) {
    final sorted = List<BookmarkedFormula>.from(items);
    sorted.sort((left, right) {
      switch (sortOrder) {
        case SavedSortOrder.oldest:
          return left.savedAt.compareTo(right.savedAt);
        case SavedSortOrder.title:
          return left.title.toLowerCase().compareTo(right.title.toLowerCase());
        case SavedSortOrder.recent:
          return right.savedAt.compareTo(left.savedAt);
      }
    });
    return sorted;
  }

  List<BookmarkedChapter> _sortBookmarkedChapters(
    List<BookmarkedChapter> items,
  ) {
    final sorted = List<BookmarkedChapter>.from(items);
    sorted.sort((left, right) {
      switch (sortOrder) {
        case SavedSortOrder.oldest:
          return left.savedAt.compareTo(right.savedAt);
        case SavedSortOrder.title:
          return left.chapterName.toLowerCase().compareTo(
            right.chapterName.toLowerCase(),
          );
        case SavedSortOrder.recent:
          return right.savedAt.compareTo(left.savedAt);
      }
    });
    return sorted;
  }

  List<SavedNote> _sortSavedNotes(List<SavedNote> items) {
    final sorted = List<SavedNote>.from(items);
    sorted.sort((left, right) {
      switch (sortOrder) {
        case SavedSortOrder.oldest:
          return left.savedAt.compareTo(right.savedAt);
        case SavedSortOrder.title:
          return left.title.toLowerCase().compareTo(right.title.toLowerCase());
        case SavedSortOrder.recent:
          return right.savedAt.compareTo(left.savedAt);
      }
    });
    return sorted;
  }

  bool get hasFilteredResults {
    return filteredBookmarks.isNotEmpty ||
        filteredChapters.isNotEmpty ||
        filteredNotes.isNotEmpty;
  }

  SavedState copyWith({
    SavedStatus? status,
    List<BookmarkedFormula>? bookmarks,
    List<BookmarkedChapter>? chapters,
    List<SavedNote>? notes,
    String? searchQuery,
    SavedSortOrder? sortOrder,
    Object? errorMessage = _unset,
  }) {
    return SavedState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      chapters: chapters ?? this.chapters,
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOrder: sortOrder ?? this.sortOrder,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bookmarks,
    chapters,
    notes,
    searchQuery,
    sortOrder,
    errorMessage,
  ];
}
