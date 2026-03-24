/// # Builder Pattern
///
/// The Builder pattern separates the construction of a complex object from its
/// representation, allowing step-by-step object creation with a fluent interface.
///
/// ## Key Concepts:
///
/// ### Why Use Builder Pattern?
/// - When an object has many parameters (especially optional ones)
/// - To avoid "telescoping constructors" (multiple constructor overloads)
/// - To create immutable objects step-by-step
/// - To make object creation more readable and maintainable
///
/// ### Method Chaining (Fluent Interface)
/// The builder methods return `this` (the builder instance itself), enabling
/// method chaining like: `builder.setName('John').setAge(25).build()`
///
/// Without returning `this`, you would need to write:
/// ```dart
/// var builder = UserBuilder();
/// builder.setName('John');
/// builder.setAge(25);
/// var user = builder.build();
/// ```
///
/// With `return this`, you get a fluent, readable syntax:
/// ```dart
/// var user = UserBuilder()
///   .setName('John')
///   .setAge(25)
///   .build();
/// ```
///
/// ## This Example:
/// - `User` class has a private constructor `User._()` - only the builder can create it
/// - `UserBuilder` accumulates values in mutable fields
/// - Each setter returns `this` for method chaining
/// - `build()` validates required fields and creates the immutable User object
class User {
  final String name;
  final int age;
  final String city;
  final String? job;
  final bool isActive;
  final String? bio;

  User._({
    required this.name,
    required this.age,
    required this.city,
    this.job,
    this.isActive = false,
    this.bio,
  });

  @override
  String toString() =>
      'User(name: $name, age: $age, city: $city, job: $job, isActive: $isActive, bio: $bio)';
}

class UserBuilder {
  // Mutable fields - accumulate values during the building process
  String? _name;
  int? _age;
  String? _city;
  String? _job;
  bool _isActive = false;
  String? _bio;

  /// Sets the user's name.
  ///
  /// **Why `return this`?**
  /// Returning `this` (the current UserBuilder instance) enables **method chaining**.
  /// This allows you to call multiple setter methods in a fluent, readable chain:
  ///
  /// ```dart
  /// UserBuilder()
  ///   .setName('John')    // returns the UserBuilder instance
  ///   .setAge(25)         // can be called on the returned instance
  ///   .setCity('Paris')   // and so on...
  ///   .build();
  /// ```
  ///
  /// Without `return this`, each method would return `void` and you'd need to
  /// call them separately on multiple lines, making the code less elegant.
  UserBuilder setName(String name) {
    _name = name;
    return this; // Returns the builder itself for method chaining
  }

  /// Sets the user's age. Returns `this` for chaining.
  UserBuilder setAge(int age) {
    _age = age;
    return this; // Method chaining
  }

  /// Sets the user's city. Returns `this` for chaining.
  UserBuilder setCity(String city) {
    _city = city;
    return this; // Method chaining
  }

  /// Sets the user's job (optional). Returns `this` for chaining.
  UserBuilder setJob(String job) {
    _job = job;
    return this; // Method chaining
  }

  /// Sets whether the user is active. Returns `this` for chaining.
  UserBuilder setActive(bool value) {
    _isActive = value;
    return this; // Method chaining
  }

  /// Sets the user's bio (optional). Returns `this` for chaining.
  UserBuilder setBio(String bio) {
    _bio = bio;
    return this; // Method chaining
  }

  /// Builds and returns the immutable User object.
  ///
  /// This method:
  /// 1. Validates that all required fields are set
  /// 2. Creates the final immutable User object
  /// 3. Does NOT return `this` - returns the built User instead
  ///
  /// Note: This is the only method that doesn't return `this` because
  /// it's the final step that produces the actual User object.
  User build() {
    // Validate required fields
    assert(_name != null, 'Name is required');
    assert(_age != null, 'Age is required');
    assert(_city != null, 'City is required');

    // Create and return the immutable User object
    return User._(
      name: _name!,
      age: _age!,
      city: _city!,
      job: _job,
      isActive: _isActive,
      bio: _bio,
    );
  }
}

// =============================================================================
// Usage Examples
// =============================================================================

void main() {
  print('=== Builder Pattern Demo ===\n');

  // Example 1: Full user with all optional fields
  print('Example 1: Complete user profile');
  final user1 = UserBuilder()
      .setName('Abdelkader')
      .setAge(25)
      .setCity('Tunis')
      .setJob('Flutter developer')
      .setActive(true)
      .setBio('Passionate about mobile development')
      .build();

  print(user1);
  // Output: User(name: Abdelkader, age: 25, city: Tunis, job: Flutter developer, isActive: true, bio: Passionate about mobile development)

  // Example 2: Minimal user with only required fields
  print('\nExample 2: Minimal user (only required fields)');
  final user2 = UserBuilder()
      .setName('Sarah')
      .setAge(30)
      .setCity('Paris')
      .build();

  print(user2);
  // Output: User(name: Sarah, age: 30, city: Paris, job: null, isActive: false, bio: null)

  // Example 3: Demonstrating the power of method chaining
  print('\nExample 3: Flexible order of setters');
  final user3 = UserBuilder()
      .setCity('London') // Order doesn't matter!
      .setAge(28)
      .setBio('Software engineer')
      .setName('Alex')
      .setActive(true)
      .build();

  print(user3);

  // Example 4: Accessing immutable fields
  print('\nExample 4: User object is immutable');
  print('User1 name: ${user1.name}');
  print('User1 job: ${user1.job}');
  // user1.name = 'New Name'; // ❌ Error: Can't modify final field

  // Example 5: Conditional building
  print('\nExample 5: Conditional field setting');
  final builder = UserBuilder()
      .setName('Mohammed')
      .setAge(35)
      .setCity('Cairo');

  // Add optional fields conditionally
  bool isPremiumUser = true;
  if (isPremiumUser) {
    builder.setJob('Senior Developer').setBio('Premium member since 2020');
  }

  final user4 = builder.build();
  print(user4);
}

// =============================================================================
// Without Builder Pattern (Anti-pattern for comparison)
// =============================================================================

/// ❌ BAD - Without builder: Telescoping constructors
///
/// Problems:
/// - Hard to remember parameter order
/// - Need multiple constructor overloads for different combinations
/// - Less readable when many parameters
/// - Easy to mix up parameters of the same type
class UserWithoutBuilder {
  final String name;
  final int age;
  final String city;
  final String? job;
  final bool isActive;
  final String? bio;

  // Need multiple constructors for different combinations
  UserWithoutBuilder(this.name, this.age, this.city)
      : job = null,
        isActive = false,
        bio = null;

  UserWithoutBuilder.withJob(this.name, this.age, this.city, this.job)
      : isActive = false,
        bio = null;

  UserWithoutBuilder.complete(
    this.name,
    this.age,
    this.city,
    this.job,
    this.isActive,
    this.bio,
  );

  // Usage becomes confusing:
  // var user = UserWithoutBuilder.complete('John', 25, 'Paris', 'Dev', true, 'Bio');
  // Which parameter is which? 🤔
}

/// ✅ GOOD - With builder pattern:
/// - Clear, readable syntax
/// - Method names make it obvious what each value means
/// - Optional parameters are easy to handle
/// - Can set parameters in any order
/// - Method chaining with `return this` makes it elegant
///
/// Usage:
/// var user = UserBuilder()
///   .setName('John')        // Clear what this is
///   .setAge(25)             // Clear what this is
///   .setCity('Paris')       // Clear what this is
///   .setJob('Dev')          // Optional, easy to add or skip
///   .build();
