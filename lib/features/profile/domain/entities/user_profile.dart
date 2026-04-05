import 'package:equatable/equatable.dart';

/// User profile entity.
class UserProfile extends Equatable {
  final String name;
  final String email;
  final String grade;
  final String avatarUrl;
  final bool isPro;

  const UserProfile({
    required this.name,
    this.email = '',
    required this.grade,
    required this.avatarUrl,
    this.isPro = false,
  });

  @override
  List<Object?> get props => [name, email, grade, avatarUrl, isPro];
}
