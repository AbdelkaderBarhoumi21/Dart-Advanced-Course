import 'failure.dart';

/// A value that is either a [Success] or a [ResultFailure].
///
/// Replaces `Either<Failure, T>` with no external dependency: Dart 3 sealed
/// classes give the compiler the same exhaustiveness guarantee natively.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is ResultFailure<T>;

  /// The data, or `null` when this is a failure.
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    ResultFailure<T>() => null,
  };

  /// The failure, or `null` when this is a success.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultFailure<T>(:final failure) => failure,
  };

  /// Exhaustive fold over both branches — the `Either.fold` equivalent.
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success<T>(:final data) => onSuccess(data),
    ResultFailure<T>(:final failure) => onFailure(failure),
  };

  /// Transforms the success value, leaving a failure untouched.
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success<T>(:final data) => Success<R>(transform(data)),
    ResultFailure<T>(:final failure) => ResultFailure<R>(failure),
  };

  /// Chains another [Result]-returning operation. Short-circuits on failure.
  Result<R> flatMap<R>(Result<R> Function(T data) transform) => switch (this) {
    Success<T>(:final data) => transform(data),
    ResultFailure<T>(:final failure) => ResultFailure<R>(failure),
  };

  /// The data, or [fallback] when this is a failure.
  T getOrElse(T fallback) => dataOrNull ?? fallback;
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => Object.hash(Success<T>, data);

  @override
  String toString() => 'Success<$T>($data)';
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T> && failure == other.failure;

  @override
  int get hashCode => Object.hash(ResultFailure<T>, failure);

  @override
  String toString() => 'ResultFailure<$T>($failure)';
}
