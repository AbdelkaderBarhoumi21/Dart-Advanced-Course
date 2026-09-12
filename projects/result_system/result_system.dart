import 'app_error_type.dart';
import 'future_result_extension.dart';
import 'result.dart';
import 'failure.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// Fake "repository" layer.
///
/// Each function uses Future.delayed to simulate a real network/IO call
/// that takes time to answer — exactly like a Dio request would. Printing
/// timestamps before/after each call makes the async timing visible in the
/// console output instead of just trusting that "it must be async".
/// ─────────────────────────────────────────────────────────────────────────

/// Simulates fetching a user's age from a slow server.
/// Succeeds for userId >= 0, fails with `notFound` for userId < 0.
///
Future<Result<int>> fetchUserAge(int userId) async {
  print('[fetchUserAge] request sent for userId=$userId...');
  await Future.delayed(const Duration(seconds: 1));
  if (userId < 0) {
    return const Result.failure(
      Failure(AppErrorType.notFound, message: "No user with a negative ID"),
    );
  }

  final age = 20 + userId;
  print('[fetchUserAge] response received for userId=$userId, age=$age');
  return Result.success(age);
}

/// Simulates fetching a user's home city, given their age.
/// Fails with `server` if the age is suspiciously high (> 99).
Future<Result<String>> fetchCityForAge(int age) async {
  print('[fetchCityForAge] request sent for age=$age...');
  await Future.delayed(const Duration(milliseconds: 800));

  if (age > 99) {
    return const Result.failure(
      Failure(AppErrorType.server, message: 'Suspicious age, server refused'),
    );
  }
  final city = age < 30 ? 'Tunis' : 'Sfax';
  print('[fetchCityForAge] response received for age=$age, city=$city');
  return Result.success(city);
}

/// Simulates a flaky network call that always fails.
Future<Result<int>> fetchWithNetworkDown() async {
  print('[fetchWithNetworkDown] request sent...');
  await Future.delayed(const Duration(seconds: 1));
  return const Result.failure(Failure(AppErrorType.network));
}

/// ─────────────────────────────────────────────────────────────────────────
/// Demo
/// ─────────────────────────────────────────────────────────────────────────
Future<void> _demoWhen() async {
  final stopwatch = Stopwatch()..start();

  final message = await fetchUserAge(5).when(
    onSuccess: (age) =>
        'Success after ${stopwatch.elapsedMilliseconds}ms: age is $age',
    onFailure: (failure) =>
        'Failure after ${stopwatch.elapsedMilliseconds}ms: $failure',
  );
  print(message);
  stopwatch.reset();

  final message2 = await fetchUserAge(-1).when(
    onSuccess: (age) =>
        'Success after ${stopwatch.elapsedMilliseconds}ms: age is $age',
    onFailure: (failure) =>
        'Failure after ${stopwatch.elapsedMilliseconds}ms: $failure',
  );
  print(message2);
}

Future<void> _demoMap() async {
  final Result<String> formatted = await fetchUserAge(10)
      .mapData((age) => "Formatted age : $age years old");
  formatted.when(
    onSuccess: (text) => print(text),
    onFailure: (failure) => print("Unexpected failure: $failure"),
  );

  final Result<String> formattedFailure = await fetchUserAge(-5)
      .mapData((age) => "Formatted age : $age years old"); // never run
  formattedFailure.when(
    onSuccess: (text) => print(text),
    onFailure: (failure) => print("Got failure as expected: $failure"),
  );
}

Future<void> _demoFlatMap() async {
  final ageResult = await fetchUserAge(12);
  final cityResult = await ageResult.asyncFlatMap(
    (age) => fetchCityForAge(age),
  );

  cityResult.when(
    onSuccess: (city) => print("User lives in: $city"),
    onFailure: (failure) => print("Could not reslove city: $failure"),
  );

  print('--- now with a failing first step ---');

  final ageResultFailed = await fetchUserAge(-2);
  final cityResultFailed = await ageResultFailed.asyncFlatMap(
    (age) => fetchCityForAge(age),
  );
  cityResultFailed.when(
    onSuccess: (city) => print("User lives in: $city"),
    onFailure: (failure) =>
        print('Short-circuited, city fetch skipped: $failure'),
  );
}

Future<void> _demoGetOrElse() async {
  final ageResult = await fetchWithNetworkDown();
  final safeAge = ageResult.getOrElse(0);
  print('Safe age: $safeAge');
}

Future<void> _demoUnwrap() async {
  try {
    final age = await fetchUserAge(7).unwrap();
    print("Unwrapped age: $age");

    final age2 = await fetchUserAge(-9).unwrap();
    print("Unwrapped age2: $age2");
  } catch (e) {
    print("Caught thrown Failure from unwrap: $e");
  }
}

Future<void> main() async {
  print('=== 1) Basic success/failure with when() ===');
  await _demoWhen();
  print('\n=== 2) map() — transform the success value only ===');
  await _demoMap();
  print('\n=== 3) flatMap() — transform the success value only ===');
  await _demoFlatMap();
  print('\n=== 4) getOrElse() — provide a fallback value ===');
  await _demoGetOrElse();
  print('\n=== 5) unwrap() — unwrap the success value or throw ===');
  await _demoUnwrap();
}
