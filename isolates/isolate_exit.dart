import 'dart:isolate';

void _getSum(SendPort sp) {
  // task heavy
  int sum = 0;
  for (int i = 1; i < 1000; i++) {
    sum += i;

    if (sum > 1000) {
      Isolate.exit(sp, 'Sum :$sum');
    }
  }
  sp.send('Sum :$sum');
}

void main() async {
  print('Starting'); //sync
  final rp = ReceivePort();

  Isolate.spawn(_getSum, rp.sendPort);

  rp.listen((message) {
    print(message);
    rp.close(); // after first listen it's closed
  });

  print('end'); //sync
}
