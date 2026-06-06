import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/chapters/chapters.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> cheatSheetRoutes() {
  return [
    GoRoute(
      path: AppRoutes.cheatSheetPath,
      name: AppRoutes.cheatSheetName,
      pageBuilder: (context, state) {
        final extra = state.extra;
        return AppPageTransitions.fadeTransition(
          state: state,
          child: extra is FormulasCubit
              ? BlocProvider.value(value: extra, child: const CheatSheetPage())
              : BlocProvider(
                  create: (_) => getIt<FormulasCubit>(),
                  child: const CheatSheetPage(),
                ),
        );
      },
    ),
  ];
}
