void main(List<String> args) {
  final String? name = null;
  if (name == null) {
    print('first name value is null');
  } else {
    final int length = name.length;
    print(length);
    print('first name value is not null');
  }
}
