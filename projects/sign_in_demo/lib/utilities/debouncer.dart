// lib/utilities/debouncer.dart
import 'dart:async'; // Timer lives here (part of the SDK)

/// Runs an action only after calls have STOPPED for [delay].
/// Example: wait until the user stops typing, then check the input once.
class Debouncer {
  Debouncer(this.delay);
  final Duration delay;
  Timer? _timer; // the pending action if any

  void run(void Function() action) {
    _timer?.cancel(); // a new call arrived: forget the old one
    _timer = Timer(delay, action); // start waiting again from zero
  }

  /// Stop any pending action (call this when you are done).
  void dispose() => _timer?.cancel();
}
