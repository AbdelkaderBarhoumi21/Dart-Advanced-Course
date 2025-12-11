enum Http {
  ok,
  notFound,
  serverError,
}

String severity(Http h) => switch (h) {
      Http.ok => 'none',
      Http.notFound => 'low',
      Http.serverError => 'high',
    };

enum Role { admin, user, guest }

String route(Role r) => switch (r) {
      Role.admin => '/admin',
      Role.user => '/home',
      Role.guest => '/login',
    };

void main() {
  for (final h in Http.values) {
    print('$h -> severity ${severity(h)}');
  }
  for (final r in Role.values) {
    print('$r -> route ${route(r)}');
  }
}
