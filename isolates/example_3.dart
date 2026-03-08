/// Example 3: Reusable Isolate Pattern
///
/// This example demonstrates how to keep an isolate alive and reuse it for
/// multiple messages, instead of creating a new isolate for each request.
///
/// ## Performance Benefits:
///
/// **Without Reuse (Example 2 pattern):**
/// - Each `getMessage()` call spawns a new isolate
/// - Isolate creation has overhead (memory allocation, context setup)
/// - For 100 messages = 100 isolates created and destroyed
/// - Expensive and wasteful
///
/// **With Reuse (This pattern):**
/// - Create isolate once via `Responder.create()`
/// - Send multiple messages through the same isolate
/// - For 100 messages = 1 isolate, 100 messages processed
/// - Much more efficient!
///
/// ## Cost Reduction:
///
/// 1. **Memory**: One isolate instead of N isolates
/// 2. **CPU**: Avoid repeated spawn/teardown overhead
/// 3. **Latency**: No spawn delay for subsequent messages
///
/// ## How It Works:
///
/// 1. `Responder.create()` spawns the isolate once
/// 2. Stores the `SendPort` for future communication
/// 3. `getMessage()` reuses the same isolate via the stored `SendPort`
/// 4. The isolate stays alive listening for messages via `await for`
/// 5. Multiple requests go through the same long-lived isolate
///
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

const messagesAndResponses = {
  '': 'Ask me a question like "How are you?"',
  'Hello': 'Hi',
  'How are you?': 'Fine',
  'What are you doing?': 'Learning about Isolates in Dart!',
  'Are you having fun?': 'Yeah sure!',
};

Future<void> _communicator(SendPort sp) async {
  final rp = ReceivePort();
  sp.send(rp.sendPort);

  final messages = rp.takeWhile((element) => element is String).cast<String>();

  await for (final message in messages) {
    for (final entry in messagesAndResponses.entries) {
      if (entry.key.trim().toLowerCase() == message.trim()) {
        sp.send(entry.value);
        continue; // skip to next message
      }
    }

  }
}

class Responder {
  final ReceivePort rp;
  final Stream<dynamic> broadcastRp;
  final SendPort communicatorSendPort;

  Responder({
    required this.rp,
    required this.broadcastRp,
    required this.communicatorSendPort,
  });

  static Future<Responder> create() async {
    final rp = ReceivePort();
    Isolate.spawn(_communicator, rp.sendPort);

    final broadcastRp = rp.asBroadcastStream();
    final SendPort communicatorSendPort = await broadcastRp.first;

    return Responder(
      rp: rp,
      broadcastRp: broadcastRp,
      communicatorSendPort: communicatorSendPort,
    );
  }

  Future<String> getMessage(String forGreeting) async {
    communicatorSendPort.send(forGreeting);

    return broadcastRp
        .takeWhile((element) => element is String)
        .cast<String>()
        .take(1)
        .first;
  }
}

void main(List<String> args) async {
  final responder = await Responder.create();
  do {
    stdout.write('Entre your message: ');
    final line = stdin.readLineSync(encoding: utf8);
    switch (line?.trim().toLowerCase()) {
      case null:
        continue;
      case 'exit':
        exit(0);
      default:
        final msg = await responder.getMessage(line!);
        print(msg);
    }
  } while (true);
}
