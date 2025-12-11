abstract class Describable {
  String describe();
}

mixin Audited {
  DateTime get createdAt => DateTime.now();
}

enum Role with Audited implements Describable {
  admin('all'),
  user('limited'),
  guest('read');

  const Role(this.scope);
  final String scope;

  @override
  String describe() => '$name:$scope at $createdAt';
}

void main() {
  for (final role in Role.values) {
    print(role.describe());
  }
}
