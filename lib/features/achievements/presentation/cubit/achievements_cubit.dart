import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/entities/achievement.dart';
import 'achievements_state.dart';

IconData _achievementIcon(String id) {
  return switch (id) {
    'first_mastered' => LucideIcons.checkCircle,
    'ten_mastered' => LucideIcons.trendingUp,
    'fifty_mastered' => LucideIcons.trophy,
    'first_flashcard' => LucideIcons.layers,
    'ten_flashcards' => LucideIcons.bookOpen,
    'first_note' => LucideIcons.fileText,
    'ten_notes' => LucideIcons.stickyNote,
    'daily_challenge' => LucideIcons.zap,
    'seven_day_streak' => LucideIcons.calendarCheck,
    'all_subjects' => LucideIcons.globe,
    _ => LucideIcons.award,
  };
}

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
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'ten_mastered',
      title: 'Getting Started',
      description: 'Master 10 formulas',
      tier: AchievementTier.silver,
      target: 10,
    ),
    _AchievementData(
      id: 'fifty_mastered',
      title: 'Formula Scholar',
      description: 'Master 50 formulas',
      tier: AchievementTier.gold,
      target: 50,
    ),
    _AchievementData(
      id: 'first_flashcard',
      title: 'Flashcard Rookie',
      description: 'Complete your first flashcard session',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'ten_flashcards',
      title: 'Study Streak',
      description: 'Complete 10 flashcard sessions',
      tier: AchievementTier.silver,
      target: 10,
    ),
    _AchievementData(
      id: 'first_note',
      title: 'Note Taker',
      description: 'Write your first note on a formula',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'ten_notes',
      title: 'Study Notes',
      description: 'Write 10 notes',
      tier: AchievementTier.silver,
      target: 10,
    ),
    _AchievementData(
      id: 'daily_challenge',
      title: 'Daily Grind',
      description: 'Complete your first daily challenge',
      tier: AchievementTier.bronze,
      target: 1,
    ),
    _AchievementData(
      id: 'seven_day_streak',
      title: 'Week Warrior',
      description: 'Use the app 7 days in a row',
      tier: AchievementTier.gold,
      target: 7,
    ),
    _AchievementData(
      id: 'all_subjects',
      title: 'Renaissance',
      description: 'View formulas from all subjects',
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

  /// Returns the icon for a given achievement id.
  static IconData iconFor(String id) => _achievementIcon(id);
}

class _AchievementData {
  const _AchievementData({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final AchievementTier tier;
  final int target;
}
