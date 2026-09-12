import 'failure.dart';
import 'result.dart';

/// Convenience helpers so callers can chain `.when` / `.mapData` / `.unwrap`
/// directly on a `Future<Result<T>>`, instead of awaiting first and then
/// calling the `Result` method on a separate line.

extension FutureResultX<T> on Future<Result<T>> {
  /// Awaits this future, then folds the resulting [Result].
  Future<R> when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) async => (await this).when(onSuccess: onSuccess, onFailure: onFailure);

  /// Awaits this future, then transforms the success value.
  /// Named `mapData` (not `map`) to avoid colliding with `Future.map`,
  /// which already exists natively on `Future`/`Stream`.
  /// Turns Future<Result<User>> into Future<Result<String>> (extracting the user's name or formatting):
  Future<Result<R>> mapData<R>(R Function(T data) transform) async =>
      (await this).map(transform);

  /// Unwraps to the raw value, throwing the [Failure] on the failure branch.
  Future<T> unwrap() async => (await this).when(
    onSuccess: (data) => data,
    onFailure: (failure) => throw failure,
  );
}

/// Async-aware version of `flatMap`, for chaining a *second* network/IO
/// call whose function returns `Future<Result<R>>` (the normal case —
/// `flatMap` alone only accepts a synchronous `Result<R> Function(T)`).
extension ResultAsyncX<T> on Result<T> {
  Future<Result<R>> asyncFlatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async => switch (this) {
    Success<T>(:final data) => await transform(data),
    ResultFailure<T>(:final failure) => ResultFailure<R>(failure),
  };
}
