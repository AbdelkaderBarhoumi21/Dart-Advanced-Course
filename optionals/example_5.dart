void main(List<String> args) {
  String? lastName;
  // ignore: dead_code
  print(lastName?.length);

  String? nullName;

  print(lastName ?? 'Foo');
  print(lastName ?? nullName);
  print(lastName ?? nullName ?? 'Bar');
}
