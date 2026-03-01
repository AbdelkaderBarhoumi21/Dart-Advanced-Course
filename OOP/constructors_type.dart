// Default constructor
class Point {
  double x;
  double y;
  
  Point(this.x, this.y);
}

// Named constructors
class User {
  String name;
  String email;
  int age;
  
  User(this.name, this.email, this.age);
  
  User.guest() : 
    name = 'Guest',
    email = 'guest@example.com',
    age = 0;
  
  User.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    email = json['email'],
    age = json['age'];
  
  User.admin(String name) :
    name = name,
    email = '$name@admin.com',
    age = 25;
}

// Factory constructors
class Logger {
  static final Map<String, Logger> _cache = {};
  final String name;
  
  Logger._(this.name);
  
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._(name));
  }
  
  void log(String message) {
    print('[$name] $message');
  }
}

// Constant constructors
class ImmutablePoint {
  final double x;
  final double y;
  
  const ImmutablePoint(this.x, this.y);
}

// Redirecting constructors
class Temperature {
  final double celsius;
  
  Temperature.celsius(this.celsius);
  Temperature.fahrenheit(double fahrenheit) 
      : this.celsius((fahrenheit - 32) * 5 / 9);
  Temperature.kelvin(double kelvin) 
      : this.celsius(kelvin - 273.15);
}
