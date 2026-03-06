import 'dart:async';
import 'dart:isolate';

class IsolateWorker {
  late Isolate _isolate;
  late SendPort _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  final _completerMap = <int, Completer<dynamic>>{};
  int _requestId = 0;

  Future<void> start() async {
    _isolate = await Isolate.spawn(_entryPoint, _receivePort.sendPort);
    final completer = Completer<SendPort>();
    _receivePort.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      } else if (message is Map) {
        final id = message['id'] as int;
        final result = message['result'];
        _completerMap[id]?.complete(result);
        _completerMap.remove(id);
      }
    });
    _sendPort = await completer.future;
  }

  Future<R> execute<R>(dynamic task) {
    // Step 1: Give this task a unique ID
    final id = _requestId++; // 0, 1, 2, 3...
    // Step 2: Create a Completer — an empty promise
    final completer = Completer<R>();
    // Step 3: Store it in a map so we can find it later
    _completerMap[id] = completer;
    // Step 4: Send the task to the worker with the ID
    _sendPort.send({'id': id, 'task': task});

    // Step 5: Return the future — caller will await this
    return completer.future; // NOT resolved yet, just waiting
  }

  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
    _receivePort.close();
  }

  static void _entryPoint(SendPort mainSendPort) {
    final workerPort = ReceivePort();
    mainSendPort.send(workerPort.sendPort);

    workerPort.listen((message) {
      if (message is Map) {
        final id = message['id'];
        final task = message['task'];

        // Process the task (example: heavy string processing)

        final result = _processTask(task);
        mainSendPort.send({'id': id, 'result': result});
      }
    });
  }

  static dynamic _processTask(dynamic task) {
    if (task is String) {
      // Simulate heavy work
      return task.toUpperCase().split('').reversed.join();
    }
    return null;
  }
}

void main() async {
  print('=== IsolateWorker Demo ===\n');
  // Create and start the worker
  final worker = IsolateWorker();
  print('Starting isolate worker...');
  await worker.start();
  print('Worker started!\n');

  // Test 1: Single task
  print('Test 1: Processing single task');
  final result1 = await worker.execute('Hello Dart');
  print('Result: $result1\n');

  // Test 2: Multiple tasks in parallel
  print('Test 2: Processing multiple tasks in parallel');
  final futures = [
    worker.execute('Isolates'),
    worker.execute('Are'),
    worker.execute('Powerful'),
  ];

  final results = await Future.wait(futures);
  print('Results: $results\n');

  // Test 3: Sequential tasks with different data
  print('Test 3: Sequential processing');
  for (var i = 1; i <= 3; i++) {
    final result = await worker.execute('Task $i');
    print('Task $i result: $result');
  }

  // Clean up
  print('\nCleaning up...');
  worker.dispose();
  print('Done!');
}
