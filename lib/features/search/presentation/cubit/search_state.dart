import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<SearchResult> results;
  final String? errorMessage;

  bool get isEmpty => results.isEmpty && status == SearchStatus.loaded;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<SearchResult>? results,
    Object? errorMessage = _unset,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, query, results, errorMessage];
}

const Object _unset = Object();
