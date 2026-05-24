import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/comparison/comparison.dart';
import '../../../core/domain/entities/formula.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> comparisonRoutes() {
  return [
    GoRoute(
      path: AppRoutes.comparisonPath,
      name: AppRoutes.comparisonName,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final comparisonCubit = getIt<ComparisonCubit>();
        if (extra is Map<String, Formula>) {
          comparisonCubit.setFormulas(extra['a']!, extra['b']!);
        }
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider.value(
            value: comparisonCubit,
            child: const ComparisonPage(),
          ),
        );
      },
    ),
  ];
}
