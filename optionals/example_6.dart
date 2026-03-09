void main(List<String> args) {
  List<String?>? names;
  names?.add('Foo'); // if names not null use add if not skip the operation
  names?.add(null);
  print(names);

  final String? first = names?.first;
  print(first ?? 'No first name found');

  names = [];
  names.add('Baz');
  names.add(null);
  print(names);
}
