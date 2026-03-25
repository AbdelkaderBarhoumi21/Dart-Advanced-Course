abstract class FileSystemItem {
  String get name;
  int get size;
  void display({
    int indent = 0,
  }); // indent control the level of displaying file system hierarchy
}

// leaf
class File implements FileSystemItem {
  @override
  final String name;

  @override
  final int size;

  File(this.name, this.size);

  @override
  void display({int indent = 0}) {
    print('${'  ' * indent}📄 $name ($size KB)');
  }
}

// composite
class Folder implements FileSystemItem {
  Folder(this.name);
  final List<FileSystemItem> _children = [];

  @override
  final String name;
  @override
  int get size => _children.fold(0, (sum, item) => sum + item.size);
  @override
  void display({int indent = 0}) {
    print('${'  ' * indent}📁 $name ($size KB)');

    for (final child in _children) {
      child.display(indent: indent + 1);
    }
  }

  void add(FileSystemItem item) => _children.add(item);
}

void main() {
  final root = Folder('Project')
    ..add(File('main.dart', 10))
    ..add(File('pubspec.yaml', 5));
  final lib = Folder('lib')..add(File('app.dart', 20));
  final screens = Folder('screens')
    ..add(File('home.dart', 15))
    ..add(File('login.dart', 12));
  lib.add(screens);
  root.add(lib);

  root.display();
  // 📁 Projet (62 KB)
  //   📄 main.dart (10 KB)
  //   📄 pubspec.yaml (5 KB)
  //   📁 lib (47 KB)
  //     📄 app.dart (20 KB)
  //     📁 screens (27 KB)
  //       📄 home.dart (15 KB)
  //       📄 login.dart (12 KB)
}
