import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: SearchRepositoryPort)
class SearchRepositoryImpl implements SearchRepositoryPort {
  const SearchRepositoryImpl({required SearchDataSourcePort dataSource})
    : _dataSource = dataSource;
  final SearchDataSourcePort _dataSource;

  @override
  Future<Result<List<SearchResult>>> searchFormulas(
    String query, {
    String? curriculumKey,
  }) {
    return safeOperation(
      tag: AppLogTags.searchRepo,
      operation: 'searchFormulas("$query")',
      execute: () => _dataSource.searchFormulas(query, curriculumKey: curriculumKey),
    );
  }
}
