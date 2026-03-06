import 'dart:isolate';

void _worker(SendPort sendPort) {
  sendPort.send('Hello from the worker isolate');
}

Future<void> main() async {
  //receivePort.sendPort arg to _worker function
  final receivePort = ReceivePort();
  await Isolate.spawn(_worker, receivePort.sendPort);
  final message = await receivePort.first;
  print(message);
  receivePort.close();
}
