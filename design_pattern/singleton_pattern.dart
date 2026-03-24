/// # Singleton Pattern
///
/// The Singleton pattern ensures that a class has only one instance throughout
/// the entire application and provides a global point of access to that instance.
///
/// ## Key Concepts:
///
/// ### Private Constructor
/// The constructor `AppConfig._internal()` is a **named private constructor**.
/// - The underscore `_` prefix makes it private to this library
/// - This prevents external code from creating new instances using `AppConfig()`
/// - Without this, anyone could create multiple instances, breaking the Singleton pattern
///
/// ### Static Instance
/// `static final _instance` creates the single instance when the class is first accessed.
/// - It's created only once and reused for all subsequent calls
/// - The `final` keyword ensures it cannot be reassigned
///
/// ### Public Accessor
/// The `instance` getter provides controlled access to the singleton instance.
///
/// ## Usage:
/// ```dart
///  Correct: Access the singleton instance
/// AppConfig.instance.baseUrl = 'https://api.prod.com';
///
///  Wrong: Cannot create new instances (compile error)
///  var config = AppConfig(); // Error: The method 'AppConfig' isn't defined
/// ```
///
/// ## Benefits:
/// - Ensures configuration consistency across the entire app
/// - Single point of control for shared resources
/// - Lazy initialization (created when first accessed)
class AppConfig {
  // Private named constructor - prevents external instantiation
  AppConfig._internal();

  // Single instance created using the private constructor
  static final AppConfig _instance = AppConfig._internal();

  // Public getter to access the singleton instance
  static AppConfig get instance => _instance;

  // Shared configuration properties
  String baseUrl = 'https://api.example.com';
  bool isDarkMode = false;
  String local = 'EN';
}

// =============================================================================
// Common Pitfalls to Avoid
// =============================================================================

/// ❌ BAD - Singleton with mutable shared state accessible everywhere
///
/// Problem: The `sharedState` list can be modified by any part of the app,
/// leading to unpredictable behavior, race conditions, and hard-to-debug issues.
/// When multiple parts of your code modify the same mutable collection,
/// it becomes nearly impossible to track who changed what and when.
class BadSingleton {
  static final instance = BadSingleton._();
  BadSingleton._();

  // Dangerous: Anyone can add/remove/modify items
  List<dynamic> sharedState = [];
}

/// ✅ GOOD - Singleton with read-only or protected state
///
/// Solution: Use `late final` for one-time initialization or provide
/// controlled access through getters. This prevents accidental modifications
/// and makes the data flow in your app more predictable.
///
/// Key improvements:
/// - `late final` ensures the value is set once and never changed
/// - Private field `_apiKey` prevents direct external access
/// - Public getter provides read-only access
/// - Explicit `init()` method controls when initialization happens
class GoodSingleton {
  static final instance = GoodSingleton._();
  GoodSingleton._();

  late final String _apiKey; // Initialized once, immutable after

  void init(String key) => _apiKey = key;
  String get apiKey => _apiKey; // Read-only access
}

void main() {
  // Access the same instance everywhere in the app
  AppConfig.instance.baseUrl = 'https://api.prod.com';
  print(AppConfig.instance.local);

  // Verify it's truly a singleton - both references point to the same instance
  var config1 = AppConfig.instance;
  var config2 = AppConfig.instance;
  print('Same instance? ${identical(config1, config2)}'); // Output: true
}
