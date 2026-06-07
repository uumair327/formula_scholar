enum AppEnvironment {
  uat,
  prod;

  bool get isUat => this == AppEnvironment.uat;
  bool get isProd => this == AppEnvironment.prod;

  // Golden Rule: No Magic Values. Configure them here depending on the environment.
  String get name {
    switch (this) {
      case AppEnvironment.uat:
        return 'Formula UAT';
      case AppEnvironment.prod:
        return 'Formula Scholar';
    }
  }

  // Example of how base URLs or Feature flags should be exposed based on environment
  // String get apiBaseUrl => ...
}
