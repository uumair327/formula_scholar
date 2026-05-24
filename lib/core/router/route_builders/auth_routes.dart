import 'package:go_router/go_router.dart';

import '../../../features/auth/auth.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> authRoutes() {
  return [
    GoRoute(
      path: AppRoutes.loginPath,
      name: AppRoutes.loginName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: const LoginPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.signupPath,
      name: AppRoutes.signupName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: const SignupPage(),
        );
      },
    ),
  ];
}

