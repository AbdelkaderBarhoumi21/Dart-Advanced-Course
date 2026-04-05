/// # SOLID Principles — All 5 in One Example
///
/// A notification system that applies SRP, OCP, LSP, ISP, and DIP together.

// ─────────────────────────────────────────────────────────────
// ISP — Small, focused interfaces instead of one fat one
// ─────────────────────────────────────────────────────────────

/// Can send a notification.
abstract class NotificationSender {
  void send(String message);
}

/// Can log a notification.
abstract class NotificationLogger {
  void log(String message);
}

// ─────────────────────────────────────────────────────────────
// SRP — Each class has one job
// OCP — Add new channels without modifying existing ones
// LSP — All implementations are safely substitutable
// ─────────────────────────────────────────────────────────────

/// Sends via email.
class EmailNotification implements NotificationSender {
  @override
  void send(String message) => print('[EMAIL] $message');
}

/// Sends via SMS.
class SmsNotification implements NotificationSender {
  @override
  void send(String message) => print('[SMS] $message');
}

/// Sends via push notification — added without touching existing classes (OCP).
class PushNotification implements NotificationSender {
  @override
  void send(String message) => print('[PUSH] $message');
}

/// Logs notifications to console — separate responsibility (SRP).
class ConsoleNotificationLogger implements NotificationLogger {
  @override
  void log(String message) => print('[LOG] Notification sent: $message');
}

// ─────────────────────────────────────────────────────────────
// DIP — High-level service depends on abstractions, not concrete classes
// ─────────────────────────────────────────────────────────────

/// Orchestrates sending + logging via abstractions.
class NotificationService {
  final NotificationSender _sender;
  final NotificationLogger _logger;

  NotificationService({
    required NotificationSender sender,
    required NotificationLogger logger,
  })  : _sender = sender,
        _logger = logger;

  void notify(String message) {
    _sender.send(message);
    _logger.log(message);
  }
}

// ─────────────────────────────────────────────────────────────
// Usage
// ─────────────────────────────────────────────────────────────

void main() {
  final logger = ConsoleNotificationLogger();

  // Send via email
  final emailService = NotificationService(
    sender: EmailNotification(),
    logger: logger,
  );
  emailService.notify('Welcome!');

  // Send via SMS — just swap the sender, nothing else changes
  final smsService = NotificationService(
    sender: SmsNotification(),
    logger: logger,
  );
  smsService.notify('Your code is 1234');

  // Send via push — new channel, zero existing code modified
  final pushService = NotificationService(
    sender: PushNotification(),
    logger: logger,
  );
  pushService.notify('New update available');
}

/// ## How each principle is applied:
///
/// | Principle | Where                                                      |
/// |-----------|------------------------------------------------------------|
/// | **SRP**   | Each class has one job: send, log, or orchestrate.         |
/// | **OCP**   | New channels (Push) added without modifying existing code. |
/// | **LSP**   | Email, SMS, Push are all substitutable for NotificationSender. |
/// | **ISP**   | Sending and logging are separate interfaces.               |
/// | **DIP**   | NotificationService depends on abstractions, not concrete classes. |
