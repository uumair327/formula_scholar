import 'package:equatable/equatable.dart';

class ThemePreference extends Equatable {
  final bool isDarkMode;

  const ThemePreference({this.isDarkMode = false});

  ThemePreference copyWith({bool? isDarkMode}) {
    return ThemePreference(isDarkMode: isDarkMode ?? this.isDarkMode);
  }

  @override
  List<Object?> get props => [isDarkMode];
}
