abstract class AiNavigationPort {
  String get currentLocation;

  void goNamed(String routeName);

  void pushNamed(String routeName);

  Future<bool> maybePop();
}
