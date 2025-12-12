void main() {
  var numbers = [1, 2, 3, 4, 5];
  numbers.add(6);
  print(numbers);
  numbers.addAll([7, 8]);
  print(numbers);
  numbers.insert(0, 0);
  print(numbers);
  numbers.remove(3);
  print(numbers);
  numbers.removeAt(0);
  print(numbers);
  // numbers.clear();
  // print(numbers);

  var doubled = numbers.map((n) => n * 2).toList();
  print(doubled);
  var evens = numbers.where((n) => n.isEven).toList();
  print(evens);
  var sums = numbers.reduce((a, b) => a + b);
  print(sums);
  var hasLarge = numbers.any((n) => n > 100); // true or false
  print(hasLarge);
  var allPositive = numbers.every((n) => n > 100);
  print(allPositive);

  //spread operators
  var more = [...numbers, 9, 10];
  print(more);

  var combined = [...numbers, ...doubled];
  print(combined);

  //collection if & for
  var values = [1, 2, for (var i = 4; i <= 6; i++) i];
  print(values);

  List<String> names = ['Abdelkader', 'Mohamed', 'Mourad'];
  print(names);
}
