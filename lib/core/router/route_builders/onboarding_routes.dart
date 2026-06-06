import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/onboarding/onboarding.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

ShellRoute onboardingRoutes() {
  return ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => getIt<OnboardingCubit>(),
        child: child,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboardingName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const OnboardingStep1Page(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboardingStep2Path,
        name: AppRoutes.onboardingStep2Name,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const OnboardingStep2Page(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboardingStep3Path,
        name: AppRoutes.onboardingStep3Name,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const OnboardingStep3Page(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboardingStep4Path,
        name: AppRoutes.onboardingStep4Name,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const OnboardingStep4Page(),
          );
        },
      ),
    ],
  );
}
