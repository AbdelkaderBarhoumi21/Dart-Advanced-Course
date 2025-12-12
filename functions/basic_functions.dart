// Simple function
void greet(String name) {
  print('Hello, $name!');
}

// Return value
int add(int a, int b) {
  return a + b;
}

// Arrow function
int multiply(int a, int b) => a * b;

// Optional positional parameters
String describe(String name, [int? age]) {
  return age != null ? '$name is $age years old' : 'Name: $name';
}

// Named parameters
void createUser({required String name, required String email, int age = 18}) {
  print('User: $name, $email, $age');
}

void main() {
  // create user 
  createUser(name: 'John', email: 'john@example.com');
  print('${describe('Abdelkader')}');
}
