import 'dart:convert';
import 'dart:io';

/// # S — Single Responsibility Principle (SRP)
///
/// ## The Rule
///
/// > A class should have only **one reason to change**.
///
/// Each class should do exactly one job. If a class handles two different
/// concerns, a change in one concern could break the other.
///
/// ## The Problem It Solves
///
/// Imagine a `UserProfile` widget in Flutter that:
/// - Fetches user data from an API
/// - Validates the user's email format
/// - Builds the UI
/// - Handles navigation
///
/// If the API response format changes, you have to edit the same file that
/// builds the UI. If the validation rules change, you risk breaking the
/// navigation. Everything is tangled.

// ─────────────────────────────────────────────────────────────
// ❌ BAD EXAMPLE — Violating SRP
// ─────────────────────────────────────────────────────────────

/// **Bad Example:** This widget does everything — fetches data, validates
/// input, and builds UI. It has **three reasons to change**, which violates SRP.
///
/// ```dart
/// class UserProfilePage extends StatefulWidget {
///   @override
///   _UserProfilePageState createState() => _UserProfilePageState();
/// }
///
/// class _UserProfilePageState extends State<UserProfilePage> {
///   Map<String, dynamic>? userData;
///
///   @override
///   void initState() {
///     super.initState();
///     _fetchUser();
///   }
///
///   // PROBLEM: This class fetches data...
///   Future<void> _fetchUser() async {
///     final response = await http.get(Uri.parse('https://api.example.com/user/1'));
///     setState(() {
///       userData = jsonDecode(response.body);
///     });
///   }
///
///   // PROBLEM: ...validates data...
///   bool _isEmailValid(String email) {
///     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
///   }
///
///   // PROBLEM: ...AND builds UI. Three responsibilities in one class.
///   @override
///   Widget build(BuildContext context) {
///     if (userData == null) return CircularProgressIndicator();
///     return Column(
///       children: [
///         Text(userData!['name']),
///         Text(userData!['email']),
///         if (!_isEmailValid(userData!['email']))
///           Text('Invalid email', style: TextStyle(color: Colors.red)),
///       ],
///     );
///   }
/// }
/// ```
///
/// **Why this is bad:** If you change the API URL, you edit the UI file.
/// If you add a new validation rule, you edit the UI file. Every change
/// touches the same place. Testing is also impossible without running
/// the full widget.

// ─────────────────────────────────────────────────────────────
// ✅ GOOD EXAMPLE — Following SRP
// ─────────────────────────────────────────────────────────────

/// ## Good Example: Split into focused classes
///
/// Each class has **one reason to change**:
/// - [User] — holds data (changes only when the data model changes).
/// - [UserRepository] — fetches data (changes only when the API changes).
/// - [EmailValidator] — validates emails (changes only when rules change).
/// - `UserProfilePage` — renders UI (changes only when the layout changes).
///
/// You can test each piece independently.

/// A simple data model representing a user.
///
/// **Responsibility:** Hold user data — nothing else.
/// This class changes only when the data model changes.
class User {
  final int id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], email: json['email'], name: json['name']);
  }
}

/// Handles fetching user data from the API.
///
/// **Responsibility:** Data fetching only.
/// This class changes only when the API endpoint or response format changes.
///
/// ```dart
/// final repo = UserRepository();
/// final user = await repo.fetchUser(1);
/// print(user.name);
/// ```
class UserRepository {
  final HttpClient _client;

  UserRepository({HttpClient? client}) : _client = client ?? HttpClient();

  Future<User> fetchUser(int id) async {
    final request = await _client.getUrl(
      Uri.parse('https://api.example.com/user/$id'),
    );
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    final json = jsonDecode(body);
    return User.fromJson(json);
  }
}

/// Validates email addresses.
///
/// **Responsibility:** Validation logic only.
/// This class changes only when the validation rules change.
///
/// ```dart
/// final validator = EmailValidator();
/// print(validator.isValid('test@example.com')); // true
/// print(validator.isValid('invalid'));           // false
/// ```
class EmailValidator {
  bool isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// The UI widget — depends on [User] and [EmailValidator] via constructor.
///
/// **Responsibility:** Render the user profile UI — nothing else.
/// This class changes only when the visual layout changes.
///
/// ```dart
/// // The widget receives its dependencies from outside (SRP + DIP).
/// UserProfilePage(
///   user: user,
///   validator: EmailValidator(),
/// );
/// ```
///
/// ## Summary
///
/// | Class             | Responsibility       | Changes when…                |
/// |-------------------|----------------------|------------------------------|
/// | [User]            | Hold data            | Data model changes           |
/// | [UserRepository]  | Fetch data from API  | API endpoint/format changes  |
/// | [EmailValidator]  | Validate emails      | Validation rules change      |
/// | `UserProfilePage` | Render UI            | UI layout changes            |
///
/// **The key takeaway:** Each class has **one job** and **one reason to change**.
/// You can test, modify, and reuse each piece independently.

// class UserProfilePage extends StatelessWidget {
//   final User user;
//   final EmailValidator validator;
//
//   const UserProfilePage({required this.user, required this.validator});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(user.name),
//         Text(user.email),
//         if (!validator.isValid(user.email))
//           Text('Invalid email', style: TextStyle(color: Colors.red)),
//       ],
//     );
//   }
// }
