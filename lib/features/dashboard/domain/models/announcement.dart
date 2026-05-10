import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory AppAnnouncement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppAnnouncement(
      id: doc.id,
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      priority: data['priority'] as String? ?? 'normal',
      status: data['status'] as String? ?? 'draft',
      publishAt: data['publishAt'] as String?,
      expiresAt: data['expiresAt'] as String?,
    );
  }

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
  List<Object?> get props => [id, title, message, priority, status, publishAt, expiresAt];
}
