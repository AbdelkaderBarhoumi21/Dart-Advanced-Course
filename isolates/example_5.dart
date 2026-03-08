import 'dart:isolate';

void main(List<String> args) async {
  // Use file URI - relative path from the isolates directory
  // Isolate.spawnUri(): Spawns code from a different file (uses URI to a Dart file)
  final uri = Uri.file('isolates_packages.dart');
  final rp = ReceivePort();
  Isolate.spawnUri(uri, [], rp.sendPort);
  final firstMessage = await rp.first;
  print(firstMessage);
}
