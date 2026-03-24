/// # Prototype Pattern - Clone Behavior
///
/// ## Memory Sharing After Clone:
///
/// | Type                  | After Clone          | After Modification       | Safety                                                    |
/// |-----------------------|----------------------|--------------------------|-----------------------------------------------------------|
/// | String (name, email)  | Same memory address  | NEW memory address       | ✅ SAFE - Strings are immutable, changing creates new string |
/// | List (permissions)    | Same memory address  | STILL same address       | ⚠️ UNSAFE - Lists are mutable, both users see changes     |
///
/// ## Key Points:
/// - **Shallow Clone**: Copies object but nested objects (Lists, Maps) share memory
/// - **Deep Clone**: Copies everything including nested objects - independent copies
abstract class Cloneable<T> {
  T clone();
}

class UserProfile implements Cloneable<UserProfile> {
  String name;
  String email;
  List<String> permissions;
  UserProfile({
    required this.name,
    required this.email,
    required this.permissions,
  });
  @override
  UserProfile clone() => UserProfile(
        name: name, // ✅ Safe: Strings are immutable
        email: email, // ✅ Safe: Strings are immutable
        permissions: permissions, // ⚠️ SHALLOW CLONE: Shares same List reference!
      );

  // ✅ Deep clone - creates independent copy
  UserProfile deepClone() => UserProfile(
        name: name,
        email: email,
        permissions: List.from(permissions), // Creates NEW list
      );

  UserProfile copyWith({
    String? name,
    String? email,
    List<String>? permissions,
  }) => UserProfile(
    name: name ?? this.name,
    email: email ?? this.email,
    permissions: permissions ?? this.permissions,
  );
}

void main() {
  print('=== Shallow Clone Problem ===');
  final user1 = UserProfile(
    name: 'Alice',
    email: 'alice@test.com',
    permissions: ['read'],
  );

  final user2 = user1.clone(); // ⚠️ Shallow clone
  user2.permissions.add('write'); // Modifies BOTH!

  print('user1.permissions: ${user1.permissions}'); // ['read', 'write'] 😱
  print('user2.permissions: ${user2.permissions}'); // ['read', 'write']
  print('Same list? ${identical(user1.permissions, user2.permissions)}'); // true

  print('\n=== Deep Clone Solution ===');
  final user3 = UserProfile(
    name: 'Bob',
    email: 'bob@test.com',
    permissions: ['read'],
  );

  final user4 = user3.deepClone(); // ✅ Deep clone
  user4.permissions.add('write'); // Only modifies user4

  print('user3.permissions: ${user3.permissions}'); // ['read'] ✅
  print('user4.permissions: ${user4.permissions}'); // ['read', 'write']
  print('Same list? ${identical(user3.permissions, user4.permissions)}'); // false
}
