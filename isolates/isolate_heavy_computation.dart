import 'dart:isolate';

class IsolateParams {
  final int number;
  final SendPort sendPort;

  IsolateParams(this.number, this.sendPort);
}

void _getSum(SendPort sp) {
  // task heavy
  int sum = 0;
  for (int i = 1; i < 100000000; i++) {
    sum += i;
  }
  sp.send('Sum :$sum');
}

void _getSum2(IsolateParams args) {
  int sum = 0;
  for (int i = 1; i < args.number; i++) {
    sum += i;
  }
  SendPort sp = args.sendPort;
  sp.send('Sum: $sum');
}
// void _getSum2(Map<String, dynamic> args) {
//   int sum = 0;
//   for (int i = 1; i < args['number']; i++) {
//     sum += i;
//   }
//   SendPort sp = args['sendPort'];
//   sp.send('Sum: $sum');
// }

void main() async {
  print('Starting.....');
  final rp = ReceivePort();
  await Isolate.spawn<IsolateParams>(_getSum2, IsolateParams(100, rp.sendPort));
  // await Isolate.spawn<Map<String, dynamic>>(_getSum2, {
  //   'number': 100,
  //   'sendPort': rp.sendPort,
  // });

  // Wait for the result from the isolate
  rp.listen((sum) {
    print('Sum: $sum');
    rp.close(); // after first listen it's closed
  });
  // final result = await rp.first;
  // print(result);

  print('Done!');
}
