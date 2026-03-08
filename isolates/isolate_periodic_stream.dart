import 'dart:isolate';

Future<void> _getMessages(SendPort mainSendPort) async {
  await for (final now in Stream.periodic(
    Duration(milliseconds: 200),
    (_) => DateTime.now().toIso8601String(),
  )) {
    mainSendPort.send(now);
  }
}

Stream<String> getMessages() {
  final recievePort = ReceivePort();
  return Isolate.spawn(_getMessages, recievePort.sendPort)
      .asStream()
      .asyncExpand((_) => recievePort)
      .takeWhile((element) => element is String)
      .cast();
}

void main(List<String> args) async {
  await for (final message in getMessages().take(10)) {
    print('Mssage: $message');
  }
}
