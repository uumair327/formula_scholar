import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: SavedDataSourcePort)
class SavedFirebaseAdapter implements SavedDataSourcePort {
  SavedFirebaseAdapter(this._api, this._firebaseAuth);
  static const int _documentIdQueryChunkSize = 30;

  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<BookmarkedFormula>> getBookmarks({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  }) async {
    AppLogger.trace(
      'getBookmarks() fetching from Firestore for curriculum=$curriculumKey, '
      'sortBy=${query.sortByField}, order=${query.sortDirection.name}',
      tag: AppLogTags.savedDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userBookmarks(uid))
          .where('curriculumKey', isEqualTo: curriculumKey)
          .get(),
      tag: AppLogTags.savedDataSource,
    );

    final bookmarks = snapshot.docs.map((doc) {
      final data = doc.data();
      return BookmarkedFormula(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '',
        subject: data['subject'] ?? '',
        formula: data['formula'] ?? '',
        curriculumKey: data['curriculumKey'] ?? curriculumKey,
        savedAt: (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();

    return _applyQuery(bookmarks, query: query);
  }

  @override
  Future<List<BookmarkedChapter>> getSavedChapters({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const [];
    }

    final subjectDocs = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.savedChapterSubjects(uid, curriculumKey))
          .get(),
      tag: AppLogTags.savedDataSource,
    );

    final chapters = <BookmarkedChapter>[];
    final chapterIdsBySubject = <String, Set<String>>{};
    final subjectNameBySubject = <String, String>{};
    final savedAtBySubject = <String, DateTime>{};

    for (final subjectDoc in subjectDocs.docs) {
      final data = subjectDoc.data();
      final subjectId = subjectDoc.id;
      final subjectName = data['subject'] as String? ?? subjectId;
      final savedAt =
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      final chapterIds = _asChapterIds(data['chapters']);

      if (chapterIds.isNotEmpty) {
        chapterIdsBySubject
            .putIfAbsent(subjectId, () => <String>{})
            .addAll(chapterIds);
        subjectNameBySubject[subjectId] = subjectName;
        savedAtBySubject[subjectId] = savedAt;
      }
    }

    final legacyDocs = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedChapters(uid))
          .get(),
      tag: AppLogTags.savedDataSource,
    );

    for (final doc in legacyDocs.docs) {
      if (doc.id == curriculumKey) {
        continue;
      }

      final data = doc.data();
      final subjectId = data['subjectId'] as String?;
      if (subjectId == null || subjectId.isEmpty) {
        continue;
      }

      final legacyCurriculum = data['curriculumKey'] as String?;
      if (legacyCurriculum != null && legacyCurriculum != curriculumKey) {
        continue;
      }

      final chapterIds = _asChapterIds(data['chapters']);
      if (chapterIds.isEmpty) {
        continue;
      }

      chapterIdsBySubject
          .putIfAbsent(subjectId, () => <String>{})
          .addAll(chapterIds);
      subjectNameBySubject.putIfAbsent(
        subjectId,
        () => data['subject'] as String? ?? subjectId,
      );
      savedAtBySubject.putIfAbsent(
        subjectId,
        () => (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }

    for (final entry in chapterIdsBySubject.entries) {
      final subjectId = entry.key;
      final chapterIds = entry.value.toList();
      if (chapterIds.isEmpty) {
        continue;
      }

      final subjectName = subjectNameBySubject[subjectId] ?? subjectId;
      final savedAt = savedAtBySubject[subjectId] ?? DateTime.now();

      final chaptersById = <String, Map<String, dynamic>>{};
      for (final idChunk in _chunk(chapterIds, _documentIdQueryChunkSize)) {
        final chapterSnapshot = await _api.execute(
          () => _api
              .collection(AppFirestoreCollections.subjectChapters(subjectId))
              .where(FieldPath.documentId, whereIn: idChunk)
              .get(),
          tag: AppLogTags.savedDataSource,
        );
        for (final chapterDoc in chapterSnapshot.docs) {
          chaptersById[chapterDoc.id] = chapterDoc.data();
        }
      }

      for (final chapterId in chapterIds) {
        final chapterData =
            chaptersById[chapterId] ?? const <String, dynamic>{};
        chapters.add(
          BookmarkedChapter(
            id: '$subjectId::$chapterId',
            chapterId: chapterId,
            chapterName: chapterData['name'] as String? ?? chapterId,
            chapterSubtitle: chapterData['subtitle'] as String? ?? '',
            subjectId: subjectId,
            subjectName: subjectName,
            curriculumKey: curriculumKey,
            savedAt: savedAt,
          ),
        );
      }
    }

    return _applyQuery(chapters, query: query);
  }

  @override
  Future<List<SavedNote>> getSavedNotes({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  }) async {
    AppLogger.trace(
      'getSavedNotes() fetching from Firestore for curriculum=$curriculumKey, '
      'sortBy=${query.sortByField}, order=${query.sortDirection.name}',
      tag: AppLogTags.savedDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedNotes(uid))
          .where('curriculumKey', isEqualTo: curriculumKey)
          .get(),
      tag: AppLogTags.savedDataSource,
    );

    final notes = snapshot.docs.map((doc) {
      final data = doc.data();
      return SavedNote(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '',
        subject: data['subject'] ?? '',
        content: data['content'] ?? '',
        curriculumKey: data['curriculumKey'] ?? curriculumKey,
        savedAt: (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();

    return _applyQuery(notes, query: query);
  }

  @override
  Future<void> removeBookmark(String formulaId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const CacheException(
        message: 'User must be logged in to remove a bookmark',
      );
    }
    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userBookmarks(uid))
          .doc(formulaId)
          .delete(),
      tag: AppLogTags.savedDataSource,
    );
  }

  @override
  Future<void> removeSavedChapter({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const CacheException(
        message: 'User must be logged in to remove a saved chapter',
      );
    }

    final subjectRef = _api
        .collection(AppFirestoreCollections.savedChapterSubjects(uid, curriculumKey))
        .doc(subjectId);

    final subjectDoc = await _api.execute(
      () => subjectRef.get(),
      tag: AppLogTags.savedDataSource,
    );
    final chapters =
        (subjectDoc.data()?['chapters'] as List<dynamic>?)
            ?.whereType<String>()
            .toList() ??
        const <String>[];

    if (chapters.contains(chapterId)) {
      final remaining = chapters.where((id) => id != chapterId).toList();
      if (remaining.isEmpty) {
        await _api.execute(
          () => subjectRef.delete(),
          tag: AppLogTags.savedDataSource,
        );
      } else {
        await _api.execute(
          () => subjectRef.update({
            'chapters': remaining,
            'updatedAt': FieldValue.serverTimestamp(),
          }),
          tag: AppLogTags.savedDataSource,
        );
      }
    }

    final legacyDocs = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedChapters(uid))
          .where('subjectId', isEqualTo: subjectId)
          .get(),
      tag: AppLogTags.savedDataSource,
    );

