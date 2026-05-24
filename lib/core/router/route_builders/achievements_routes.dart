import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/achievements/achievements.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> achievementsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.achievementsPath,
      name: AppRoutes.achievementsName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<AchievementsCubit>(),
            child: const AchievementsPage(),
          ),
        );
      },
    ),
  ];
}

