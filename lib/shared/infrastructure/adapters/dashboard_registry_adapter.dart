/// Dashboard Registry Adapter — reads curriculum and content data from dashboard-controlled registries.
///
/// This adapter provides a fallback-first approach:
/// 1. Try to read from dashboard_curriculum_registry/current (dashboard-controlled metadata)
/// 2. Fall back to direct Firestore collection queries if registry is empty/missing
/// 3. Return cached data if Firestore is unavailable
///
/// This keeps the app in sync with dashboard control without breaking existing queries.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/content_registry.dart';
import '../../domain/models/curriculum_registry.dart';

class DashboardRegistryAdapter {

  DashboardRegistryAdapter(this._firestore);
  final FirebaseFirestore _firestore;

  /// Fetch curriculum registry metadata (countries, states, boards, subjects, chapters, etc.)
  ///
  /// Returns empty list if registry does not exist (safe fallback).
  Future<CurriculumRegistry> fetchCurriculumRegistry() async {
    try {
      final doc = await _firestore
          .collection('dashboard_curriculum_registry')
          .doc('current')
          .get();

      if (!doc.exists) {
        return const CurriculumRegistry.empty();
      }

      final data = doc.data() as Map<String, dynamic>;
      return CurriculumRegistry.fromMap(data);
    } catch (e) {
      // Firestore unavailable, return empty registry so app falls back to direct queries
      return const CurriculumRegistry.empty();
    }
  }

  /// Fetch content registry metadata (CMS-driven content items)
  ///
  /// Returns empty list if registry does not exist (safe fallback).
  Future<ContentRegistry> fetchContentRegistry() async {
    try {
      final doc = await _firestore
          .collection('dashboard_content_registry')
          .doc('current')
          .get();

      if (!doc.exists) {
        return const ContentRegistry.empty();
      }

      final data = doc.data() as Map<String, dynamic>;
      return ContentRegistry.fromMap(data);
    } catch (e) {
      // Firestore unavailable, return empty registry so app falls back to defaults
      return const ContentRegistry.empty();
    }
  }

  /// Get a curriculum node by key (e.g., 'countries', 'boards', 'subjects')
  ///
  /// Useful for checking if a node is locked or has custom metadata.
  Future<CurriculumNode?> getCurriculumNode(String key) async {
    final registry = await fetchCurriculumRegistry();
    return registry.findNode(key);
  }

  /// Get content item by key
  ///
  /// Useful for checking if content is Published or Draft before displaying.
  Future<ContentItem?> getContentItem(String key) async {
    final registry = await fetchContentRegistry();
    return registry.findItem(key);
  }

  /// Check if curriculum node is writable (write-enabled)
  ///
  /// Useful for disabling UI operations if the dashboard locked the node.
  Future<bool> isCurriculumNodeWritable(String nodeKey) async {
    final node = await getCurriculumNode(nodeKey);
    return node?.writeEnabled ??
        true; // Default to writable if registry missing
  }

  /// Stream curriculum registry updates in real time
  ///
  /// Allows UI to react to dashboard changes instantly.
  Stream<CurriculumRegistry> streamCurriculumRegistry() {
    return _firestore
        .collection('dashboard_curriculum_registry')
        .doc('current')
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return const CurriculumRegistry.empty();
          }
          return CurriculumRegistry.fromMap(doc.data() as Map<String, dynamic>);
        })
        .handleError((_) {
          // Return empty on error so the app can proceed
          return const CurriculumRegistry.empty();
        });
  }

  /// Stream content registry updates in real time
  ///
  /// Allows UI to react to dashboard content changes instantly.
  Stream<ContentRegistry> streamContentRegistry() {
    return _firestore
        .collection('dashboard_content_registry')
        .doc('current')
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return const ContentRegistry.empty();
          }
          return ContentRegistry.fromMap(doc.data() as Map<String, dynamic>);
        })
        .handleError((_) {
          // Return empty on error so the app can proceed
          return const ContentRegistry.empty();
        });
  }
}
