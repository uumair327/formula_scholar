library;

import '../../../core/core.dart';

class DashboardRegistryAdapter {
  DashboardRegistryAdapter(this._api);
  final FirestoreClientPort _api;

  Future<CurriculumRegistry> fetchCurriculumRegistry() async {
    try {
      final doc = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.dashboardCurriculumRegistry)
            .doc(AppFirestoreCollections.current)
            .get(),
        tag: 'DashboardRegistry',
      );

      if (!doc.exists) {
        return const CurriculumRegistry.empty();
      }

      final data = doc.data() as Map<String, dynamic>;
      return CurriculumRegistry.fromMap(data);
    } catch (e) {
      return const CurriculumRegistry.empty();
    }
  }

  Future<ContentRegistry> fetchContentRegistry() async {
    try {
      final doc = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.dashboardContentRegistry)
            .doc(AppFirestoreCollections.current)
            .get(),
        tag: 'DashboardRegistry',
      );

      if (!doc.exists) {
        return const ContentRegistry.empty();
      }

      final data = doc.data() as Map<String, dynamic>;
      return ContentRegistry.fromMap(data);
    } catch (e) {
      return const ContentRegistry.empty();
    }
  }

  Future<CurriculumNode?> getCurriculumNode(String key) async {
    final registry = await fetchCurriculumRegistry();
    return registry.findNode(key);
  }

  Future<ContentItem?> getContentItem(
    String key, {
    String preferredLocale = AppLocales.defaultContentLocaleCode,
    List<String> fallbackLocales = const [AppLocales.defaultContentLocaleCode],
  }) async {
    final registry = await fetchContentRegistry();
    return registry.findItemForLocale(
      key,
      preferredLocale: preferredLocale,
      fallbackLocales: fallbackLocales,
    );
  }

  Future<bool> isCurriculumNodeWritable(String nodeKey) async {
    final node = await getCurriculumNode(nodeKey);
    return node?.writeEnabled ?? true;
  }

  Stream<CurriculumRegistry> streamCurriculumRegistry() {
    return _api.stream(
      () => _api
          .collection(AppFirestoreCollections.dashboardCurriculumRegistry)
          .doc(AppFirestoreCollections.current)
          .snapshots()
          .map((doc) {
            if (!doc.exists) {
              return const CurriculumRegistry.empty();
            }
            return CurriculumRegistry.fromMap(
              doc.data() as Map<String, dynamic>,
            );
          })
          .handleError((_) {
            return const CurriculumRegistry.empty();
          }),
      tag: 'DashboardRegistry',
    );
  }

  Stream<ContentRegistry> streamContentRegistry() {
    return _api.stream(
      () => _api
          .collection(AppFirestoreCollections.dashboardContentRegistry)
          .doc(AppFirestoreCollections.current)
          .snapshots()
          .map((doc) {
            if (!doc.exists) {
              return const ContentRegistry.empty();
            }
            return ContentRegistry.fromMap(doc.data() as Map<String, dynamic>);
          })
          .handleError((_) {
            return const ContentRegistry.empty();
          }),
      tag: 'DashboardRegistry',
    );
  }
}
