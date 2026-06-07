import 'package:formula_scholar/core/config/app_environment.dart';
import 'package:formula_scholar/firebase_options_uat.dart';
import 'package:formula_scholar/main.dart';

void main() {
  bootstrap(AppEnvironment.uat, DefaultFirebaseOptions.currentPlatform);
}
