/// Content registry data model — matches dashboard_content_registry/current structure
///
/// Provides access to dashboard-managed content items like UI strings, banners, hints.
/// Allows the dashboard to control app content without app redeployment.

class ContentRegistry {
  final String generatedAt;
  final String datasetVersion;
  final String status; // 'healthy', 'stale', 'degraded'
  final int itemCount;
  final List<ContentItem> items;

  const ContentRegistry({
    required this.generatedAt,
    required this.datasetVersion,
    required this.status,
    required this.itemCount,
    required this.items,
  });

  const ContentRegistry.empty()
    : generatedAt = 'n/a',
      datasetVersion = 'n/a',
      status = 'unavailable',
      itemCount = 0,
      items = const [];

  bool get isEmpty => itemCount == 0;

  ContentItem? findItem(String key) {
    try {
      return items.firstWhere((item) => item.key == key);
    } catch (e) {
      return null;
    }
  }

  /// Get only published items (production-ready content)
  List<ContentItem> get publishedItems =>
      items.where((item) => item.isPublished).toList();

  factory ContentRegistry.fromMap(Map<String, dynamic> map) {
    final rawItems =
        (map['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final items = rawItems
        .map((itemMap) => ContentItem.fromMap(itemMap))
        .toList();

    return ContentRegistry(
      generatedAt: map['generatedAt'] as String? ?? 'n/a',
      datasetVersion: map['datasetVersion'] as String? ?? 'n/a',
      status: map['status'] as String? ?? 'unknown',
      itemCount: map['itemCount'] as int? ?? items.length,
      items: items,
    );
  }

  Map<String, dynamic> toMap() => {
    'generatedAt': generatedAt,
    'datasetVersion': datasetVersion,
    'status': status,
    'itemCount': itemCount,
    'items': items.map((item) => item.toMap()).toList(),
  };
}

/// A single content item (e.g., 'home.hero.title', 'subscription.cta.banner')
class ContentItem {
  final String key;
  final String locale; // 'en-IN', 'en-US', etc.
  final String status; // 'Published', 'Draft', 'Review'
  final String? lastSyncedAt;

  const ContentItem({
    required this.key,
    required this.locale,
    required this.status,
    this.lastSyncedAt,
  });

  bool get isPublished => status == 'Published';
  bool get isInReview => status == 'Review';
  bool get isDraft => status == 'Draft';

  factory ContentItem.fromMap(Map<String, dynamic> map) => ContentItem(
    key: map['key'] as String? ?? '',
    locale: map['locale'] as String? ?? 'en-IN',
    status: map['status'] as String? ?? 'Draft',
    lastSyncedAt: map['lastSyncedAt'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'key': key,
    'locale': locale,
    'status': status,
    if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt,
  };
}
