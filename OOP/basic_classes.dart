// Simple class
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Hi, I\'m $name and I\'m $age years old');
  }
}

// Getters and setters
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  double get area => width * height;
  double get perimeter => 2 * (width + height);

  List<double> get dimensions => [width, height];

  set dimensions(List<double> dims) {
    width = dims[0];
    height = dims[1];
  }
}

// Private members (prefix with _)
class BankAccount {
  String _accountNumber;
  double _balance;

  BankAccount(this._accountNumber, this._balance);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      return true;
    }
    return false;
  }
}

void main() {
  Person p = Person('Abdelkader', 25);
  p.introduce();
  print('My name is ${p.name} and my age is ${p.age}');

  Rectangle r = Rectangle(50.5, 120.5);
  print('Area is: ${r.area}');
  print('Perimter is: ${r.perimeter}');
  r.dimensions = [50, 60];
  print('Dimesions: ${r.dimensions}');
}
