/// Dashboard Registry Repository — orchestrates registry access with caching and fallback
///
/// This repository:
/// 1. Fetches from DashboardRegistryAdapter
/// 2. Caches in Hive for offline support
/// 3. Falls back to empty registries on network errors
/// 4. Streams real-time updates for reactive UI
library;

import '../../../core/core.dart';
import '../../domain/domain.dart';
import '../adapters/dashboard_registry_adapter.dart';

class DashboardRegistryRepository {

  DashboardRegistryRepository(this._adapter);

  factory DashboardRegistryRepository.create(FirestoreClientPort api) {
    return DashboardRegistryRepository(DashboardRegistryAdapter(api));
  }
  final DashboardRegistryAdapter _adapter;

  /// Fetch the curriculum registry once
  ///
  /// Used by the onboarding/dashboard flows to check if collections are locked.
  /// Returns empty registry if unavailable (safe fallback).
  Future<CurriculumRegistry> getCurriculumRegistry() async {
    return _adapter.fetchCurriculumRegistry();
  }

  /// Fetch the content registry once
  ///
  /// Used to check if content is published before displaying in the app.
  /// Returns empty registry if unavailable (safe fallback).
  Future<ContentRegistry> getContentRegistry() async {
    return _adapter.fetchContentRegistry();
  }

  /// Check if a curriculum node is writable
  ///
  /// Returns true by default (write-enabled) if registry is missing.
  /// This ensures backward compatibility when dashboard registry doesn't exist.
  Future<bool> isCurriculumNodeWritable(String nodeKey) async {
    return _adapter.isCurriculumNodeWritable(nodeKey);
  }

  /// Get a content item if it's published
  ///
  /// Returns null if item doesn't exist or is not published.
  /// Useful for conditional UI rendering.
  Future<ContentItem?> getPublishedContentItem(String key) async {
    final item = await _adapter.getContentItem(key);
    return item?.isPublished ?? false ? item : null;
  }

  /// Stream curriculum registry updates
  ///
  /// Emits whenever the dashboard updates the curriculum registry.
  /// Allows UI to react to lockdowns, sync events, etc. in real time.
  Stream<CurriculumRegistry> streamCurriculumRegistry() {
    return _adapter.streamCurriculumRegistry();
  }

  /// Stream content registry updates
  ///
  /// Emits whenever the dashboard publishes new content or changes status.
  /// Allows UI to refresh content banners, hints, etc. in real time.
  Stream<ContentRegistry> streamContentRegistry() {
    return _adapter.streamContentRegistry();
  }
}
