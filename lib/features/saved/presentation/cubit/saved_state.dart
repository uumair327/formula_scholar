import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum SavedStatus { initial, loading, loaded, error }

/// State for the Saved/Bookmarks feature.
///
/// Tracks both sort-by-field and sort direction as separate properties,
/// following golden rule: Sorting authority is server-side (Firestore query).
class SavedState extends Equatable {
  const SavedState({
    this.status = SavedStatus.initial,
    this.bookmarks = const [],
    this.chapters = const [],
    this.notes = const [],
    this.searchQuery = '',
    this.sortByField = 'savedAt',
    this.sortDirection = SortDirection.desc,
    this.errorMessage,
  });
  final SavedStatus status;
  final List<BookmarkedFormula> bookmarks;
  final List<BookmarkedChapter> chapters;
  final List<SavedNote> notes;
  final String searchQuery;
  final String sortByField;
  final SortDirection sortDirection;
  final String? errorMessage;

  bool get isEmpty => bookmarks.isEmpty && chapters.isEmpty && notes.isEmpty;

  List<BookmarkedFormula> get filteredBookmarks {
    return bookmarks;
  }

  List<BookmarkedChapter> get filteredChapters {
    return chapters;
  }

  List<SavedNote> get filteredNotes {
    return notes;
  }

  bool get hasFilteredResults {
    return bookmarks.isNotEmpty || chapters.isNotEmpty || notes.isNotEmpty;
  }

  SavedState copyWith({
    SavedStatus? status,
    List<BookmarkedFormula>? bookmarks,
    List<BookmarkedChapter>? chapters,
    List<SavedNote>? notes,
    String? searchQuery,
    String? sortByField,
    SortDirection? sortDirection,
    Object? errorMessage = _unset,
  }) {
    return SavedState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      chapters: chapters ?? this.chapters,
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      sortByField: sortByField ?? this.sortByField,
      sortDirection: sortDirection ?? this.sortDirection,
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
    sortByField,
    sortDirection,
    errorMessage,
  ];
}
