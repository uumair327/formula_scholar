import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: SearchDataSourcePort)
class SearchFirebaseAdapter implements SearchDataSourcePort {
  SearchFirebaseAdapter(this._api);

  final FirestoreClientPort _api;

  @override
  Future<List<SearchResult>> searchFormulas(
    String query, {
    String? curriculumKey,
  }) async {
    if (query.trim().isEmpty) return [];

    AppLogger.trace(
      'searchFormulas("$query", curriculumKey=$curriculumKey)',
      tag: AppLogTags.searchDataSource,
    );

    final lowerQuery = query.toLowerCase();
    final results = <SearchResult>[];
    final seen = <String>{};

    final subjects = await _api.execute(
      () => _api.collection(AppFirestoreCollections.subjects).get(),
      tag: AppLogTags.searchDataSource,
    );

    for (final subjectDoc in subjects.docs) {
      if (subjectDoc.data()['isActive'] == false) continue;
      final subjectId = subjectDoc.id;
      final subjectName = subjectDoc.data()['name'] as String? ?? subjectId;

      final chapters = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.subjectChapters(subjectId))
            .get(),
        tag: AppLogTags.searchDataSource,
      );

      for (final chapterDoc in chapters.docs) {
        if (chapterDoc.data()['isActive'] == false) continue;
        final chapterId = chapterDoc.id;
        final chapterName = chapterDoc.data()['name'] as String? ?? chapterId;

        final formulaRef = _api.collection(
          AppFirestoreCollections.chapterFormulas(subjectId, chapterId),
        );

        final formulaQuery = curriculumKey != null
            ? formulaRef.where(
                Filter.or(
                  Filter('isGeneralContent', isEqualTo: true),
                  Filter('audiences', arrayContains: curriculumKey),
                ),
              )
            : formulaRef;

        final formulas = await _api.execute(
          () => formulaQuery.limit(50).get(),
          tag: AppLogTags.searchDataSource,
        );

        for (final formulaDoc in formulas.docs) {
          final data = formulaDoc.data();
          if (data['isActive'] == false) continue;
          final title = (data['title'] as String? ?? '').toLowerCase();
          final description = data['description'] as String? ?? '';
          final descLower = description.toLowerCase();

          if (title.contains(lowerQuery) || descLower.contains(lowerQuery)) {
            final formulaId = formulaDoc.id;
            if (seen.add(formulaId)) {
              results.add(
                SearchResult(
                  id: formulaId,
                  title: data['title'] as String? ?? '',
                  latex: data['latex'] as String? ?? '',
                  description: description,
                  subjectId: subjectId,
                  subjectName: subjectName,
                  chapterId: chapterId,
                  chapterName: chapterName,
                ),
              );
            }
          }
        }
      }
    }

    return results;
  }
}
