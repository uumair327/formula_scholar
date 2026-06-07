import 'package:equatable/equatable.dart';

class StreakHistoryMonth extends Equatable {
  const StreakHistoryMonth({
    required this.year,
    required this.month,
    required this.activeDays,
    required this.freezeDays,
  });

  final int year;
  final int month;
  final List<int> activeDays;
  final List<int> freezeDays;

  @override
  List<Object?> get props => [year, month, activeDays, freezeDays];
}
