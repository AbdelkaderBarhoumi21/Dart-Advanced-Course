enum Status { pending, running, done }

void main() {
  final s = Status.running;
  print(s);
  print('name=${s.name}');
  print('count=${Status.values.length}');
}
