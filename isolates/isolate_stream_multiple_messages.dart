import 'dart:isolate';

class IsolateParams {
  final int number;
  final SendPort sendPort;
  final bool isActive;

  IsolateParams({
    required this.number,
    required this.sendPort,
    required this.isActive,
  });
}

void _getSum2(IsolateParams args) {
  int sum = 0;
  SendPort sp = args.sendPort;
  for (int i = 1; i < args.number; i++) {
    sum += i;
    sp.send('num: $i');
  }
  if (args.isActive) {
    sp.send('Sum: $sum');
  } else {
    sp.send('Sum = 0');
  }
}

void main() async {
  print('Starting.....');
  final rp = ReceivePort();
  await Isolate.spawn<IsolateParams>(
    _getSum2,
    IsolateParams(number: 5, sendPort: rp.sendPort, isActive: true),
  );

  rp.listen((sum) {
    // Dart doesn't check the type at compile time - it checks at runtime( for sum (dynamic))
    print('Received: $sum');
    if (sum.contains('Sum:')) {
      rp.close();
    }
  });

  print('Done!');
}
