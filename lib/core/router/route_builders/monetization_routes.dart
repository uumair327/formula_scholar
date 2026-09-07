import 'package:go_router/go_router.dart';
import '../../constants/app_routes.dart';
import '../../../features/monetization/presentation/pages/monetization_debug_page.dart';
import '../../../features/monetization/presentation/pages/premium_plans_page.dart';

List<GoRoute> monetizationRoutes() {
  return [
    GoRoute(
      path: AppRoutes.premiumPath,
      name: AppRoutes.premiumName,
      builder: (context, state) => const PremiumPlansPage(),
    ),
    GoRoute(
      path: AppRoutes.monetizationDebugPath,
      name: AppRoutes.monetizationDebugName,
      builder: (context, state) => const MonetizationDebugPage(),
    ),
  ];
}
