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
  print('Starting......');
  final rp = ReceivePort();
  Isolate isolate = await Isolate.spawn<SendPort>(_getSum, rp.sendPort);
  rp.listen((message) {
    print(message);
    rp.close(); // i send you the data but you didn't get this data
    isolate.kill(); // kill the isolate
  });
  print('end of the code ');
}

// void main() async {
//   print('Starting......');
//   final rp = ReceivePort();
//   await Isolate.spawn<SendPort>(_getSum, rp.sendPort);
//   .first returns a Future Automatically closes the subscription after getting the first event
//    first listen to the the stream and wait for the first event to arrive and return future with the first value of the stream
//   final message = await rp.first;
//   print('Message: $message');
//   print('end of the code ');
// }
