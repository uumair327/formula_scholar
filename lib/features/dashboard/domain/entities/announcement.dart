import 'package:equatable/equatable.dart';

class AnnouncementPriority {
  static const urgent = 'urgent';
  static const high = 'high';
  static const normal = 'normal';
  static const low = 'low';
}

class AnnouncementStatus {
  static const published = 'published';
  static const draft = 'draft';
  static const archived = 'archived';
}

class AppAnnouncement extends Equatable {
  const AppAnnouncement({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.status,
    this.publishAt,
    this.expiresAt,
  });

  final String id;
  final String title;
  final String message;
  final String priority;
  final String status;
  final String? publishAt;
  final String? expiresAt;

  bool get isUrgent => priority == AnnouncementPriority.urgent;
  bool get isHighPriority => priority == AnnouncementPriority.high || priority == AnnouncementPriority.urgent;

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    priority,
    status,
    publishAt,
    expiresAt,
  ];
}
