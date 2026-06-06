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
    this.isSavingNote = false,
  });
  final SavedStatus status;
  final List<BookmarkedFormula> bookmarks;
  final List<BookmarkedChapter> chapters;
  final List<SavedNote> notes;
  final String searchQuery;
  final String sortByField;
  final SortDirection sortDirection;
  final String? errorMessage;
  final bool isSavingNote;

  bool get isEmpty => bookmarks.isEmpty && chapters.isEmpty && notes.isEmpty;

  /// Returns bookmarks filtered by [searchQuery] (matches title or subject).
  List<BookmarkedFormula> get filteredBookmarks {
    if (searchQuery.isEmpty) return bookmarks;
    final query = searchQuery.toLowerCase();
    return bookmarks
        .where(
          (b) =>
              b.title.toLowerCase().contains(query) ||
              b.subject.toLowerCase().contains(query) ||
              b.formula.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Returns chapters filtered by [searchQuery] (matches chapter name or subject).
  List<BookmarkedChapter> get filteredChapters {
    if (searchQuery.isEmpty) return chapters;
    final query = searchQuery.toLowerCase();
    return chapters
        .where(
          (c) =>
              c.chapterName.toLowerCase().contains(query) ||
              c.subjectName.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Returns notes filtered by [searchQuery] (matches title or content).
  List<SavedNote> get filteredNotes {
    if (searchQuery.isEmpty) return notes;
    final query = searchQuery.toLowerCase();
    return notes
        .where(
          (n) =>
              n.title.toLowerCase().contains(query) ||
              n.content.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Whether any filtered results exist.
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
    String? sortByField,
    SortDirection? sortDirection,
    Object? errorMessage = _unset,
    bool? isSavingNote,
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
      isSavingNote: isSavingNote ?? this.isSavingNote,
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
    isSavingNote,
  ];
}
