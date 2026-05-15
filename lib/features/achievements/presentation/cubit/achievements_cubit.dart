import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/achievement.dart';
import 'achievements_state.dart';

@injectable
class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit() : super(const AchievementsState()) {
    _initAchievements();
  }

  static const _achievementsData = [
    _AchievementData(
      id: 'first_mastered',
      title: 'First Step',
      description: 'Master your first formula',
      icon: 0xe802,
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'ten_mastered',
      title: 'Getting Started',
      description: 'Master 10 formulas',
      icon: 0xe803,
      tier: AchievementTier.silver,
      target: 10,
    ),
    _AchievementData(
      id: 'fifty_mastered',
      title: 'Formula Scholar',
      description: 'Master 50 formulas',
      icon: 0xe804,
      tier: AchievementTier.gold,
      target: 50,
    ),
    _AchievementData(
      id: 'first_flashcard',
      title: 'Flashcard Rookie',
      description: 'Complete your first flashcard session',
      icon: 0xe805,
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'ten_flashcards',
      title: 'Study Streak',
      description: 'Complete 10 flashcard sessions',
      icon: 0xe806,
      tier: AchievementTier.silver,
      target: 10,
    ),
    _AchievementData(
      id: 'first_note',
      title: 'Note Taker',
      description: 'Write your first note on a formula',
      icon: 0xe807,
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'ten_notes',
      title: 'Study Notes',
      description: 'Write 10 notes',
      icon: 0xe808,
      tier: AchievementTier.silver,
      target: 10,
    ),
    _AchievementData(
      id: 'daily_challenge',
      title: 'Daily Grind',
      description: 'Complete your first daily challenge',
      icon: 0xe809,
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'seven_day_streak',
      title: 'Week Warrior',
      description: 'Use the app 7 days in a row',
      icon: 0xe80a,
      tier: AchievementTier.gold,
      target: 7,
    ),
    _AchievementData(
      id: 'all_subjects',
      title: 'Renaissance',
      description: 'View formulas from all subjects',
      icon: 0xe80b,
      tier: AchievementTier.diamond,
      target: 1,
    ),
  ];

  void _initAchievements() {
    emit(state.copyWith(
      achievements: _achievementsData.map((d) => Achievement(
        id: d.id,
        title: d.title,
        description: d.description,
        iconCodePoint: d.icon,
        tier: d.tier,
        target: d.target,
      )).toList(),
    ));
  }

  void reportProgress(String achievementId, int increment) {
    final updated = state.achievements.map((a) {
      if (a.id != achievementId || a.isUnlocked) return a;
      final newProgress = a.progress + increment;
      if (newProgress >= a.target) {
        return a.copyWith(
          progress: a.target,
          unlockedAt: DateTime.now(),
        );
      }
      return a.copyWith(progress: newProgress);
    }).toList();

    emit(state.copyWith(achievements: updated));
  }
}

class _AchievementData {
  const _AchievementData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tier,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final int icon;
  final AchievementTier tier;
  final int target;
}
