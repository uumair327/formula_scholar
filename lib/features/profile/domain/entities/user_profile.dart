import 'package:equatable/equatable.dart';

/// User profile entity.
class UserProfile extends Equatable {
  final String name;
  final String email;
  final String grade;
  final String board;
  final String avatarUrl;
  final bool isPro;

  const UserProfile({
    required this.name,
    this.email = '',
    required this.grade,
    this.board = '',
    required this.avatarUrl,
    this.isPro = false,
  });

  /// Display label combining board and grade, e.g. "CBSE • Class 9".
  String get curriculumLabel {
    if (board.isEmpty) return grade;
    return '$board • $grade';
  }

  @override
  List<Object?> get props => [name, email, grade, board, avatarUrl, isPro];
}
