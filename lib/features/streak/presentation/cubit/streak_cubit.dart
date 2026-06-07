import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'streak_state.dart';

export 'streak_state.dart';

@injectable
class StreakCubit extends Cubit<StreakState> with CubitFailureLogger<StreakState> {
  StreakCubit({
    required StreakRepository streakRepository,
  })  : _streakRepository = streakRepository,
        super(const StreakState());

  final StreakRepository _streakRepository;

  @override
  String get logTag => 'StreakCubit';

  Future<void> init() async {
    final now = DateTime.now();
    await loadMonth(now.year, now.month);
    
    final freezesResult = await _streakRepository.getAvailableFreezes();
    final joinDateResult = await _streakRepository.getJoinDate();
    
    if (!isClosed) {
      emit(state.copyWith(
        availableFreezes: freezesResult is Success<int> ? freezesResult.data : null,
        joinDate: joinDateResult is Success<DateTime?> ? joinDateResult.data : null,
      ));
    }
  }

  Future<void> loadMonth(int year, int month) async {
    emit(state.copyWith(
      status: StreakStatus.loading,
      viewingYear: year,
      viewingMonth: month,
    ));

    final result = await _streakRepository.getMonthHistory(year, month);

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(
          status: StreakStatus.loaded,
          currentMonthHistory: data,
        ));
      case Error(:final failure):
        logFailure('loadMonth', failure);
        emit(state.copyWith(
          status: StreakStatus.error,
          errorMessage: failure.message,
        ));
    }
  }

  void previousMonth() {
    var y = state.viewingYear;
    var m = state.viewingMonth - 1;
    if (m < 1) {
      m = 12;
      y -= 1;
    }
    
    // Prevent navigating before the join date
    final join = state.joinDate;
    if (join != null) {
      if (y < join.year || (y == join.year && m < join.month)) {
        return; // already at or before join month
      }
    }
    
    loadMonth(y, m);
  }

  void nextMonth() {
    var y = state.viewingYear;
    var m = state.viewingMonth + 1;
    if (m > 12) {
      m = 1;
      y += 1;
    }
    final now = DateTime.now();
    if (y > now.year || (y == now.year && m > now.month)) return;

    loadMonth(y, m);
  }
}
