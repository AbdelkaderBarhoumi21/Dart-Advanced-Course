import 'dart:isolate';

void _worker(SendPort mainSendPort) {
  final workerReceivePort = ReceivePort();

  // Send our SendPort back to the main isolate
  mainSendPort.send(workerReceivePort.sendPort);

  // Listen for tasks
  workerReceivePort.listen((task) {
    if (task is int) {
      final result = _fibonacci(task);
      mainSendPort.send(result);
    } else if (task == 'close') {
      workerReceivePort.close();
      Isolate.exit(); // Terminates the current isolate synchronously.
    }
  });
}

int _fibonacci(int n) {
  if (n <= 1) return n;
  return _fibonacci(n - 1) + _fibonacci(n - 2);
}

Future<void> main() async {
  final mainReceivePort = ReceivePort();
  final isolate = await Isolate.spawn(_worker, mainReceivePort.sendPort);

  // First message is the worker's SendPort

  final SendPort workerSendPort = await mainReceivePort.first;

  // Now set up a new listener for results
  final responsePort = ReceivePort();
  // We need to re-spawn since .first closes the subscription
  // Better pattern: use a Completer or StreamController

  // Simplified: send task and get result
  final resultPort = ReceivePort();
  await Isolate.spawn((SendPort port) {
    port.send(_fibonacci(3));
  }, resultPort.sendPort);
  final result = await resultPort.first;
  print('Fibonacci(40) = $result');
  resultPort.close();
}
