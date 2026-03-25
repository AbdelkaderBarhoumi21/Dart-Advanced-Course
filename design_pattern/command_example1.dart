// Command Interface
abstract class Command {
  void execute();
  void undo();
}

// Receiver - TextDocument
class TextDocument {
  String _content = '';

  String get content => _content;

  void insert(int position, String text) {
    _content = _content.substring(0, position) +
        text +
        _content.substring(position);
  }

  void delete(int position, int length) {
    _content =
        _content.substring(0, position) + _content.substring(position + length);
  }
}

// Concrete Commands
class InsertTextCommand implements Command {
  final TextDocument _doc;
  final int position;
  final String text;

  InsertTextCommand(this._doc, this.position, this.text);

  @override
  void execute() => _doc.insert(position, text);

  @override
  void undo() => _doc.delete(position, text.length);
}

class DeleteTextCommand implements Command {
  final TextDocument _doc;
  final int position;
  final int length;
  late String _deletedText;

  DeleteTextCommand(this._doc, this.position, this.length);

  @override
  void execute() {
    _deletedText = _doc.content.substring(position, position + length);
    _doc.delete(position, length);
  }

  @override
  void undo() => _doc.insert(position, _deletedText);
}

// Invoker - CommandHistory
class CommandHistory {
  final List<Command> _history = [];
  int _currentIndex = -1;

  void execute(Command command) {
    // Remove commands after current index (after undo)
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    command.execute();
    _history.add(command);
    _currentIndex++;
  }

  void undo() {
    if (_currentIndex >= 0) {
      _history[_currentIndex].undo();
      _currentIndex--;
    }
  }

  void redo() {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      _history[_currentIndex].execute();
    }
  }

  bool get canUndo => _currentIndex >= 0;
  bool get canRedo => _currentIndex < _history.length - 1;
}

void main() {
  final doc = TextDocument();
  final history = CommandHistory();

  print('📝 Text Editor with Undo/Redo\n');

  // Insert "Hello"
  print('➕ Insert "Hello"');
  history.execute(InsertTextCommand(doc, 0, 'Hello'));
  print('Content: "${doc.content}"\n');

  // Insert " World"
  print('➕ Insert " World"');
  history.execute(InsertTextCommand(doc, 5, ' World'));
  print('Content: "${doc.content}"\n');

  // Insert "!"
  print('➕ Insert "!"');
  history.execute(InsertTextCommand(doc, 11, '!'));
  print('Content: "${doc.content}"\n');

  // Undo last action
  print('⬅️ Undo');
  history.undo();
  print('Content: "${doc.content}"\n');

  // Undo again
  print('⬅️ Undo');
  history.undo();
  print('Content: "${doc.content}"\n');

  // Redo
  print('➡️ Redo');
  history.redo();
  print('Content: "${doc.content}"\n');

  // New command after undo (clears redo history)
  print('➕ Insert " from Dart"');
  history.execute(InsertTextCommand(doc, 11, ' from Dart'));
  print('Content: "${doc.content}"\n');

  print('Can Undo: ${history.canUndo}');
  print('Can Redo: ${history.canRedo}');
}
