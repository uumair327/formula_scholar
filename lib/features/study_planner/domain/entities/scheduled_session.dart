import 'package:equatable/equatable.dart';

enum SessionStatus { scheduled, completed, missed }

class ScheduledSession extends Equatable {
  const ScheduledSession({
    required this.id,
    required this.subjectId,
    this.chapterId,
    required this.scheduledDate,
    this.durationMinutes = 30,
    this.status = SessionStatus.scheduled,
    this.score,
    this.notes,
  });

  final String id;
  final String subjectId;
  final String? chapterId;
  final DateTime scheduledDate;
  final int durationMinutes;
  final SessionStatus status;
  final int? score;
  final String? notes;

  ScheduledSession copyWith({
    String? id,
    String? subjectId,
    String? chapterId,
    DateTime? scheduledDate,
    int? durationMinutes,
    SessionStatus? status,
    int? score,
    String? notes,
  }) {
    return ScheduledSession(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      score: score ?? this.score,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, subjectId, scheduledDate, status];
}
