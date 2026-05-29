import 'package:go_router/go_router.dart';

import '../../domain/domain.dart';

class GoRouterAiNavigationAdapter implements AiNavigationPort {
  const GoRouterAiNavigationAdapter(this._router);

  final GoRouter _router;

  @override
  String get currentLocation {
    return _router.routeInformationProvider.value.uri.toString();
  }

  @override
  void goNamed(String routeName) {
    _router.goNamed(routeName);
  }

  @override
  void pushNamed(String routeName) {
    _router.pushNamed(routeName);
  }

  @override
  Future<bool> maybePop() async {
    if (!_router.canPop()) return false;
    _router.pop();
    return true;
  }
}
