/// Shared app → server API auth.
///
/// Override at build time:
/// `flutter run --dart-define=EXORA_API_TOKEN=...`
class ApiAuth {
  const ApiAuth._();

  static const token = String.fromEnvironment(
    'EXORA_API_TOKEN',
    defaultValue:
        '927c2635b46d411abc357148319119454ff6f9376f8bb6a35c7a6bad8bdae0f5',
  );

  static Map<String, String> get headers {
    if (token.isEmpty) return const {};
    return {'Authorization': 'Bearer $token'};
  }
}
