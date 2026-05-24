import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/analytics/analytics.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> analyticsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.analyticsPath,
      name: AppRoutes.analyticsName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<AnalyticsCubit>(),
            child: const AnalyticsPage(),
          ),
        );
      },
    ),
  ];
}

