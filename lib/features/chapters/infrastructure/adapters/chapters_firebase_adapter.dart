import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: ChaptersDataSourcePort)
class ChaptersFirebaseAdapter implements ChaptersDataSourcePort {
  ChaptersFirebaseAdapter(this._api, this._firebaseAuth);

  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;

  String _resolveLocalizedField(
    Map<String, dynamic> data,
    String key,
    String fallback,
  ) {
    if (!AppLocales.contentLocalizationEnabled) {
      return fallback;
    }
    try {
      final loc = data['localized'] as Map<String, dynamic>?;
      if (loc != null) {
        final localeCode = AppLocales.normalizeContentLocaleCode(
          AppLocales.currentLocaleCode,
        );
        final candidate = loc[localeCode] as Map<String, dynamic>?;
        if (candidate != null &&
            candidate[key] != null &&
            (candidate[key] as String).isNotEmpty) {
          return candidate[key] as String;
        }
        for (final fb in AppLocales.contentLocaleFallbacks(localeCode)) {
          final fbCandidate = loc[fb] as Map<String, dynamic>?;
          if (fbCandidate != null &&
              fbCandidate[key] != null &&
              (fbCandidate[key] as String).isNotEmpty) {
            return fbCandidate[key] as String;
          }
        }
      }
    } catch (_) {}
    return fallback;
  }

