import 'package:equatable/equatable.dart';

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

  bool get isUrgent => priority == 'urgent';
  bool get isHighPriority => priority == 'high' || priority == 'urgent';

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
