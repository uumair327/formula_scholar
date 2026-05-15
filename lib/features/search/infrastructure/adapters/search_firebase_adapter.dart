import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: SearchDataSourcePort)
class SearchFirebaseAdapter implements SearchDataSourcePort {
  SearchFirebaseAdapter(this._firestore);

  final FirebaseFirestore _firestore;

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

    final subjects = await _firestore.collection('subjects').get();

    for (final subjectDoc in subjects.docs) {
      final subjectId = subjectDoc.id;
      final subjectName = subjectDoc.data()['name'] as String? ?? subjectId;

      final chapters = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .get();

      for (final chapterDoc in chapters.docs) {
        final chapterId = chapterDoc.id;
        final chapterName = chapterDoc.data()['name'] as String? ?? chapterId;

        final formulaRef = _firestore
            .collection('subjects')
            .doc(subjectId)
            .collection('chapters')
            .doc(chapterId)
            .collection('formulas');

        final formulaQuery = curriculumKey != null
            ? formulaRef.where(
                Filter.or(
                  Filter('isGeneralContent', isEqualTo: true),
                  Filter('audiences', arrayContains: curriculumKey),
                ),
              )
            : formulaRef;

        final formulas = await formulaQuery.limit(50).get();

        for (final formulaDoc in formulas.docs) {
          final data = formulaDoc.data();
          final title = (data['title'] as String? ?? '').toLowerCase();
          final description = data['description'] as String? ?? '';
          final descLower = description.toLowerCase();

          if (title.contains(lowerQuery) || descLower.contains(lowerQuery)) {
            final formulaId = formulaDoc.id;
            if (seen.add(formulaId)) {
              results.add(SearchResult(
                id: formulaId,
                title: data['title'] as String? ?? '',
                latex: data['latex'] as String? ?? '',
                description: description,
                subjectId: subjectId,
                subjectName: subjectName,
                chapterId: chapterId,
                chapterName: chapterName,
              ));
            }
          }
        }
      }
    }

    return results;
  }
}
