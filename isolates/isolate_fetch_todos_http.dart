import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      isCompleted: json['completed'],
    );
  }

  @override
  String toString() {
    return 'Todo(id: $id, userId: $userId, title: "$title", completed: $isCompleted)';
  }
}

Future<void> _parseJsonIsolateEntry(SendPort sp) async {
  // "Close" means "I'm done building the request, now send it"
  // UTF8 => response is a Stream<List<int>> (stream of byte chunks)
  // utf8.decoder converts bytes → readable text (String)
  // .join() combines all chunks into a single String
  // Result: "[{\"id\":1,\"title\":\"Buy milk\"},{\"id\":2,...}]" :json string
  // jsonDecode() parses the JSON string into Dart data structures
  final client = HttpClient();
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos');
  final request = await client.getUrl(uri);
  // Set proper headers
  request.headers.set('Accept', 'application/json');
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  final jsonData = jsonDecode(responseBody) as List<dynamic>;
  final todos = jsonData.map((map) => Todo.fromJson(map));
  sp.send(todos);
}

Future<void> main(List<String> args) async {
  final rp = ReceivePort();
  Isolate.spawn(_parseJsonIsolateEntry, rp.sendPort);

  final todos = rp
      .takeWhile((element) => element is Iterable<Todo>)
      .cast<Iterable<Todo>>()
      .take(1);

  await for (final todoList in todos) {
    print('Received ${todoList.length} todos:');
    for (final todo in todoList.take(5)) {
      print('  $todo');
    }
    print('  ... and ${todoList.length - 5} more');
  }
}
