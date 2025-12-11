enum Http {
  ok(200),
  notFound(404),
  serverError(500);

  const Http(this.code);
  final int code;

  static Http? fromCode(int c) {
    // Manual lookup to allow a nullable result without violating firstWhere's non-null return type
    for (final h in Http.values) {
      if (h.code == c) return h;
    }
    return null;
  }

  String describe() => '$name ($code)';
}

void main() {
  for (final code in [200, 404, 500, 418]) {
    final match = Http.fromCode(code);
    print('$code -> ${match?.describe() ?? "unknown"}');
  }
}
