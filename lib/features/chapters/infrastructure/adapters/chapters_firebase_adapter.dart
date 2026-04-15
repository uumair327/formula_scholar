import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: ChaptersDataSourcePort)
class ChaptersFirebaseAdapter implements ChaptersDataSourcePort {
  ChaptersFirebaseAdapter(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<Chapter>> getChapters(
    String subjectId,
    String curriculumKey,
  ) async {
    AppLogger.trace(
      'getChapters($subjectId, curriculum=$curriculumKey) fetching from Firestore',
      tag: AppLogTags.chaptersDataSource,
    );

    // 1. Fetch static chapters
    final snapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .get();

    final uid = _firebaseAuth.currentUser?.uid;

    // 2. Fetch user progress for this subject (if authenticated)
    final progressMap = <String, dynamic>{};
    final savedChapterIds = <String>{};
    if (uid != null) {
      final progressSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc(subjectId)
          .collection('chapters')
          .get();

      for (final doc in progressSnapshot.docs) {
        progressMap[doc.id] = doc.data();
      }

      // Preferred shape: users/{uid}/saved_chapters/{curriculumKey}/subjects/{subjectId}
      final subjectSavedDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_chapters')
          .doc(curriculumKey)
          .collection('subjects')
          .doc(subjectId)
          .get();
      final subjectSavedChapters =
          (subjectSavedDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
      for (final chapterId in subjectSavedChapters) {
        if (chapterId is String && chapterId.isNotEmpty) {
          savedChapterIds.add(chapterId);
        }
      }

      // Legacy fallback: users/{uid}/saved_chapters/{curriculumKey}
      // with a direct `chapters` array.
      final legacySavedDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_chapters')
          .doc(curriculumKey)
          .get();
      final legacyChapters =
          (legacySavedDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
      for (final chapterId in legacyChapters) {
        if (chapterId is String && chapterId.isNotEmpty) {
          savedChapterIds.add(chapterId);
        }
      }

      // Extra compatibility: older experiments with subject documents under
      // every saved_chapters doc.
      final savedSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_chapters')
          .get();

      for (final doc in savedSnapshot.docs) {
        final data = doc.data();
        final docSubjectId = data['subjectId'] as String?;

        // Legacy docs may not have subjectId; skip strict mismatch.
        if (docSubjectId != null && docSubjectId != subjectId) {
          continue;
        }

        final chapters = (data['chapters'] as List<dynamic>?) ?? const [];
        for (final chapterId in chapters) {
          if (chapterId is String && chapterId.isNotEmpty) {
            savedChapterIds.add(chapterId);
          }
        }
      }
    }

    // 3. Merge data — always use doc.id as the canonical key
    return snapshot.docs.map((doc) {
      final data = doc.data();
      // Look up progress by doc.id first, then by data['id'] as fallback
      final progressData = progressMap[doc.id] ?? progressMap[data['id']] ?? {};
      final hasProgress = (progressData as Map).isNotEmpty;

      // Status: prefer progress record, fall back to static chapter data
      final statusStr = hasProgress
          ? progressData['status'] as String?
          : data['status'] as String?;
      ChapterStatus status = ChapterStatus.notStarted;
      if (statusStr == 'inProgress') status = ChapterStatus.inProgress;
      if (statusStr == 'locked') status = ChapterStatus.locked;

      // Completed formulas from progress (static has 0 by default)
      final completedFormulas = hasProgress
          ? (progressData['completedFormulas'] ?? 0)
          : (data['completedFormulas'] ?? 0);
      final totalFormulas = data['totalFormulas'] ?? 1;

      // Calculate progress (0–100)
      double progressPercent;
      if (hasProgress && progressData['progressPercent'] != null) {
        progressPercent = (progressData['progressPercent'] as num).toDouble();
      } else if (data['progressPercent'] != null) {
        progressPercent = (data['progressPercent'] as num).toDouble();
      } else {
        progressPercent = totalFormulas > 0
            ? (completedFormulas / totalFormulas) * 100.0
            : 0.0;
      }
      // Normalise: if stored as 0–1, scale to 0–100
      if (progressPercent > 0 && progressPercent <= 1.0) {
        progressPercent *= 100;
      }

      return Chapter(
        id: data['id'] ?? doc.id,
        name: data['name'] ?? '',
        subtitle: data['subtitle'] ?? '',
        completedFormulas: completedFormulas,
        totalFormulas: totalFormulas,
        progressPercent: progressPercent,
        status: status,
        isSaved: savedChapterIds.contains((data['id'] ?? doc.id) as String),
      );
    }).toList();
  }

  @override
  Future<List<MasteryTool>> getMasteryTools(String subjectId) async {
    final snapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('mastery_tools')
        .orderBy('displayOrder')
        .get();

    if (snapshot.docs.isEmpty) {
      return const [
        MasteryTool(
          id: 'video_lessons',
          label: 'Video Lessons',
          iconName: 'graduationCap',
          category: 'guided_learning',
          isEnabled: false,
          supportSubtitle:
              'Video Lessons are currently being prepared. Contact support if you need access to guided tutorial content.',
          displayOrder: 1,
        ),
        MasteryTool(
          id: 'practice_quiz',
          label: 'Practice Quiz',
          iconName: 'helpCircle',
          category: 'assessment',
          isEnabled: true,
          displayOrder: 2,
          routeName: 'practice',
        ),
        MasteryTool(
          id: 'cheat_sheets',
          label: 'Cheat Sheets',
          iconName: 'fileText',
          category: 'quick_reference',
          isEnabled: false,
          supportSubtitle:
              'Cheat Sheets provide quick formula reference guides. Contact support to request this feature for your curriculum.',
          displayOrder: 3,
        ),
        MasteryTool(
          id: 'visualizer_3d',
          label: 'Visualizer 3D',
          iconName: 'box',
          category: 'visual_learning',
          isEnabled: false,
          supportSubtitle:
              '3D Visualizer helps understand geometric concepts. Contact support to request 3D visualization tools.',
          displayOrder: 4,
        ),
      ];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return MasteryTool(
        id: data['id'] as String? ?? doc.id,
        label: data['label'] as String? ?? doc.id,
        iconName: data['iconName'] as String? ?? 'helpCircle',
        category: data['category'] as String? ?? 'general',
        isEnabled: data['isEnabled'] as bool? ?? false,
        supportSubtitle: data['supportSubtitle'] as String?,
        displayOrder: data['displayOrder'] as int? ?? 0,
        routeName: data['routeName'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> toggleChapterBookmark(
    Chapter chapter,
    String subjectName,
    String subjectId,
    String curriculumKey,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }

    AppLogger.trace(
      'toggleChapterBookmark($subjectName, ${chapter.id}) for curriculum: $curriculumKey',
      tag: AppLogTags.chaptersDataSource,
    );

    final bookmarkRootRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .doc(curriculumKey);

    final bookmarkRef = bookmarkRootRef.collection('subjects').doc(subjectId);

    final doc = await bookmarkRef.get();
    final savedChapters = (doc.data()?['chapters'] as List<dynamic>?) ?? [];

    // Toggle bookmark state
    if (savedChapters.contains(chapter.id)) {
      // Remove from saved
      await bookmarkRef.update({
        'chapters': FieldValue.arrayRemove([chapter.id]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.info(
        'Chapter ${chapter.id} removed from saved',
        tag: AppLogTags.chaptersDataSource,
      );
    } else {
      // Add to saved
      await bookmarkRef.set({
        'subject': subjectName,
        'subjectId': subjectId,
        'chapters': FieldValue.arrayUnion([chapter.id]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await bookmarkRootRef.set({
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      AppLogger.info(
        'Chapter ${chapter.id} added to saved',
        tag: AppLogTags.chaptersDataSource,
      );
    }
  }

  @override
  Future<bool> isChapterBookmarked(
    String chapterId,
    String subjectId,
    String curriculumKey,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return false;
    }

    final subjectDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .doc(curriculumKey)
        .collection('subjects')
        .doc(subjectId)
        .get();
    final scopedSavedChapters =
        (subjectDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
    if (scopedSavedChapters.contains(chapterId)) {
      return true;
    }

    // Legacy fallback: chapter ids directly under saved_chapters/{curriculumKey}
    final legacyDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_chapters')
        .doc(curriculumKey)
        .get();

    final savedChapters =
        (legacyDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
    return savedChapters.contains(chapterId);
  }
}
