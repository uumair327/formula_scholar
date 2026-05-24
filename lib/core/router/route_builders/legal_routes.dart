import 'package:go_router/go_router.dart';

import '../../../shared/shared.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> legalRoutes() {
  return [
    GoRoute(
      path: AppRoutes.privacyPolicyPath,
      name: AppRoutes.privacyPolicyName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: LegalPage.privacyPolicy(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.termsOfServicePath,
      name: AppRoutes.termsOfServiceName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: LegalPage.termsOfService(),
        );
      },
    ),
  ];
}

