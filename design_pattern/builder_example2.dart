class User {
  final String name;
  final int age;
  final String city;
  final String? job;
  final bool isActive;

  User._({
    required this.name,
    required this.age,
    required this.city,
    this.job,
    this.isActive = false,

  });

  @override
  String toString() =>
      'User(name: $name, age: $age, city: $city, job: $job, isActive: $isActive)';
}

class UserBuilder {
  String? name;
  int? age;
  String? city;
  String? job;
  bool isActive = false;

  User build() =>
      User._(name: name!, age: age!, city: city!, job: job, isActive: isActive);
}

void main() {
  // .. spread operator
  final user =
      (UserBuilder()
            ..name = 'Abdelkader'
            ..age = 25
            ..city = 'Tunis'
            ..job = 'Flutter Developer'
            ..isActive = true)
          .build();

  print(user);
  print(user.name);
}
