import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum SavedStatus { initial, loading, loaded, error }

/// State for the Saved/Bookmarks feature.
class SavedState extends Equatable {
  final SavedStatus status;
  final List<BookmarkedFormula> bookmarks;
  final String? errorMessage;

  const SavedState({
    this.status = SavedStatus.initial,
    this.bookmarks = const [],
    this.errorMessage,
  });

  bool get isEmpty => bookmarks.isEmpty;

  SavedState copyWith({
    SavedStatus? status,
    List<BookmarkedFormula>? bookmarks,
    String? errorMessage,
  }) {
    return SavedState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookmarks, errorMessage];
}
