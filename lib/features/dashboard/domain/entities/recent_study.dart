import 'package:equatable/equatable.dart';

/// A recently studied item for the "Continue Studying" section.
///
/// Contains visual metadata so the UI renders any subject's
/// recent study items without hardcoded icon/color lookups.
class RecentStudy extends Equatable {
  final String id;
  final String title;
  final String subject;
  final String lastViewed;

  // ── Visual metadata ──
  /// Icon identifier matching Lucide icon names.
  final String iconName;

  /// Primary color value for icon and accent.
  final int colorValue;

  /// Background color value for the icon circle.
  final int backgroundColorValue;

  const RecentStudy({
    required this.id,
    required this.title,
    required this.subject,
    required this.lastViewed,
    this.iconName = 'book-open',
    this.colorValue = 0xFF00639A,
    this.backgroundColorValue = 0xFFCEE5FF,
  });

  @override
  List<Object?> get props => [id, title, subject];
}
