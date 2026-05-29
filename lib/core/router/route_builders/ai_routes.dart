import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/ai/ai.dart';
import '../../constants/constants.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';

List<RouteBase> aiRoutes() {
  return [
    GoRoute(
      path: AppRoutes.aiChatPath,
      name: AppRoutes.aiChatName,
      pageBuilder: (context, state) {
        return AppPageTransitions.slideUpTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<AiChatCubit>(),
            child: const AiChatPage(),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.aiSettingsPath,
      name: AppRoutes.aiSettingsName,
      pageBuilder: (context, state) {
        return AppPageTransitions.slideUpTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<AiSettingsCubit>(),
            child: const AiSettingsPage(),
          ),
        );
      },
    ),
  ];
}
