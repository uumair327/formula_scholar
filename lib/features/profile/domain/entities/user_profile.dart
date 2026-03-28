import 'package:equatable/equatable.dart';

/// User profile entity.
class UserProfile extends Equatable {
  final String name;
  final String grade;
  final String avatarUrl;
  final bool isPro;

  const UserProfile({
    required this.name,
    required this.grade,
    required this.avatarUrl,
    this.isPro = false,
  });

  @override
  List<Object?> get props => [name, grade, avatarUrl, isPro];
}
