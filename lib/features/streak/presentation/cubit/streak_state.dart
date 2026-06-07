import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';

enum StreakStatus { initial, loading, loaded, error }

class StreakState extends Equatable {
  const StreakState({
    this.status = StreakStatus.initial,
    this.currentMonthHistory,
    this.viewingYear = 0,
    this.viewingMonth = 0,
    this.availableFreezes = 0,
    this.joinDate,
    this.errorMessage,
  });

  final StreakStatus status;
  final StreakHistoryMonth? currentMonthHistory;
  final int viewingYear;
  final int viewingMonth;
  final int availableFreezes;
  final DateTime? joinDate;
  final String? errorMessage;

  StreakState copyWith({
    StreakStatus? status,
    StreakHistoryMonth? currentMonthHistory,
    int? viewingYear,
    int? viewingMonth,
    int? availableFreezes,
    DateTime? joinDate,
    String? errorMessage,
  }) {
    return StreakState(
      status: status ?? this.status,
      currentMonthHistory: currentMonthHistory ?? this.currentMonthHistory,
      viewingYear: viewingYear ?? this.viewingYear,
      viewingMonth: viewingMonth ?? this.viewingMonth,
      availableFreezes: availableFreezes ?? this.availableFreezes,
      joinDate: joinDate ?? this.joinDate,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentMonthHistory,
        viewingYear,
        viewingMonth,
        availableFreezes,
        joinDate,
        errorMessage,
      ];
}
