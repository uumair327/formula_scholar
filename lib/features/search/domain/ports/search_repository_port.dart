import '../../../../core/error/result.dart';
import '../entities/search_result.dart';

abstract interface class SearchRepositoryPort {
  Future<Result<List<SearchResult>>> searchFormulas(
    String query, {
    String? curriculumKey,
  });
}
