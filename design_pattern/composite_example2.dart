abstract class Permission {
  String get name;
  bool check(String action);
  void describe({int indent = 0});
}

// leaf
class SimplePermission implements Permission {
  SimplePermission(this.name, this._allowedActions);
  @override
  final String name;
  final List<String> _allowedActions;

  @override
  bool check(String action) => _allowedActions.contains(action);

  @override
  void describe({int indent = 0}) =>
      print('${'  ' * indent}Permission: $name ->$_allowedActions');
}

class PermissionGroup implements Permission {
  PermissionGroup(this.name);
  @override
  final String name;
  final List<Permission> _permission = [];

  @override
  bool check(String action) => _permission.any((p) => p.check(action));

  @override
  void describe({int indent = 0}) {
    print('${'  ' * indent}Groupe: $name');

    for (final permission in _permission) {
      permission.describe(indent: indent + 1);
    }
  }

  void add(Permission permission) => _permission.add(permission);
  void remove(Permission permission) => _permission.remove(permission);
}

void main() {
  final readPermission = SimplePermission('read', ['view', 'list', 'search']);
  final writePermission = SimplePermission('write', ['create', 'update']);
  final adminPermission = SimplePermission('admin', [
    'delete',
    'ban',
    'promote',
  ]);

  final editorGroup = PermissionGroup('Editor')
    ..add(readPermission)
    ..add(writePermission);
  final adminGroup = PermissionGroup('Admin')
    ..add(editorGroup)
    ..add(adminPermission);
  adminGroup.check('ban'); // true
  adminGroup.check('view'); // true
  editorGroup.check('delete'); // false
  adminGroup.describe();
  // Groupe: Admin
  //   Groupe: Editor
  //     Permission: read → [view, list, search]
  //     Permission: write → [create, update]
  //   Permission: admin → [delete, ban, promote]
}
