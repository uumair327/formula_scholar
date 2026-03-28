import 'package:equatable/equatable.dart';

/// A recently studied item for the "Continue Studying" section.
class RecentStudy extends Equatable {
  final String id;
  final String title;
  final String subject;
  final String lastViewed;

  const RecentStudy({
    required this.id,
    required this.title,
    required this.subject,
    required this.lastViewed,
  });

  @override
  List<Object?> get props => [id, title, subject];
}
