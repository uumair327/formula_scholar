import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/practice/practice.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> practiceHistoryRoutes() {
  return [
    GoRoute(
      path: AppRoutes.practiceHistoryPath,
      name: AppRoutes.practiceHistoryName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<PracticeHistoryCubit>(),
            child: const PracticeHistoryPage(),
          ),
        );
      },
    ),
  ];
}
