import 'dart:async';
import 'dart:isolate';

void _getSum(SendPort sp) {
  // task heavy
  int sum = 0;
  for (int i = 1; i < 5; i++) {
    sum += i;
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

  Future.delayed(Duration(seconds: 2), () {
    print('Event queue');
  });
  scheduleMicrotask(() {
    print('Schedule microtask1');
  });

  Future.microtask(() {
    print('Schedule microtask2');
  });

  print('end'); //sync
}
