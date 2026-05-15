import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/search_result.dart';
import '../ports/search_repository_port.dart';

@injectable
class SearchFormulasUseCase {
  const SearchFormulasUseCase({required SearchRepositoryPort repository})
    : _repository = repository;
  final SearchRepositoryPort _repository;

  Future<Result<List<SearchResult>>> call(String query, {String? curriculumKey}) {
    AppLogger.trace('SearchFormulasUseCase called: "$query"', tag: AppLogTags.searchUseCase);
    return _repository.searchFormulas(query, curriculumKey: curriculumKey);
  }
}
