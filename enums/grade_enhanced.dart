enum Grade {
  a(4.0),
  b(3.0),
  c(2.0),
  d(1.0),
  f(0.0);

  const Grade(this.gpa);
  final double gpa;

  bool get isPassing => gpa >= 2.0;
}

Grade? fromLetter(String letter) {
  switch (letter.toLowerCase()) {
    case 'a':
      return Grade.a;
    case 'b':
      return Grade.b;
    case 'c':
      return Grade.c;
    case 'd':
      return Grade.d;
    case 'f':
      return Grade.f;
    default:
      return null;
  }
}

void main() {
  for (final grade in Grade.values) {
    print('${grade.name} -> gpa ${grade.gpa}, passing=${grade.isPassing}');
  }
  print('fromLetter("B"): ${fromLetter("B")?.gpa}');
  print('fromLetter("X"): ${fromLetter("X")}');
}
