// lib/utilities/app_environment.dart
/// The SHAPE of an environment. It holds values but chooses none of them.
/// Each app (the wiring) fills in its own values.
class AppEnvironment {
  const AppEnvironment({
    required this.name,
    required this.apiDomain,
    required this.isProduction,
  });
  final String name;
  final String apiDomain;
  final bool isProduction;
  String get baseUrl => 'https://$apiDomain';
}
