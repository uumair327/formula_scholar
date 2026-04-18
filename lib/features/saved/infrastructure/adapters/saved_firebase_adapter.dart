import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: SavedDataSourcePort)
class SavedFirebaseAdapter implements SavedDataSourcePort {

  SavedFirebaseAdapter(this._firestore, this._firebaseAuth);
  static const int _documentIdQueryChunkSize = 30;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<BookmarkedFormula>> getBookmarks({
    required String curriculumKey,
  }) async {
    AppLogger.trace(
      'getBookmarks() fetching from Firestore for curriculum=$curriculumKey',
      tag: AppLogTags.savedDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .where('curriculumKey', isEqualTo: curriculumKey)
        .get();

    return snapshot.docs.map((doc) {
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
  }

  @override
  Future<List<BookmarkedChapter>> getSavedChapters({
    required String curriculumKey,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const [];
    }

    final subjectDocs = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .doc(curriculumKey)
        .collection('subjects')
        .get();

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

    // Legacy fallback: flat docs under users/{uid}/saved_chapters with
    // {subjectId, subject, chapters, curriculumKey?}.
    final legacyDocs = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .get();

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
        final chapterSnapshot = await _firestore
            .collection('subjects')
            .doc(subjectId)
            .collection('chapters')
            .where(FieldPath.documentId, whereIn: idChunk)
            .get();
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

    chapters.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return chapters;
  }

  @override
  Future<List<SavedNote>> getSavedNotes({required String curriculumKey}) async {
    AppLogger.trace(
      'getSavedNotes() fetching from Firestore for curriculum=$curriculumKey',
      tag: AppLogTags.savedDataSource,
    );

    final snapshot = await _firestore
        .collection('saved_notes')
        .where('curriculumKey', isEqualTo: curriculumKey)
        .get();

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

    notes.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return notes;
  }

  @override
  Future<void> removeBookmark(String formulaId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const CacheException(
        message: 'User must be logged in to remove a bookmark',
      );
    }
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(formulaId)
        .delete();
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

    final subjectRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .doc(curriculumKey)
        .collection('subjects')
        .doc(subjectId);

    final subjectDoc = await subjectRef.get();
    final chapters =
        (subjectDoc.data()?['chapters'] as List<dynamic>?)
            ?.whereType<String>()
            .toList() ??
        const <String>[];

    if (chapters.contains(chapterId)) {
      final remaining = chapters.where((id) => id != chapterId).toList();
      if (remaining.isEmpty) {
        await subjectRef.delete();
      } else {
        await subjectRef.update({
          'chapters': remaining,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    // Legacy fallback: remove chapter from flat documents that may still hold
    // {subjectId, subject, chapters, curriculumKey?} under saved_chapters.
    final legacyDocs = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .where('subjectId', isEqualTo: subjectId)
        .get();

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
        await legacyDoc.reference.delete();
      } else {
        await legacyDoc.reference.update({
          'chapters': remaining,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
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
}
