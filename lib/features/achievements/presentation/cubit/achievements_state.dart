import 'package:equatable/equatable.dart';

import '../../domain/entities/achievement.dart';

class AchievementsState extends Equatable {
  const AchievementsState({
    this.achievements = const [],
    this.isLoading = false,
  });

  final List<Achievement> achievements;
  final bool isLoading;

  List<Achievement> get unlocked =>
      achievements.where((a) => a.isUnlocked).toList();

  List<Achievement> get locked =>
      achievements.where((a) => !a.isUnlocked).toList();

  int get totalUnlocked => unlocked.length;
  int get totalAchievements => achievements.length;

  AchievementsState copyWith({
    List<Achievement>? achievements,
    bool? isLoading,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [achievements, isLoading];
}
