import '../entities/search_result.dart';

abstract interface class SearchDataSourcePort {
  Future<List<SearchResult>> searchFormulas(
    String query, {
    String? curriculumKey,
  });
}
