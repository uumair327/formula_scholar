import 'dart:async';
import '../../domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';

import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState>
    with CubitFailureLogger<SearchState> {
  SearchCubit({required SearchFormulasUseCase searchFormulas})
    : _searchFormulas = searchFormulas,
      super(const SearchState());

  final SearchFormulasUseCase _searchFormulas;
  Timer? _debounce;

  @override
  String get logTag => AppLogTags.searchCubit;

  void search(String query, {String? curriculumKey}) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: query));

    _debounce = Timer(AppDurations.debounceDefault, () async {
      final result = await _searchFormulas(query, curriculumKey: curriculumKey);
      if (isClosed) return;
      switch (result) {
        case Success(:final data):
          emit(state.copyWith(status: SearchStatus.loaded, results: data));
        case Error(:final failure):
          logFailure('search "$query"', failure);
          emit(
            state.copyWith(
              status: SearchStatus.error,
              errorMessage: failure.message,
            ),
          );
      }
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    emit(const SearchState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
