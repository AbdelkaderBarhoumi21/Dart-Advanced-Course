import 'cart_item.dart';
import 'order_id.dart';

class Order {
  final OrderId id;
  final List<CartItem> items;
  final double subtotal;
  final double discountAmount;
  final double total;
  final String placedAt;
  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.placedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id.value,
    'items': items.map((item) => item.toJson()).toList(),
    'subtotal': subtotal,
    'discountAmount': discountAmount,
    'total': total,
    'placedAt': placedAt,
  };
}
