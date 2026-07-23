import 'dart:convert';
import 'dart:io';

import '../domain/order.dart';
import 'order_repository.dart';

class FileOrderRepository extends OrderRepository {
  final String path;
  FileOrderRepository(this.path);

  File get _file => File(path);

  @override
  void save(Order order) {
    final exisiting = loadAll();
    exisiting.add(order.toJson());
    _file.writeAsStringSync(
      const JsonEncoder.withIndent(' ').convert(exisiting),
    );
  }

  @override
  List<Map<String, dynamic>> loadAll() {
    if (!_file.existsSync()) return [];
    try {
      final raw = jsonDecode(_file.readAsStringSync()); // List<dynamic>
      return List<Map<String, dynamic>>.from(raw);
    } catch (_) {
      return [];
    }
  }
}
