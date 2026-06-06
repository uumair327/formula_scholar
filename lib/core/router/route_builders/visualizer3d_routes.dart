import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/visualizer_3d/visualizer_3d.dart';
import '../../../features/chapters/chapters.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> visualizer3dRoutes() {
  return [
    GoRoute(
      path: AppRoutes.visualizer3dPath,
      name: AppRoutes.visualizer3dName,
      pageBuilder: (context, state) {
        List<Formula> formulas = const [];
        final extra = state.extra;
        if (extra is List<Formula>) {
          formulas = extra;
        } else if (extra is FormulasCubit) {
          formulas = extra.state.formulas;
        }
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => VisualizerCubit(formulas: formulas),
            child: const VisualizerPage(),
          ),
        );
      },
    ),
  ];
}
