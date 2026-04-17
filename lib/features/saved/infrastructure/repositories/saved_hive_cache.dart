import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

/// Hive-backed cache for bookmarked formulas, enabling offline access.
@LazySingleton(as: SavedCachePort)
class SavedHiveCache implements SavedCachePort {
  static const String _boxName = 'saved_cache';
  static const String _bookmarksKey = 'bookmarks';
  static const String _savedChaptersKey = 'saved_chapters';
  static const String _savedNotesKey = 'saved_notes';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  @override
  Future<void> cacheBookmarks(List<BookmarkedFormula> bookmarks) async {
    final box = await _box();
    await box.put(
      _bookmarksKey,
      bookmarks
          .map(
            (b) => {
              'id': b.id,
              'title': b.title,
              'subject': b.subject,
              'formula': b.formula,
              'curriculumKey': b.curriculumKey,
              'savedAt': b.savedAt.toIso8601String(),
            },
          )
          .toList(),
    );
  }

  @override
  Future<void> cacheSavedChapters(List<BookmarkedChapter> chapters) async {
    final box = await _box();
    await box.put(
      _savedChaptersKey,
      chapters
          .map(
            (c) => {
              'id': c.id,
              'chapterId': c.chapterId,
              'chapterName': c.chapterName,
              'chapterSubtitle': c.chapterSubtitle,
              'subjectId': c.subjectId,
              'subjectName': c.subjectName,
              'curriculumKey': c.curriculumKey,
              'savedAt': c.savedAt.toIso8601String(),
            },
          )
          .toList(),
    );
  }

  @override
  Future<void> cacheSavedNotes(List<SavedNote> notes) async {
    final box = await _box();
    await box.put(
      _savedNotesKey,
      notes
          .map(
            (note) => {
              'id': note.id,
              'title': note.title,
              'subject': note.subject,
              'content': note.content,
              'curriculumKey': note.curriculumKey,
              'savedAt': note.savedAt.toIso8601String(),
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<BookmarkedFormula>> getBookmarks() async {
    final box = await _box();
    final cached = box.get(_bookmarksKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => BookmarkedFormula(
            id: item['id'] as String? ?? '',
            title: item['title'] as String? ?? '',
            subject: item['subject'] as String? ?? '',
            formula: item['formula'] as String? ?? '',
            curriculumKey: item['curriculumKey'] as String? ?? '',
            savedAt:
                DateTime.tryParse(item['savedAt'] as String? ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
  }

  @override
  Future<List<BookmarkedChapter>> getSavedChapters() async {
    final box = await _box();
    final cached = box.get(_savedChaptersKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => BookmarkedChapter(
            id: item['id'] as String? ?? '',
            chapterId: item['chapterId'] as String? ?? '',
            chapterName: item['chapterName'] as String? ?? '',
            chapterSubtitle: item['chapterSubtitle'] as String? ?? '',
            subjectId: item['subjectId'] as String? ?? '',
            subjectName: item['subjectName'] as String? ?? '',
            curriculumKey: item['curriculumKey'] as String? ?? '',
            savedAt:
                DateTime.tryParse(item['savedAt'] as String? ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
  }

  @override
  Future<List<SavedNote>> getSavedNotes() async {
    final box = await _box();
    final cached = box.get(_savedNotesKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => SavedNote(
            id: item['id'] as String? ?? '',
            title: item['title'] as String? ?? '',
            subject: item['subject'] as String? ?? '',
            content: item['content'] as String? ?? '',
            curriculumKey: item['curriculumKey'] as String? ?? '',
            savedAt:
                DateTime.tryParse(item['savedAt'] as String? ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
  }
}
