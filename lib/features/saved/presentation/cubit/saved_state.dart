import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum SavedStatus { initial, loading, loaded, error }

/// State for the Saved/Bookmarks feature.
class SavedState extends Equatable {

  const SavedState({
    this.status = SavedStatus.initial,
    this.bookmarks = const [],
    this.chapters = const [],
    this.notes = const [],
    this.searchQuery = '',
    this.errorMessage,
  });
  final SavedStatus status;
  final List<BookmarkedFormula> bookmarks;
  final List<BookmarkedChapter> chapters;
  final List<SavedNote> notes;
  final String searchQuery;
  final String? errorMessage;

  bool get isEmpty => bookmarks.isEmpty && chapters.isEmpty && notes.isEmpty;

  List<BookmarkedFormula> get filteredBookmarks {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return bookmarks;

    return bookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(query) ||
          bookmark.subject.toLowerCase().contains(query) ||
          bookmark.formula.toLowerCase().contains(query);
    }).toList();
  }

  List<BookmarkedChapter> get filteredChapters {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return chapters;

    return chapters.where((chapter) {
      return chapter.chapterName.toLowerCase().contains(query) ||
          chapter.chapterSubtitle.toLowerCase().contains(query) ||
          chapter.subjectName.toLowerCase().contains(query);
    }).toList();
  }

  List<SavedNote> get filteredNotes {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return notes;

    return notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.subject.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
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
    Object? errorMessage = _unset,
  }) {
    return SavedState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      chapters: chapters ?? this.chapters,
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
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
    errorMessage,
  ];
}
