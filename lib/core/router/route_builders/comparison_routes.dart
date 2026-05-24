import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/comparison/comparison.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> comparisonRoutes() {
  return [
    GoRoute(
      path: AppRoutes.comparisonPath,
      name: AppRoutes.comparisonName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<ComparisonCubit>(),
            child: const ComparisonPage(),
          ),
        );
      },
    ),
  ];
}

