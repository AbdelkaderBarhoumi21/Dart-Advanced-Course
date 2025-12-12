void main() {
  // Set basics (unique values)
  var uniqueNumbers = {1, 2, 3, 3, 4}; // {1, 2, 3, 4}
  print(uniqueNumbers);
  Set<String> fruits = {'apple', 'banana'};

  // Set operations
  fruits.add('orange');
  print(fruits);
  fruits.addAll(['grape', 'melon']);
  print(fruits);
  fruits.remove('banana');
  print(fruits);

  var set1 = {1, 2, 3};
  var set2 = {3, 4, 5};
  print(set1.union(set2)); // {1, 2, 3, 4, 5}
  print(
    set1.intersection(set2),
  ); // {3} => Returns only elements that exist in BOTH sets.
  print(
    set1.difference(set2),
  ); // {1, 2} =>Returns elements from set1 that are NOT in set2.
}
