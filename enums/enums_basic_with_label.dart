enum Status {
  pending,
  running,
  one;

  static String label(Status s) {
    switch (s) {
      case Status.pending:
        return 'Is Pending';
      case Status.running:
        return 'Is Running';
      case Status.one:
        return 'Is one';
    }
  }
}

void main() {
  final s = Status.running;
  print(s);

  print(s.name);
  print(Status.values.length);

  print(Status.label(Status.pending));
}
