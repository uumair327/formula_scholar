import 'package:equatable/equatable.dart';

class RecentActivityItem extends Equatable {
  const RecentActivityItem({
    required this.id,
    required this.title,
    required this.timeAgo,
    required this.iconName,
    required this.isPositive,
  });

  final String id;
  final String title;
  final String timeAgo;
  final String iconName;
  final bool isPositive;

  @override
  List<Object?> get props => [id, title, timeAgo, iconName, isPositive];
}
