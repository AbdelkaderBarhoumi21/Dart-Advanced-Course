/// # Factory Method Pattern
///
/// The Factory Method pattern provides an interface for creating objects,
/// but lets subclasses decide which class to instantiate. It delegates the
/// instantiation logic to a factory method instead of calling constructors directly.
///
/// ## Key Concepts:
///
/// ### Factory Constructor
/// In Dart, we use `factory` constructors to implement the Factory Method pattern.
/// Unlike regular constructors, factory constructors:
/// - Can return an existing instance instead of always creating a new one
/// - Can return an instance of a subclass
/// - Can contain logic to decide which type to create
///
/// ### When to Use:
/// - When you don't know the exact type to create until runtime
/// - When object creation logic is complex or conditional
/// - When you want to parse data (like JSON) into different subtypes
/// - When you need centralized object creation logic
///
/// ## This Example:
/// The `Notification.fromJson()` factory method reads a 'type' field from JSON
/// and creates the appropriate notification subtype (Push, Email, or SMS).
/// This keeps the creation logic in one place and makes adding new types easier.
///
/// ## Benefits:
/// - Centralized creation logic - easy to maintain and extend
/// - Type-safe - returns the correct subclass based on runtime data
/// - Cleaner client code - no need for complex if/else chains everywhere
/// - Open/Closed Principle - add new types without modifying existing code
abstract class Notification {
  final String title;
  final String body;

  Notification({required this.title, required this.body});

  factory Notification.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'push':
        return PushNotification.fromJson(json);
      case 'email':
        return EmailNotification.fromJson(json);
      case 'sms':
        return SmsNotification.fromJson(json);
      default:
        throw ArgumentError('Type inconnu: $type');
    }
  }

  void send();
}

class PushNotification extends Notification {
  final String deviceToken;

  PushNotification({
    required super.title,
    required super.body,
    required this.deviceToken,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json['title'],
      body: json['body'],
      deviceToken: json['device_token'],
    );
  }

  @override
  void send() => print('Push → $deviceToken : $title');
}

class EmailNotification extends Notification {
  final String email;

  EmailNotification({
    required super.title,
    required super.body,
    required this.email,
  });

  factory EmailNotification.fromJson(Map<String, dynamic> json) {
    return EmailNotification(
      title: json['title'],
      body: json['body'],
      email: json['email'],
    );
  }

  @override
  void send() => print('Email → $email : $title');
}

class SmsNotification extends Notification {
  final String phoneNumber;

  SmsNotification({
    required super.title,
    required super.body,
    required this.phoneNumber,
  });

  factory SmsNotification.fromJson(Map<String, dynamic> json) {
    return SmsNotification(
      title: json['title'],
      body: json['body'],
      phoneNumber: json['phone_number'],
    );
  }

  @override
  void send() => print('SMS → $phoneNumber : $title');
}

// =============================================================================
// Usage Examples
// =============================================================================

void main() {
  // Example 1: Using the factory method with different JSON inputs
  print('=== Factory Method Pattern Demo ===\n');

  // The factory method decides which subclass to create based on 'type'
  final pushJson = {
    'type': 'push',
    'title': 'New Message',
    'body': 'You have a new message',
    'device_token': 'abc123xyz',
  };

  final emailJson = {
    'type': 'email',
    'title': 'Password Reset',
    'body': 'Click here to reset your password',
    'email': 'user@example.com',
  };

  final smsJson = {
    'type': 'sms',
    'title': 'Verification Code',
    'body': 'Your code is 123456',
    'phone_number': '+1234567890',
  };

  // ✅ Factory method handles the creation logic
  // We don't need to know which specific class to create
  final notification1 = Notification.fromJson(pushJson);
  final notification2 = Notification.fromJson(emailJson);
  final notification3 = Notification.fromJson(smsJson);

  // Send all notifications
  notification1.send(); // Output: Push → abc123xyz : New Message
  notification2.send(); // Output: Email → user@example.com : Password Reset
  notification3.send(); // Output: SMS → +1234567890 : Verification Code

  print('\n=== Type Checking ===');
  // Each notification is the correct subtype
  print('notification1 is PushNotification: ${notification1 is PushNotification}');
  print('notification2 is EmailNotification: ${notification2 is EmailNotification}');
  print('notification3 is SmsNotification: ${notification3 is SmsNotification}');

  // Example 2: Processing a list of notifications
  print('\n=== Batch Processing ===');
  final notificationList = [pushJson, emailJson, smsJson];

  for (final json in notificationList) {
    // Factory method makes batch processing clean and simple
    final notification = Notification.fromJson(json);
    notification.send();
  }

  // Example 3: Error handling for unknown types
  print('\n=== Error Handling ===');
  try {
    final invalidJson = {'type': 'carrier_pigeon', 'title': 'Test'};
    Notification.fromJson(invalidJson);
  } catch (e) {
    print('Caught error: $e'); // Output: Caught error: ArgumentError: Type inconnu: carrier_pigeon
  }
}

// =============================================================================
// Without Factory Method (Anti-pattern for comparison)
// =============================================================================

/// ❌ BAD - Without factory method, client code needs complex logic
Notification createNotificationBad(Map<String, dynamic> json) {
  final type = json['type'] as String;

  // This logic is scattered everywhere in your app!
  if (type == 'push') {
    return PushNotification(
      title: json['title'],
      body: json['body'],
      deviceToken: json['device_token'],
    );
  } else if (type == 'email') {
    return EmailNotification(
      title: json['title'],
      body: json['body'],
      email: json['email'],
    );
  } else if (type == 'sms') {
    return SmsNotification(
      title: json['title'],
      body: json['body'],
      phoneNumber: json['phone_number'],
    );
  } else {
    throw ArgumentError('Unknown type: $type');
  }
}

/// ✅ GOOD - With factory method, logic is centralized
/// Just call: Notification.fromJson(json)
/// - Cleaner code
/// - Single source of truth
/// - Easier to maintain and extend
