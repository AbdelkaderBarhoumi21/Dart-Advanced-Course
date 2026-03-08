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
  ReceivePort rp = ReceivePort();
  SendPort sp = args.sendPort;
  sp.send(rp.sendPort);
  rp.listen((message) {
    print(message);
  });
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

  SendPort? sendPort;

  rp.listen((message) {
    // Dart doesn't check the type at compile time - it checks at runtime( for sum (dynamic))
    print(message);
    if (message is String) {
      if (message.contains('num: 3')) {
        sendPort?.send('welcome');
      }
      if (message.contains('num: 4')) {
        sendPort?.send('Good morning');
      }

      if (message.contains('Sum:')) {
        rp.close();
      }
    } else if (message is SendPort) {
      sendPort = message;
      sendPort?.send('Hello');
    }
  });

  print('Done!');
}
