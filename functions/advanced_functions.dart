// Function as parameter

void executeOperation(int a, int b, int Function(int, int) operation) {
  print('Result: ${operation(a, b)}');
}

//Function return a functions
Function makeMultiplier(int factor) {
  return (int value) => value * factor;
}

//Typedef
typedef Operation = int Function(int, int);

Operation getOperation(String type) {
  switch (type) {
    case 'add':
      return (a, b) => a + b;
    case 'subtract':
      return (a, b) => a - b;
    default:
      return (a, b) => 0;
  }
}

void main() {
  final double = makeMultiplier(2);
  print('Result of multiplication: ${double(2)}');
  Operation myAdd = getOperation('add');
  Operation mySub = getOperation('subtract');
  print('Add: ${myAdd(20, 5)}'); // 25
  print('Subtract: ${mySub(20, 5)}'); // 15

  executeOperation(5, 10, (x, y) => x + y);
}
