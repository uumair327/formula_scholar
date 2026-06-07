import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';

const Object _unset = Object();

enum SavedStatus { initial, loading, loaded, error }

/// State for the Saved/Bookmarks feature (Formula Vault).
///
/// Tracks sort-by-field, sort direction, and subject filter as separate
/// properties, following golden rule: Sorting authority is server-side
/// (Firestore query).
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
    this.selectedSubjectFilter,
    this.lastRemovedBookmark,
    this.lastRemovedChapter,
    this.lastRemovedNote,
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

  /// The currently active subject filter. Null means "All".
  final String? selectedSubjectFilter;

  /// Cached last-removed items for undo support.
  final BookmarkedFormula? lastRemovedBookmark;
  final BookmarkedChapter? lastRemovedChapter;
  final SavedNote? lastRemovedNote;

  bool get isEmpty => bookmarks.isEmpty && chapters.isEmpty && notes.isEmpty;

  // ─── Vault Stats ──────────────────────────────────────────

  int get totalFormulas => bookmarks.length;
  int get totalChapters => chapters.length;
  int get totalNotes => notes.length;

  /// Unique subject names across all bookmarks and chapters.
  Set<String> get availableSubjects {
    final subjects = <String>{};
    for (final b in bookmarks) {
      if (b.subject.isNotEmpty) subjects.add(b.subject);
    }
    for (final c in chapters) {
      if (c.subjectName.isNotEmpty) subjects.add(c.subjectName);
    }
    return subjects;
  }

  int get totalSubjects => availableSubjects.length;

  // ─── Filtered Getters (search + subject) ──────────────────

  /// Returns bookmarks filtered by [searchQuery] and [selectedSubjectFilter].
  List<BookmarkedFormula> get filteredBookmarks {
    var result = bookmarks;

    // Subject filter
    if (selectedSubjectFilter != null) {
      result = result
          .where((b) => b.subject == selectedSubjectFilter)
          .toList();
    }

    // Search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (b) =>
                b.title.toLowerCase().contains(query) ||
                b.subject.toLowerCase().contains(query) ||
                b.formula.toLowerCase().contains(query),
          )
          .toList();
    }

    return result;
  }

  /// Returns chapters filtered by [searchQuery] and [selectedSubjectFilter].
  List<BookmarkedChapter> get filteredChapters {
    var result = chapters;

    // Subject filter
    if (selectedSubjectFilter != null) {
      result = result
          .where((c) => c.subjectName == selectedSubjectFilter)
          .toList();
    }

    // Search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (c) =>
                c.chapterName.toLowerCase().contains(query) ||
                c.subjectName.toLowerCase().contains(query),
          )
          .toList();
    }

    return result;
  }

  /// Returns notes filtered by [searchQuery] (notes don't have subjects).
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
    Object? selectedSubjectFilter = _unset,
    Object? lastRemovedBookmark = _unset,
    Object? lastRemovedChapter = _unset,
    Object? lastRemovedNote = _unset,
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
      selectedSubjectFilter: identical(selectedSubjectFilter, _unset)
          ? this.selectedSubjectFilter
          : selectedSubjectFilter as String?,
      lastRemovedBookmark: identical(lastRemovedBookmark, _unset)
          ? this.lastRemovedBookmark
          : lastRemovedBookmark as BookmarkedFormula?,
      lastRemovedChapter: identical(lastRemovedChapter, _unset)
          ? this.lastRemovedChapter
          : lastRemovedChapter as BookmarkedChapter?,
      lastRemovedNote: identical(lastRemovedNote, _unset)
          ? this.lastRemovedNote
          : lastRemovedNote as SavedNote?,
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
    selectedSubjectFilter,
    lastRemovedBookmark,
    lastRemovedChapter,
    lastRemovedNote,
  ];
}
