import 'package:formula_scholar/core/config/app_environment.dart';
import 'package:formula_scholar/firebase_options_prod.dart';
import 'package:formula_scholar/main.dart';

void main() {
  bootstrap(AppEnvironment.prod, DefaultFirebaseOptions.currentPlatform);
}
