import 'app_error_type.dart';

class Failure {
  const Failure(this.type, {this.message});
  final AppErrorType type;
  final String? message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && type == other.type && message == other.message;

  @override
  int get hashCode => Object.hash(type, message);

  @override
  String toString() => 'Failure(type: $type, message: $message)';
}
