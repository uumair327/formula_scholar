/// Curriculum registry data model — matches dashboard_curriculum_registry/current structure
///
/// Provides safe access to dashboard-controlled curriculum metadata like
/// whether a collection is locked, write-enabled, or has been recently synced.

class CurriculumRegistry {
  final String generatedAt;
  final String datasetVersion;
  final String status; // 'healthy', 'stale', 'degraded'
  final int nodeCount;
  final List<CurriculumNode> nodes;

  const CurriculumRegistry({
    required this.generatedAt,
    required this.datasetVersion,
    required this.status,
    required this.nodeCount,
    required this.nodes,
  });

  const CurriculumRegistry.empty()
    : generatedAt = 'n/a',
      datasetVersion = 'n/a',
      status = 'unavailable',
      nodeCount = 0,
      nodes = const [];

  bool get isEmpty => nodeCount == 0;

  CurriculumNode? findNode(String key) {
    try {
      return nodes.firstWhere((node) => node.key == key);
    } catch (e) {
      return null;
    }
  }

  factory CurriculumRegistry.fromMap(Map<String, dynamic> map) {
    final rawNodes =
        (map['nodes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final nodes = rawNodes
        .map((nodeMap) => CurriculumNode.fromMap(nodeMap))
        .toList();

    return CurriculumRegistry(
      generatedAt: map['generatedAt'] as String? ?? 'n/a',
      datasetVersion: map['datasetVersion'] as String? ?? 'n/a',
      status: map['status'] as String? ?? 'unknown',
      nodeCount: map['nodeCount'] as int? ?? nodes.length,
      nodes: nodes,
    );
  }

  Map<String, dynamic> toMap() => {
    'generatedAt': generatedAt,
    'datasetVersion': datasetVersion,
    'status': status,
    'nodeCount': nodeCount,
    'nodes': nodes.map((node) => node.toMap()).toList(),
  };
}

/// A single curriculum node (e.g., 'countries', 'subjects', 'chapters')
class CurriculumNode {
  final String key;
  final String label;
  final String collectionPath;
  final int nodeCount;
  final String status; // 'active', 'read-only', 'locked'
  final bool writeEnabled;
  final String lastSyncedAt;

  const CurriculumNode({
    required this.key,
    required this.label,
    required this.collectionPath,
    required this.nodeCount,
    required this.status,
    required this.writeEnabled,
    required this.lastSyncedAt,
  });

  bool get isActive => status == 'active';
  bool get isReadOnly => status == 'read-only';
  bool get isLocked => status == 'locked';

  factory CurriculumNode.fromMap(Map<String, dynamic> map) => CurriculumNode(
    key: map['key'] as String? ?? '',
    label: map['label'] as String? ?? '',
    collectionPath: map['collectionPath'] as String? ?? '',
    nodeCount: map['nodeCount'] as int? ?? 0,
    status: map['status'] as String? ?? 'active',
    writeEnabled: map['writeEnabled'] as bool? ?? true,
    lastSyncedAt: map['lastSyncedAt'] as String? ?? 'n/a',
  );

  Map<String, dynamic> toMap() => {
    'key': key,
    'label': label,
    'collectionPath': collectionPath,
    'nodeCount': nodeCount,
    'status': status,
    'writeEnabled': writeEnabled,
    'lastSyncedAt': lastSyncedAt,
  };
}
