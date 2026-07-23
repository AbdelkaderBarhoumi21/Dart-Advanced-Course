import '../domain/order.dart';

abstract class OrderRepository {
  void save(Order order);
  List<Map<String, dynamic>> loadAll();
}
