import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';

@LazySingleton(as: StudyPlannerCachePort)
class StudyPlannerHiveCache implements StudyPlannerCachePort {
  static const String _boxName = 'study_planner_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  String _key(String userId) => 'plans_$userId';

  @override
  Future<void> cachePlans(String userId, List<StudyPlan> plans) async {
    final box = await _box();
    await box.put(
      _key(userId),
      plans
          .map(
            (p) => {
              'id': p.id,
              'title': p.title,
              'description': p.description,
              'isActive': p.isActive,
              'createdAt': p.createdAt.toIso8601String(),
              'updatedAt': p.updatedAt.toIso8601String(),
              'sessions': p.sessions
                  .map(
                    (s) => {
                      'id': s.id,
                      'subjectId': s.subjectId,
                      'chapterId': s.chapterId,
                      'scheduledDate': s.scheduledDate.toIso8601String(),
                      'durationMinutes': s.durationMinutes,
                      'status': s.status.name,
                      'score': s.score,
                      'notes': s.notes,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<StudyPlan>> getPlans(String userId) async {
    final box = await _box();
    final cached = box.get(_key(userId)) as List<dynamic>?;
    if (cached == null) return const [];

    return cached.whereType<Map>().map((item) {
      final m = Map<String, dynamic>.from(item);
      final sessionsData = (m['sessions'] as List<dynamic>? ?? [])
          .map((s) => Map<String, dynamic>.from(s as Map))
          .map(
            (s) => ScheduledSession(
              id: s['id'] as String? ?? '',
              subjectId: s['subjectId'] as String? ?? '',
              chapterId: s['chapterId'] as String?,
              scheduledDate: DateTime.parse(s['scheduledDate'] as String),
              durationMinutes: s['durationMinutes'] as int? ?? 30,
              status: SessionStatus.values.firstWhere(
                (e) => e.name == s['status'],
                orElse: () => SessionStatus.scheduled,
              ),
              score: s['score'] as int?,
              notes: s['notes'] as String?,
            ),
          )
          .toList();
      return StudyPlan(
        id: m['id'] as String? ?? '',
        title: m['title'] as String? ?? '',
        description: m['description'] as String?,
        sessions: sessionsData,
        isActive: m['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(m['createdAt'] as String),
        updatedAt: DateTime.parse(m['updatedAt'] as String),
      );
    }).toList();
  }
}
