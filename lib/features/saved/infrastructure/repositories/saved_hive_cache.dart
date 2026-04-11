import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

/// Hive-backed cache for bookmarked formulas, enabling offline access.
@LazySingleton(as: SavedCachePort)
class SavedHiveCache implements SavedCachePort {
  static const String _boxName = 'saved_cache';
  static const String _bookmarksKey = 'bookmarks';

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
              'savedAt': b.savedAt.toIso8601String(),
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
            savedAt: DateTime.tryParse(item['savedAt'] as String? ?? '') ??
                DateTime.now(),
          ),
        )
        .toList();
  }
}
