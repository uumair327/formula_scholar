import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'theme_state.dart';

@lazySingleton
class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    final newValue = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newValue));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(isDarkMode: json['isDarkMode'] as bool? ?? false);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'isDarkMode': state.isDarkMode};
  }
}
