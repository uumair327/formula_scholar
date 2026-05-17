import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
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
class AchievementsCubit extends Cubit<AchievementsState>
    with CubitFailureLogger<AchievementsState> {
  AchievementsCubit({
    required GetAchievementsUseCase getAchievements,
  }) : _getAchievements = getAchievements,
       super(const AchievementsState());

  final GetAchievementsUseCase _getAchievements;

  @override
  String get logTag => AppLogTags.achievementsCubit;

  Future<void> loadAchievements() async {
    emit(state.copyWith(isLoading: true));
    final result = await _getAchievements();
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(achievements: data, isLoading: false));
      case Error(:final failure):
        logFailure('achievements', failure);
        emit(state.copyWith(isLoading: false));
    }
  }

  static IconData iconFor(String id) => _achievementIcon(id);
}
