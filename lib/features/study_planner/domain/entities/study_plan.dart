import 'package:equatable/equatable.dart';
import 'scheduled_session.dart';

class StudyPlan extends Equatable {
  const StudyPlan({
    required this.id,
    required this.title,
    this.description,
    this.sessions = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final List<ScheduledSession> sessions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get completedSessions => sessions.where((s) => s.status == SessionStatus.completed).length;
  int get totalSessions => sessions.length;
  double get progressPercent => totalSessions > 0 ? completedSessions / totalSessions : 0;

  StudyPlan copyWith({
    String? id,
    String? title,
    String? description,
    List<ScheduledSession>? sessions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudyPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      sessions: sessions ?? this.sessions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, sessions, isActive, createdAt];
}
