enum Role { admin, user, guest }

extension RoleX on Role {
  String describe() => switch (this) {
    Role.admin => 'Admin: full access',
    Role.user => 'User: standard access',
    Role.guest => 'Guest: read-only',
  };
}

void main() {
  //build a Map<Role,String> called labels
  final labels = {for (final r in Role.values) r: r.describe()};

  for (final entry in labels.entries) {
    print('${entry.key} - ${entry.value}');
  }
}
