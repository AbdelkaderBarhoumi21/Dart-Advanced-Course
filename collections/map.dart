void main() {
  Map<String, int> scores = {'Alice': 95, 'Bob': 87};

  scores['Alice'] = 92;
  print(scores);
  scores.remove('Bob');
  print(scores);

  scores.update('Alice', (value) => value + 5);
  print(scores);

  scores.putIfAbsent('David', () => 50);
  print(scores);
  scores.forEach((key, value) {
    print('$key - $value');
  });

  for (var entry in scores.entries) {
    print('Iterable ${entry.key} - ${entry.value}');
  }

  /// An Iterable is a collections (List, Set, Map) that allows you to loop through elements one by one
  /// using loops or methods like .forEach(), .map(), .where().
  /// entires in Map return and Iterable of K-V pairs (MapEntry objects) from a map
  var keys = scores.keys.toList();
  print(keys);
  var values = scores.values.toList();
  print(values);
  var entries = scores.entries.map((e) => 'entires: ${e.key} - ${e.value}');
  print(entries.toList());
}
