void main(List<String> args) {
  String? getFullNameOptional() {
    return null;
  }

  String getFullName() {
    return 'jhon doe';
  }

  final fullName = getFullNameOptional() ?? getFullName();
  print(fullName);

  final fullOptionalName = getFullNameOptional();
  fullOptionalName.describe();
}

extension Describe on Object? {
  void describe() {
    if (this == null) {
      print('object is null');
    } else {
      print('$runtimeType: $this');
    }
  }
}
