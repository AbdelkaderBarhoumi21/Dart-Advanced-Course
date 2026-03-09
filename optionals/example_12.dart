void main(List<String> args) {
  String? firstName = null;
  String? lastName = 'Doe';

  // first callback give acess to first name if null return null else return first name
  // second callback give acess to last name if null return null else return last name
  final fullName =
      firstName.flatMap((f) => lastName.flatMap((l) => '$f $l')) ??
      'Either first or last name or both are null';
  print(fullName);
}

extension FlatMap<T> on T? {
  R? flatMap<R>(R? Function(T) callback) {
    final shadow = this;
    if (shadow == null) {
      return null;
    } else {
      return callback(shadow); // shadow now is not null
    }
  }
}
