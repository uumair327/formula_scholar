/// Example: Listen to dashboard-controlled curriculum changes in real time
///
/// This demonstrates how the Flutter app stays in sync with the dashboard
/// as operators make changes. The stream approach allows the app to react
/// instantly to curriculum lockdowns, content publishing, etc.
///
/// Usage in a BlocListener or StreamBuilder:
/// ```dart
/// StreamBuilder<CurriculumRegistry>(
///   stream: _registryRepo.streamCurriculumRegistry(),
///   builder: (context, snapshot) {
///     if (snapshot.hasData) {
///       final registry = snapshot.data!;
///       if (registry.findNode('chapters')?.isLocked ?? false) {
///         // Dashboard locked chapters — show notice
///         return const LockedChaptersNotice();
///       }
///     }
///     return const ChaptersPage();
///   },
/// )
/// ```

import 'package:flutter/material.dart';

import '../../shared/domain/models/curriculum_registry.dart';
import '../../shared/domain/models/content_registry.dart';
import '../../shared/infrastructure/repositories/dashboard_registry_repository.dart';

class DashboardSyncExample extends StatefulWidget {
  final DashboardRegistryRepository registryRepo;

  const DashboardSyncExample({required this.registryRepo, Key? key})
    : super(key: key);

  @override
  State<DashboardSyncExample> createState() => _DashboardSyncExampleState();
}

class _DashboardSyncExampleState extends State<DashboardSyncExample> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Example 1: Listen to Curriculum Registry Changes ---
        Expanded(
          child: StreamBuilder<CurriculumRegistry>(
            stream: widget.registryRepo.streamCurriculumRegistry(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No registry data'));
              }

              final registry = snapshot.data!;
              if (registry.isEmpty) {
                return const Center(
                  child: Text('Registry empty — app using local data'),
                );
              }

              return ListView.builder(
                itemCount: registry.nodes.length,
                itemBuilder: (context, index) {
                  final node = registry.nodes[index];
                  return ListTile(
                    title: Text(node.label),
                    subtitle: Text('${node.nodeCount} items | ${node.status}'),
                    trailing: node.isLocked
                        ? const Icon(Icons.lock, color: Colors.red)
                        : node.isReadOnly
                        ? const Icon(Icons.visibility, color: Colors.orange)
                        : const Icon(Icons.edit, color: Colors.green),
                  );
                },
              );
            },
          ),
        ),
        const Divider(),

        // --- Example 2: Listen to Content Registry Changes ---
        Expanded(
          child: StreamBuilder<ContentRegistry>(
            stream: widget.registryRepo.streamContentRegistry(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No content registry'));
              }

              final registry = snapshot.data!;
              if (registry.isEmpty) {
                return const Center(
                  child: Text('Content registry empty — using app defaults'),
                );
              }

              return ListView.builder(
                itemCount: registry.items.length,
                itemBuilder: (context, index) {
                  final item = registry.items[index];
                  return ListTile(
                    title: Text(item.key),
                    subtitle: Text('${item.locale} • ${item.status}'),
                    leading: item.isPublished
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : item.isInReview
                        ? const Icon(Icons.schedule, color: Colors.orange)
                        : const Icon(Icons.edit, color: Colors.grey),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Example: Show UI notice when dashboard locks curriculum
class LockedCurriculumNotice extends StatelessWidget {
  final CurriculumNode lockedNode;

  const LockedCurriculumNotice({required this.lockedNode, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Curriculum Locked',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  '${lockedNode.label} is currently locked by the dashboard operator.',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Example: Show UI notice when content is not published
class UnpublishedContentNotice extends StatelessWidget {
  final ContentItem item;

  const UnpublishedContentNotice({required this.item, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(item.isDraft ? Icons.edit : Icons.schedule, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item.isDraft ? 'Draft' : 'Under Review'}: ${item.key}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  'This content is not yet published by the dashboard operator.',
                  style: TextStyle(color: Colors.amber.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
