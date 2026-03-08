import 'dart:isolate';

int _getSum() {
  // task heavy
  int sum = 0;
  for (int i = 1; i < 100000000; i++) {
    sum += i;
  }
  return sum;
}

Future<int> runIsolate() async {
  final result = await Isolate.run(() {
    int sum = 0;
    for (int i = 1; i < 100000000; i++) {
      sum += i;
    }
    return sum;
  });
  return result;
}
// runIsolate() async {
//   await Isolate.run(_getSum).then((value) {
//     print(value);
//   });
// }

void main() async {
  print('Starting.....');
  await runIsolate().then((value) {
    print(value);
  });
  print('End of the code');
}
// void main() async {
//   print('Starting.....');
//   final result = await Isolate.run(_getSum).then((value) {
//     print(value);
//   });

//   print(result); // null because run has auto cleanup

//   print('End of the code');
// }
// void main() async {
//   print('Starting.....');
//   final result = await Isolate.run(_getSum);
//   print(result);

//   print('End of the code');
// }
