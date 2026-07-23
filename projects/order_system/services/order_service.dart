import '../domain/order.dart';
import '../domain/order_id.dart';
import '../repository/order_repository.dart';
import 'cart_service.dart';

class OrderService {
  final OrderRepository _orderRepository;
  OrderService(this._orderRepository);
  Order placeOrder(CartService cartService) {
    if (cartService.isEmpty) throw StateError('Cannot place an empty order');

    final order = Order(
      id: OrderId.generate(),
      items: cartService.snapshot(),
      subtotal: cartService.subtotal,
      discountAmount: cartService.discountAmount,
      total: cartService.total,
      placedAt: DateTime.now().toIso8601String(),
    );
    _orderRepository.save(order);
    cartService.clear();
    return order;
  }

  List<Map<String, dynamic>> orderHistory() => _orderRepository.loadAll();
}
