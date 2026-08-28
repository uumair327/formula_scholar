import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/shared/domain/ports/streak_provider_port.dart';
import 'package:formula_scholar/features/chapters/presentation/cubit/chapters_cubit.dart';

class SubjectStatsData {
  SubjectStatsData({
    required this.progressPercent,
    required this.completedFormulas,
    required this.totalFormulas,
    required this.currentStreak,
    required this.gradeLabel,
  });

  final int progressPercent;
  final int completedFormulas;
  final int totalFormulas;
  final int currentStreak;
  final String gradeLabel;
}

class SubjectStatsCubit extends Cubit<void> {
  SubjectStatsCubit(
    this._streakProvider,
    this._chaptersCubit,
    this._curriculumCubit,
  ) : super(null);

  final StreakProviderPort _streakProvider;
  final ChaptersCubit _chaptersCubit;
  final CurriculumCubit _curriculumCubit;

  Future<SubjectStatsData> loadSelected() async {
    final currentStreak = await _streakProvider.getCurrentStreak();

    final chapterState = _chaptersCubit.state;
    var total = 0;
    var completed = 0;
    for (var chapter in chapterState.chapters) {
      total += chapter.totalFormulas;
      completed += chapter.completedFormulas;
    }
    final progress = total > 0 ? ((completed / total) * 100).toInt() : 0;
    final grade = _curriculumCubit.state.gradeLabel ?? 'Unknown Grade';

    return SubjectStatsData(
      progressPercent: progress,
      completedFormulas: completed,
      totalFormulas: total,
      currentStreak: currentStreak,
      gradeLabel: grade,
    );
  }
}
