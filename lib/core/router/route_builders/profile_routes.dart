import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/profile/profile.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> profileSubRoutes() {
  return [
    GoRoute(
      path: AppRoutes.accountInfoPath,
      name: AppRoutes.accountInfoName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: const AccountInformationPage(),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notificationsPath,
      name: AppRoutes.notificationsName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<NotificationsCubit>(),
            child: const NotificationsPage(),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.languageLocalizationPath,
      name: AppRoutes.languageLocalizationName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: const LanguageLocalizationPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.helpSupportPath,
      name: AppRoutes.helpSupportName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: const HelpSupportPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.aboutAppPath,
      name: AppRoutes.aboutAppName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: const AboutAppPage(),
        );
      },
    ),
  ];
}
