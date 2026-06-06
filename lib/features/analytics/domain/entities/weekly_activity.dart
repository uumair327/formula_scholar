import 'package:equatable/equatable.dart';

class WeeklyActivity extends Equatable {
  const WeeklyActivity({required this.dayLabels, required this.values});

  final List<String> dayLabels;
  final List<int> values;

  int get total => values.fold(0, (a, b) => a + b);

  @override
  List<Object?> get props => [dayLabels, values];
}