  @override
  Future<List<Chapter>> getChapters(
    String subjectId,
    String curriculumKey, {
    String sortBy = 'name',
    bool sortDesc = false,
  }) async {
    AppLogger.trace(
      'getChapters($subjectId, curriculum=$curriculumKey, sortBy=$sortBy, sortDesc=$sortDesc) fetching from Firestore',
      tag: AppLogTags.chaptersDataSource,
    );

    var snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.subjectChapters(subjectId))
          .where(
            Filter.or(
              Filter('isGeneralContent', isEqualTo: true),
              Filter('canonicalScopeTags', arrayContains: curriculumKey),
              Filter('audiences', arrayContains: curriculumKey),
            ),
          )
          .orderBy(sortBy, descending: sortDesc)
          .get(),
      tag: AppLogTags.chaptersDataSource,
    );

    if (snapshot.docs.isEmpty) {
      snapshot = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.subjectChapters(subjectId))
            .orderBy(sortBy, descending: sortDesc)
            .get(),
        tag: AppLogTags.chaptersDataSource,
      );
    }

    final uid = _firebaseAuth.currentUser?.uid;
    final progressMap = <String, dynamic>{};
    final savedChapterIds = <String>{};
    if (uid != null) {
      final progressSnapshot = await _api.execute(
        () => _api
            .collection(
              AppFirestoreCollections.userProgressSubject(uid, subjectId),
            )
            .get(),
        tag: AppLogTags.chaptersDataSource,
      );

      for (final doc in progressSnapshot.docs) {
        progressMap[doc.id] = doc.data();
      }

      final subjectSavedDoc = await _api.execute(
        () => _api
            .collection(
              AppFirestoreCollections.savedChapterSubjects(uid, curriculumKey),
            )
            .doc(subjectId)
            .get(),
        tag: AppLogTags.chaptersDataSource,
      );
      final subjectSavedChapters =
          (subjectSavedDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
      for (final chapterId in subjectSavedChapters) {
        if (chapterId is String && chapterId.isNotEmpty) {
          savedChapterIds.add(chapterId);
        }
      }

      final legacySavedDoc = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.userSavedChapters(uid))
            .doc(curriculumKey)
            .get(),
        tag: AppLogTags.chaptersDataSource,
      );
      final legacyChapters =
          (legacySavedDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
      for (final chapterId in legacyChapters) {
        if (chapterId is String && chapterId.isNotEmpty) {
          savedChapterIds.add(chapterId);
        }
      }

      final savedSnapshot = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.userSavedChapters(uid))
            .get(),
        tag: AppLogTags.chaptersDataSource,
      );

      for (final doc in savedSnapshot.docs) {
        final data = doc.data();
        final docSubjectId = data['subjectId'] as String?;
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

    return snapshot.docs
        .where((doc) {
          final data = doc.data();
          return data['isActive'] != false;
        })
        .map((doc) {
          final data = doc.data();
          final progressData =
              progressMap[doc.id] ?? progressMap[data['id']] ?? {};
          final hasProgress = (progressData as Map).isNotEmpty;

          final statusStr = hasProgress
              ? progressData['status'] as String?
              : data['status'] as String?;
          ChapterStatus status = ChapterStatus.notStarted;
          if (statusStr == 'inProgress') status = ChapterStatus.inProgress;
          if (statusStr == 'locked') status = ChapterStatus.locked;

          final completedFormulas = hasProgress
              ? (progressData['completedFormulas'] ?? 0)
              : (data['completedFormulas'] ?? 0);
          final totalFormulas = data['totalFormulas'] ?? 1;

          double progressPercent;
          if (hasProgress && progressData['progressPercent'] != null) {
            progressPercent = (progressData['progressPercent'] as num)
                .toDouble();
          } else if (data['progressPercent'] != null) {
            progressPercent = (data['progressPercent'] as num).toDouble();
          } else {
            progressPercent = totalFormulas > 0
                ? (completedFormulas / totalFormulas) * 100.0
                : 0.0;
          }
          if (progressPercent > 0 && progressPercent <= 1.0) {
            progressPercent *= 100;
          }

          final name = _resolveLocalizedField(data, 'name', data['name'] ?? '');
          final subtitle = _resolveLocalizedField(
            data,
            'subtitle',
            data['subtitle'] ?? '',
          );

          return Chapter(
            id: data['id'] ?? doc.id,
            name: name,
            subtitle: subtitle,
            completedFormulas: completedFormulas,
            totalFormulas: totalFormulas,
            progressPercent: progressPercent,
            status: status,
            isSaved: savedChapterIds.contains((data['id'] ?? doc.id) as String),
            isGeneralContent: data['isGeneralContent'] ?? false,
            audiences:
                (data['audiences'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                const [],
          );
        })
        .toList();
  }

  @override
  Future<List<MasteryTool>> getMasteryTools(String subjectId) async {
    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.subjectMasteryTools(subjectId))
          .orderBy('displayOrder')
          .get(),
      tag: AppLogTags.chaptersDataSource,
    );

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
          isEnabled: true,
          displayOrder: 3,
          routeName: 'cheatSheet',
        ),
        MasteryTool(
          id: 'visualizer_3d',
          label: 'Visualizer 3D',
          iconName: 'box',
          category: 'visual_learning',
          isEnabled: true,
          displayOrder: 4,
          routeName: 'visualizer_3d',
        ),
        MasteryTool(
          id: 'flashcards',
          label: 'Flashcards',
          iconName: 'creditCard',
          category: 'quick_reference',
          isEnabled: true,
          displayOrder: 5,
          routeName: 'flashcards',
        ),
      ];
    }

    final loadedTools = snapshot.docs
        .where((doc) {
          final data = doc.data();
          return data['isEnabled'] != false;
        })
        .map((doc) {
          final data = doc.data();
          final id = data['id'] as String? ?? doc.id;
          final label = data['label'] as String? ?? doc.id;
          final iconName = data['iconName'] as String? ?? 'helpCircle';
          final category = data['category'] as String? ?? 'general';

          final bool isEnabled = data['isEnabled'] as bool? ?? true;
          String? routeName = data['routeName'] as String?;

          if (id == 'cheat_sheets' || id == 'cheat_sheet') {
            routeName = 'cheatSheet';
          } else if (id == 'visualizer_3d') {
            routeName = 'visualizer_3d';
          } else if (id == 'flashcards') {
            routeName = 'flashcards';
          }

          return MasteryTool(
            id: id,
            label: label,
            iconName: iconName,
            category: category,
            isEnabled: isEnabled,
            supportSubtitle: data['supportSubtitle'] as String?,
            displayOrder: data['displayOrder'] as int? ?? 0,
            routeName: routeName,
          );
        })
        .toList();

    if (!loadedTools.any((t) => t.id == 'flashcards')) {
      loadedTools.add(
        const MasteryTool(
          id: 'flashcards',
          label: 'Flashcards',
          iconName: 'creditCard',
          category: 'quick_reference',
          isEnabled: true,
          displayOrder: 5,
          routeName: 'flashcards',
        ),
      );
    }
    if (!loadedTools.any((t) => t.id == 'cheat_sheets')) {
      loadedTools.add(
        const MasteryTool(
          id: 'cheat_sheets',
          label: 'Cheat Sheets',
          iconName: 'fileText',
          category: 'quick_reference',
          isEnabled: true,
          displayOrder: 3,
          routeName: 'cheatSheet',
        ),
      );
    }
    if (!loadedTools.any((t) => t.id == 'visualizer_3d')) {
      loadedTools.add(
        const MasteryTool(
          id: 'visualizer_3d',
          label: 'Visualizer 3D',
          iconName: 'box',
          category: 'visual_learning',
          isEnabled: true,
          displayOrder: 4,
          routeName: 'visualizer_3d',
        ),
      );
    }

    loadedTools.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return loadedTools;
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

    final bookmarkRootRef = _api
        .collection(AppFirestoreCollections.userSavedChapters(uid))
        .doc(curriculumKey);

    final bookmarkRef = bookmarkRootRef.collection('subjects').doc(subjectId);

    final doc = await _api.execute(
      () => bookmarkRef.get(),
      tag: AppLogTags.chaptersDataSource,
    );
    final savedChapters = (doc.data()?['chapters'] as List<dynamic>?) ?? [];

    if (savedChapters.contains(chapter.id)) {
      await _api.execute(
        () => bookmarkRef.update({
          'chapters': FieldValue.arrayRemove([chapter.id]),
          'updatedAt': FieldValue.serverTimestamp(),
        }),
        tag: AppLogTags.chaptersDataSource,
      );
      AppLogger.info(
        'Chapter ${chapter.id} removed from saved',
        tag: AppLogTags.chaptersDataSource,
      );
    } else {
      await _api.execute(
        () => bookmarkRef.set({
          'subject': subjectName,
          'subjectId': subjectId,
          'chapters': FieldValue.arrayUnion([chapter.id]),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
        tag: AppLogTags.chaptersDataSource,
      );
      await _api.execute(
        () => bookmarkRootRef.set({
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
        tag: AppLogTags.chaptersDataSource,
      );
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

    final subjectDoc = await _api.execute(
      () => _api
          .collection(
            AppFirestoreCollections.savedChapterSubjects(uid, curriculumKey),
          )
          .doc(subjectId)
          .get(),
      tag: AppLogTags.chaptersDataSource,
    );
    final scopedSavedChapters =
        (subjectDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
    if (scopedSavedChapters.contains(chapterId)) {
      return true;
    }

    final legacyDoc = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userSavedChapters(uid))
          .doc(curriculumKey)
          .get(),
      tag: AppLogTags.chaptersDataSource,
    );

    final savedChapters =
        (legacyDoc.data()?['chapters'] as List<dynamic>?) ?? const [];
    return savedChapters.contains(chapterId);
  }
}
