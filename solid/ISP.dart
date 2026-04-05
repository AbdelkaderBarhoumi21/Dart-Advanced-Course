/// # I — Interface Segregation Principle (ISP)
///
/// > A class should **not be forced** to implement methods it does not use.
/// Keep interfaces small and focused.

// ─────────────────────────────────────────────────────────────
// ❌ BAD — One fat interface forces Robot to implement everything
// ─────────────────────────────────────────────────────────────

/// Bad: Robot can't attend meetings or write docs, but is forced to.
abstract class BadWorker {
  void code();
  void test();
  void attendMeeting();
  void writeDocumentation();
}

class BadRobot implements BadWorker {
  @override
  void code() => print('Generating code');

  @override
  void test() => print('Running automated tests');

  @override
  void attendMeeting() => throw UnimplementedError('Robots do not attend meetings');

  @override
  void writeDocumentation() => throw UnimplementedError('Robots do not write docs');
}

// ─────────────────────────────────────────────────────────────
// ✅ GOOD — Small, focused interfaces. Each class picks what it needs.
// ─────────────────────────────────────────────────────────────

abstract class Coder {
  void code();
}

abstract class Tester {
  void test();
}

abstract class MeetingAttendee {
  void attendMeeting();
}

abstract class DocumentationWriter {
  void writeDocumentation();
}

/// Developer uses all four interfaces.
class Developer implements Coder, Tester, MeetingAttendee, DocumentationWriter {
  @override
  void code() => print('Writing Dart code');

  @override
  void test() => print('Running tests');

  @override
  void attendMeeting() => print('In a meeting');

  @override
  void writeDocumentation() => print('Writing docs');
}

/// Robot only implements what it can actually do.
class Robot implements Coder, Tester {
  @override
  void code() => print('Generating code');

  @override
  void test() => print('Running automated tests');
}

// ─────────────────────────────────────────────────────────────
// Usage
// ─────────────────────────────────────────────────────────────

void main() {
  final dev = Developer();
  final robot = Robot();

  dev.code();
  dev.attendMeeting();

  robot.code();
  robot.test();
  // robot.attendMeeting(); // ❌ Compile error — Robot is not a MeetingAttendee
}
