import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/study_planner/study_planner.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> studyPlannerRoutes() {
  return [
    GoRoute(
      path: AppRoutes.studyPlannerPath,
      name: AppRoutes.studyPlannerName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider.value(
            value: getIt<StudyPlannerCubit>(),
            child: const StudyPlannerPage(),
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'create',
          name: AppRoutes.createPlanName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: BlocProvider.value(
                value: getIt<StudyPlannerCubit>(),
                child: const CreatePlanPage(),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.planDetailPath,
          name: AppRoutes.planDetailName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: BlocProvider.value(
                value: getIt<StudyPlannerCubit>(),
                child: const PlanDetailPage(),
              ),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.editPlanPath,
              name: AppRoutes.editPlanName,
              pageBuilder: (context, state) {
                return AppPageTransitions.fadeTransition(
                  state: state,
                  child: BlocProvider.value(
                    value: getIt<StudyPlannerCubit>(),
                    child: const EditPlanPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
