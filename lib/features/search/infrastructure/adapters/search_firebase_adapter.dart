import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

class _CachedSearchItem {
  const _CachedSearchItem({
    required this.id,
    required this.title,
    required this.latex,
    required this.description,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterName,
    required this.isGeneralContent,
    required this.audiences,
    required this.tags,
    required this.isActive,
  });

  final String id;
  final String title;
  final String latex;
  final String description;
  final String subjectId;
  final String subjectName;
  final String chapterId;
  final String chapterName;
  final bool isGeneralContent;
  final List<String> audiences;
  final List<String> tags;
  final bool isActive;

  SearchResult toSearchResult() => SearchResult(
    id: id,
    title: title,
    latex: latex,
    description: description,
    subjectId: subjectId,
    subjectName: subjectName,
    chapterId: chapterId,
    chapterName: chapterName,
  );
}

@LazySingleton(as: SearchDataSourcePort)
class SearchFirebaseAdapter implements SearchDataSourcePort {
  SearchFirebaseAdapter(this._api);

  final FirestoreClientPort _api;

  List<_CachedSearchItem>? _cachedItems;
  DateTime? _lastCacheTime;
  static const Duration _cacheTtl = Duration(minutes: 10);
  Completer<void>? _loadingCompleter;

  @override
  Future<List<SearchResult>> searchFormulas(
    String query, {
    String? curriculumKey,
  }) async {
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isEmpty) return [];

    AppLogger.trace(
      'searchFormulas("$trimmedQuery", curriculumKey=$curriculumKey)',
      tag: AppLogTags.searchDataSource,
    );

    final items = await _ensureIndexLoaded();
    if (items.isEmpty) return [];

    final terms = trimmedQuery
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final scoredResults = <({_CachedSearchItem item, int score})>[];

    for (final item in items) {
      if (!item.isActive) continue;

      // Check curriculum eligibility
      if (curriculumKey != null && curriculumKey.isNotEmpty) {
        final matchesCurriculum = item.isGeneralContent ||
            item.audiences.contains(curriculumKey) ||
            item.tags.contains(curriculumKey);
        // If audiences are empty or generic, we allow matching as general fallback
        final isGeneric = item.audiences.isEmpty && item.tags.isEmpty;
        if (!matchesCurriculum && !isGeneric && !item.isGeneralContent) {
          continue;
        }
      }

      final titleLower = item.title.toLowerCase();
      final descLower = item.description.toLowerCase();
      final chapterLower = item.chapterName.toLowerCase();
      final subjectLower = item.subjectName.toLowerCase();
      final latexLower = item.latex.toLowerCase();

      var score = 0;

      if (titleLower == trimmedQuery) {
        score += 120;
      } else if (titleLower.startsWith(trimmedQuery)) {
        score += 80;
      } else if (titleLower.contains(trimmedQuery)) {
        score += 50;
      }

      var allTermsFoundInTitle = true;
      var termMatchCount = 0;

      for (final term in terms) {
        var termFound = false;
        if (titleLower.contains(term)) {
          score += 25;
          termFound = true;
        } else {
          allTermsFoundInTitle = false;
        }

        if (descLower.contains(term)) {
          score += 15;
          termFound = true;
        }

        if (chapterLower.contains(term)) {
          score += 10;
          termFound = true;
        }

        if (subjectLower.contains(term)) {
          score += 8;
          termFound = true;
        }

        if (latexLower.contains(term)) {
          score += 8;
          termFound = true;
        }

        if (termFound) termMatchCount++;
      }

      if (allTermsFoundInTitle && terms.length > 1) {
        score += 30;
      }

      if (score > 0 || termMatchCount == terms.length) {
        scoredResults.add((item: item, score: score));
      }
    }

