import 'package:go_router/go_router.dart';

import '../../constants/app_routes.dart';
import '../../../features/streak/presentation/pages/streak_page.dart';

List<GoRoute> streakRoutes() {
  return [
    GoRoute(
      path: AppRoutes.streakPath,
      name: AppRoutes.streakName,
      builder: (context, state) {
        final streakStr = state.uri.queryParameters['streak'] ?? '0';
        final streak = int.tryParse(streakStr) ?? 0;
        return StreakPage(currentStreak: streak);
      },
    ),
  ];
}