    for (final legacyDoc in legacyDocs.docs) {
      final data = legacyDoc.data();
      final legacyCurriculum = data['curriculumKey'] as String?;
      if (legacyCurriculum != null && legacyCurriculum != curriculumKey) {
        continue;
      }

      final legacyChapters = _asChapterIds(data['chapters']);
      if (!legacyChapters.contains(chapterId)) {
        continue;
      }

      final remaining = legacyChapters.where((id) => id != chapterId).toList();
      if (remaining.isEmpty) {
        await _api.execute(
          () => legacyDoc.reference.delete(),
          tag: AppLogTags.savedDataSource,
        );
      } else {
        await _api.execute(
          () => legacyDoc.reference.update({
            'chapters': remaining,
            'updatedAt': FieldValue.serverTimestamp(),
          }),
          tag: AppLogTags.savedDataSource,
        );
      }
    }
  }

  @override
  Future<void> addNote(SavedNote note) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const CacheException(message: 'User must be logged in to add a note');
    }
    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedNotes(uid))
          .doc(note.id)
          .set({
        'id': note.id,
        'title': note.title,
        'subject': note.subject,
        'content': note.content,
        'curriculumKey': note.curriculumKey,
        'savedAt': Timestamp.fromDate(note.savedAt),
        'subjectId': note.subjectId,
        'chapterId': note.chapterId,
        'formulaId': note.formulaId,
        'formulaTitle': note.formulaTitle,
        'formulaLatex': note.formulaLatex,
      }),
      tag: AppLogTags.savedDataSource,
    );
  }

  @override
  Future<void> updateNote(SavedNote note) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const CacheException(message: 'User must be logged in to update a note');
    }
    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedNotes(uid))
          .doc(note.id)
          .update({
        'title': note.title,
        'content': note.content,
        'savedAt': Timestamp.fromDate(note.savedAt),
      }),
      tag: AppLogTags.savedDataSource,
    );
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const CacheException(message: 'User must be logged in to delete a note');
    }
    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedNotes(uid))
          .doc(noteId)
          .delete(),
      tag: AppLogTags.savedDataSource,
    );
  }

  Iterable<List<T>> _chunk<T>(List<T> source, int size) sync* {
    for (var index = 0; index < source.length; index += size) {
      final end = (index + size < source.length) ? index + size : source.length;
      yield source.sublist(index, end);
    }
  }

  List<String> _asChapterIds(dynamic raw) {
    return (raw as List<dynamic>?)
            ?.whereType<String>()
            .where((id) => id.isNotEmpty)
            .toList() ??
        const <String>[];
  }

  List<T> _applyQuery<T>(List<T> items, {required SavedQuery query}) {
    var result = items;
    final search = query.searchQuery.trim().toLowerCase();
    
    if (search.isNotEmpty) {
      result = result.where((item) => _matchesSavedSearch(item, search)).toList();
    }

    result.sort((a, b) {
      int comparison = 0;
      if (query.sortByField == 'title') {
        comparison = _getTitle(a).compareTo(_getTitle(b));
      } else {
        comparison = _getDate(a).compareTo(_getDate(b));
      }
      return query.isDescending ? -comparison : comparison;
    });

    return result;
  }

  String _getTitle(Object? item) {
    if (item is BookmarkedFormula) return item.title.toLowerCase();
    if (item is BookmarkedChapter) return item.chapterName.toLowerCase();
    if (item is SavedNote) return item.title.toLowerCase();
    return '';
  }

  DateTime _getDate(Object? item) {
    if (item is BookmarkedFormula) return item.savedAt;
    if (item is BookmarkedChapter) return item.savedAt;
    if (item is SavedNote) return item.savedAt;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  bool _matchesSavedSearch(Object? item, String search) {
    if (item is BookmarkedFormula) {
      return item.title.toLowerCase().contains(search) ||
          item.subject.toLowerCase().contains(search) ||
          item.formula.toLowerCase().contains(search);
    }

    if (item is BookmarkedChapter) {
      return item.chapterName.toLowerCase().contains(search) ||
          item.chapterSubtitle.toLowerCase().contains(search) ||
          item.subjectName.toLowerCase().contains(search);
    }

    if (item is SavedNote) {
      return item.title.toLowerCase().contains(search) ||
          item.subject.toLowerCase().contains(search) ||
          item.content.toLowerCase().contains(search);
    }

    return false;
  }
}
