import 'package:equatable/equatable.dart';

class ThemePreference extends Equatable {

  const ThemePreference({this.isDarkMode = false});
  final bool isDarkMode;

  ThemePreference copyWith({bool? isDarkMode}) {
    return ThemePreference(isDarkMode: isDarkMode ?? this.isDarkMode);
  }

  @override
  List<Object?> get props => [isDarkMode];
}
