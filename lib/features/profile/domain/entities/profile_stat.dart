import 'package:equatable/equatable.dart';

/// A single progress stat (e.g. Formulas Mastered, Days Streak).
class ProfileStat extends Equatable {

  const ProfileStat({
    required this.id,
    required this.label,
    required this.value,
    required this.iconName,
  });
  final String id;
  final String label;
  final String value;
  final String iconName;

  @override
  List<Object?> get props => [id, label, value];
}