    scoredResults.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      return a.item.title.compareTo(b.item.title);
    });

    return scoredResults.map((e) => e.item.toSearchResult()).toList();
  }

  Future<List<_CachedSearchItem>> _ensureIndexLoaded() async {
    final isCacheValid = _cachedItems != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheTtl;

    if (isCacheValid) {
      return _cachedItems!;
    }

    if (_loadingCompleter != null) {
      await _loadingCompleter!.future;
      return _cachedItems ?? [];
    }

    _loadingCompleter = Completer<void>();

    try {
      final items = await _fetchIndex();
      _cachedItems = items;
      _lastCacheTime = DateTime.now();
      _loadingCompleter?.complete();
      return items;
    } catch (e, st) {
      AppLogger.error(
        'Failed to load search index',
        tag: AppLogTags.searchDataSource,
        error: e,
        stackTrace: st,
      );
      _loadingCompleter?.complete();
      return _cachedItems ?? [];
    } finally {
      _loadingCompleter = null;
    }
  }

  Future<List<_CachedSearchItem>> _fetchIndex() async {
    // 1. Fetch subjects
    final subjectsSnap = await _api.execute(
      () => _api.collection(AppFirestoreCollections.subjects).get(),
      tag: AppLogTags.searchDataSource,
    );

    final subjectMap = <String, String>{};
    for (final doc in subjectsSnap.docs) {
      final data = doc.data();
      if (data['isActive'] == false) continue;
      subjectMap[doc.id] = data['name'] as String? ?? doc.id;
    }

    // 2. Fetch chapters for all subjects in parallel
    final chapterMap = <String, ({String name, String subjectId})>{};
    final chapterTasks = subjectMap.keys.map((subjectId) async {
      try {
        final chaptersSnap = await _api.execute(
          () => _api
              .collection(AppFirestoreCollections.subjectChapters(subjectId))
              .get(),
          tag: AppLogTags.searchDataSource,
        );
        for (final doc in chaptersSnap.docs) {
          final data = doc.data();
          if (data['isActive'] == false) continue;
          chapterMap[doc.id] = (
            name: data['name'] as String? ?? doc.id,
            subjectId: subjectId,
          );
        }
      } catch (e) {
        AppLogger.warning(
          'Error fetching chapters for subject $subjectId: $e',
          tag: AppLogTags.searchDataSource,
        );
      }
    });
    await Future.wait(chapterTasks);

    // 3. Try collectionGroup('formulas') first for blazing speed
    try {
      final formulasSnap = await _api.execute(
        () => _api.collectionGroup(AppFirestoreCollections.formulas).get(),
        tag: AppLogTags.searchDataSource,
      );

      final items = <_CachedSearchItem>[];
      for (final doc in formulasSnap.docs) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        if (data['isActive'] == false) continue;

        // Infer subject and chapter from path: subjects/{sId}/chapters/{cId}/formulas/{fId}
        final pathSegments = doc.reference.path.split('/');
        var sId = '';
        var cId = '';
        for (var i = 0; i < pathSegments.length - 1; i++) {
          if (pathSegments[i] == 'subjects' && i + 1 < pathSegments.length) {
            sId = pathSegments[i + 1];
          } else if (pathSegments[i] == 'chapters' &&
              i + 1 < pathSegments.length) {
            cId = pathSegments[i + 1];
          }
        }

        final subjectName = subjectMap[sId] ?? sId;
        final chapterName = chapterMap[cId]?.name ?? cId;

        items.add(
          _parseCachedItem(
            docId: doc.id,
            data: data,
            subjectId: sId,
            subjectName: subjectName,
            chapterId: cId,
            chapterName: chapterName,
          ),
        );
      }

      if (items.isNotEmpty) {
        return items;
      }
    } catch (e) {
      AppLogger.warning(
        'collectionGroup failed, using parallel chapter fetch: $e',
        tag: AppLogTags.searchDataSource,
      );
    }

    // 4. Fallback: Fetch formulas for each chapter in parallel
    final allItems = <_CachedSearchItem>[];
    final formulaTasks = chapterMap.entries.map((entry) async {
      final chapterId = entry.key;
      final chapterInfo = entry.value;
      try {
        final snap = await _api.execute(
          () => _api
              .collection(
                AppFirestoreCollections.chapterFormulas(
                  chapterInfo.subjectId,
                  chapterId,
                ),
              )
              .get(),
          tag: AppLogTags.searchDataSource,
        );
        for (final doc in snap.docs) {
          final data = doc.data();
          if (data['isActive'] == false) continue;
          allItems.add(
            _parseCachedItem(
              docId: doc.id,
              data: data,
              subjectId: chapterInfo.subjectId,
              subjectName: subjectMap[chapterInfo.subjectId] ??
                  chapterInfo.subjectId,
              chapterId: chapterId,
              chapterName: chapterInfo.name,
            ),
          );
        }
      } catch (_) {}
    });

    await Future.wait(formulaTasks);
    return allItems;
  }

  _CachedSearchItem _parseCachedItem({
    required String docId,
    required Map<String, dynamic> data,
    required String subjectId,
    required String subjectName,
    required String chapterId,
    required String chapterName,
  }) {
    final audiences = (data['audiences'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    final tags = (data['canonicalScopeTags'] as List<dynamic>? ??
            data['tags'] as List<dynamic>? ??
            [])
        .map((e) => e.toString())
        .toList();

    return _CachedSearchItem(
      id: data['id'] as String? ?? docId,
      title: data['title'] as String? ?? '',
      latex: data['latex'] as String? ?? '',
      description: data['description'] as String? ?? '',
      subjectId: subjectId,
      subjectName: subjectName,
      chapterId: chapterId,
      chapterName: chapterName,
      isGeneralContent: data['isGeneralContent'] as bool? ?? false,
      audiences: audiences,
      tags: tags,
      isActive: data['isActive'] as bool? ?? true,
    );
  }
}
