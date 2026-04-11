import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

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
    Object? errorMessage = _unset,
  }) {
    return SavedState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, bookmarks, errorMessage];
}
