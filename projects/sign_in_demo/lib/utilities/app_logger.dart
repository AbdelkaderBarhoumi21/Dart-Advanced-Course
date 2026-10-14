import 'dart:io';

/// The contract: "something that can write a message".
/// Features depend on THIS, never on a concrete logger.
abstract interface class AppLogger {
  void log(String message);
}

/// Write to the terminal
class ConsoleLogger implements AppLogger {
  @override
  void log(String message) => print('[LOG] $message');
}

/// Appends every message to a file on disk.
/// The file path is passed in, so no app name is hard-coded here.
class FileLogger implements AppLogger {
  final String _filePath;
  FileLogger(this._filePath);
  @override
  void log(String message) {
    // FileMode.append adds to the end instead of overwriting the file.
    File(_filePath).writeAsStringSync('$message\n', mode: FileMode.append);
  }
}

/// Wraps ANY other logger and adds a time in front of each message.
/// This is one utility using another utility — still generic.

class TimestampLogger implements AppLogger {
  TimestampLogger(this._inner);
  final AppLogger _inner;
  @override
  void log(String message) {
    final time = DateTime.now().toIso8601String();
    _inner.log('$time $message');
  }
}
